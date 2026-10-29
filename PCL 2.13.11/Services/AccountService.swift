import Foundation
import Security

nonisolated struct AccountCredentials: Codable, Sendable {
    var refreshToken: String
    var minecraftToken: String
    var expiresAt: Date
}
nonisolated struct DeviceAuthorization: Sendable {
    let code: String
    let url: String
    let expires: Int
}
nonisolated enum SecureStore {
    private static let service = "com.wuxiaoguo.PCL-macOS-Community.accounts"
    static func save(_ credentials: AccountCredentials, id: String) throws {
        let data = try JSONEncoder().encode(credentials)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: id]
        let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        if status == errSecItemNotFound {
            var add = query; add[kSecValueData as String] = data; add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            let result = SecItemAdd(add as CFDictionary, nil)
            guard result == errSecSuccess else { throw LauncherError.message("无法将登录凭据写入钥匙串（\(result)）。") }
        } else if status != errSecSuccess { throw LauncherError.message("无法更新钥匙串（\(status)）。") }
    }
    static func load(id: String) throws -> AccountCredentials {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: id, kSecReturnData as String: true, kSecMatchLimit as String: kSecMatchLimitOne]
        var value: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &value)
        guard status == errSecSuccess, let data = value as? Data else { throw LauncherError.message("未找到账号登录凭据，请重新登录（\(status)）。") }
        return try JSONDecoder().decode(AccountCredentials.self, from: data)
    }
    static func remove(id: String) throws {
        let status = SecItemDelete([kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: id] as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw LauncherError.message("移除登录凭据失败（\(status)）。") }
    }
}

actor AccountService {
    let http = HTTPClient.shared
    private let authority = "https://login.microsoftonline.com/consumers/oauth2/v2.0/"
    func login(clientID: String, showCode: @escaping @Sendable (DeviceAuthorization) async -> Void) async throws -> GameSession {
        guard UUID(uuidString: clientID) != nil else { throw LauncherError.message("请先在设置填写自己的微软应用 Client ID。原始 PCL 源码也未附带此凭据。") }
        let device = try await http.form(authority + "devicecode", fields: ["client_id": clientID, "scope": "XboxLive.signin offline_access"])
        guard let deviceCode = device["device_code"].string, let code = device["user_code"].string, let url = device["verification_uri"].string else { throw LauncherError.message("微软未返回完整的设备登录信息。") }
        _ = try HTTPClient.url(url)
        let expires = device["expires_in"].int ?? 900
        await showCode(.init(code: code, url: url, expires: expires))
        var interval = max(1, device["interval"].int ?? 5)
        let deadline = Date().addingTimeInterval(TimeInterval(expires))
        while Date() < deadline {
            try await Task.sleep(nanoseconds: UInt64(interval) * 1_000_000_000)
            try Task.checkCancellation()
            do {
                let token = try await http.form(authority + "token", fields: ["client_id": clientID, "grant_type": "urn:ietf:params:oauth:grant-type:device_code", "device_code": deviceCode])
                guard let access = token["access_token"].string, let refresh = token["refresh_token"].string else { throw LauncherError.message("微软返回的令牌不完整。") }
                return try await exchange(oauth: access, refresh: refresh, clientID: clientID)
            } catch let failure as HTTPFailure {
                let response = try? JSONDecoder().decode(JSONValue.self, from: failure.body)
                switch response?["error"].string {
                case "authorization_pending": continue
                case "slow_down": interval += 5; continue
                case "authorization_declined", "access_denied": throw LauncherError.message("你已取消微软登录。")
                case "expired_token": throw LauncherError.message("设备登录码已过期，请重新登录。")
                default: throw LauncherError.message("微软登录失败（\(failure.status)，\(response?["error"].string ?? "未知错误")）。请检查应用是否允许个人账号与公共客户端登录。")
                }
            }
        }
        throw LauncherError.message("设备登录码已过期，请重新登录。")
    }
    func refresh(_ account: GameAccount) async throws -> GameSession {
        let credentials = try SecureStore.load(id: account.id)
        if credentials.expiresAt > Date().addingTimeInterval(120) {
            return .init(account: account, accessToken: credentials.minecraftToken)
        }
        guard let clientID = account.clientID, !clientID.isEmpty else { throw LauncherError.message("该账号缺少 Client ID，请重新登录。") }
        let token = try await http.form(authority + "token", fields: ["client_id": clientID, "grant_type": "refresh_token", "refresh_token": credentials.refreshToken, "scope": "XboxLive.signin offline_access"])
        guard let access = token["access_token"].string else { throw LauncherError.message("账号登录已过期，请重新登录。") }
        return try await exchange(oauth: access, refresh: token["refresh_token"].string ?? credentials.refreshToken, clientID: clientID)
    }
    private func exchange(oauth: String, refresh: String, clientID: String) async throws -> GameSession {
        let xbl = try await http.post("https://user.auth.xboxlive.com/user/authenticate", json: .object([
            "Properties": .object(["AuthMethod": .string("RPS"), "SiteName": .string("user.auth.xboxlive.com"), "RpsTicket": .string("d=" + oauth)]),
            "RelyingParty": .string("http://auth.xboxlive.com"), "TokenType": .string("JWT")
        ]))
        guard let xblToken = xbl["Token"].string else { throw LauncherError.message("Xbox 认证未返回令牌。") }
        let xsts: JSONValue
        do {
            xsts = try await http.post("https://xsts.auth.xboxlive.com/xsts/authorize", json: .object([
                "Properties": .object(["SandboxId": .string("RETAIL"), "UserTokens": .array([.string(xblToken)])]),
                "RelyingParty": .string("rp://api.minecraftservices.com/"), "TokenType": .string("JWT")
            ]))
        } catch let failure as HTTPFailure {
            let body = try? JSONDecoder().decode(JSONValue.self, from: failure.body)
            let code = body?["XErr"].int ?? 0
            let reason = [2148916233: "此微软账号尚未建立 Xbox 档案，请先访问 xbox.com 完成注册。", 2148916238: "儿童账号需要通过微软家庭设置获得访问 Xbox Live 的授权。", 2148916235: "当前地区无法使用 Xbox Live。", 2148916227: "此账号无法访问 Xbox Live。"]
            throw LauncherError.message(reason[code] ?? "Xbox 授权失败（\(failure.status)，错误码 \(code)）。")
        }
        guard let token = xsts["Token"].string, let uhs = xsts["DisplayClaims"]["xui"].array.first?["uhs"].string else { throw LauncherError.message("Xbox 授权信息不完整。") }
        let mc = try await http.post("https://api.minecraftservices.com/authentication/login_with_xbox", json: .object(["identityToken": .string("XBL3.0 x=\(uhs);\(token)")]))
        guard let access = mc["access_token"].string else { throw LauncherError.message("Minecraft 认证未返回令牌。") }
        let headers = ["Authorization": "Bearer " + access]
        let entitlements = try JSONDecoder().decode(JSONValue.self, from: await http.data("https://api.minecraftservices.com/entitlements/mcstore", headers: headers))
        guard !entitlements["items"].array.isEmpty else { throw LauncherError.message("该账号未购买 Minecraft Java 版，或 Game Pass 已过期。请购买正版后重试。") }
        let profile = try JSONDecoder().decode(JSONValue.self, from: await http.data("https://api.minecraftservices.com/minecraft/profile", headers: headers))
        guard let id = profile["id"].string, let name = profile["name"].string else { throw LauncherError.message("请先在 minecraft.net 创建 Java 版玩家档案。") }
        let account = GameAccount(id: id, name: name, kind: "msa", clientID: clientID)
        try SecureStore.save(.init(refreshToken: refresh, minecraftToken: access, expiresAt: Date().addingTimeInterval(TimeInterval(mc["expires_in"].int ?? 86400) - 120)), id: id)
        return .init(account: account, accessToken: access)
    }
}
