## LICENCE (50 lines)


## PCLCS/Configs.cs (20 lines)
2: public static class Configs {

## PCLCS/Constants.cs (80 lines)
7: public enum ResourceTypes {
32: public enum ResourcePlatforms {
42: public enum ModLoaders {
54: public enum DonationRank {
63: public static class Versions {

## PCLCS/Java.cs (252 lines)
99: public static class JavaUtils {

## PCLCS/Launch/LaunchUtils.cs (30 lines)
3: public static class LaunchUtils {

## PCLCS/PCLCS.csproj (69 lines)


## PCLCS/Resource/Resource.cs (31 lines)
2: public static class Resource {

## PCLCS/Resource/WikiEntries.txt (28881 lines)


## PCLCS/Resource/WikiEntry.cs (83 lines)
7: public class WikiEntry {

## Plain Craft Launcher 2/App.config (32 lines)


## Plain Craft Launcher 2/Application.xaml (526 lines)


## Plain Craft Launcher 2/Application.xaml.vb (288 lines)
4: Public Class Application
7: Private Sub Application_Startup(sender As Object, e As StartupEventArgs) Handles Me.Startup
150: Private Shared Sub WaitingMutex(e As StartupEventArgs)
179: Private Sub Application_SessionEnding(sender As Object, e As SessionEndingCancelEventArgs) Handles Me.SessionEnding
184: Private Sub Application_DispatcherUnhandledException(sender As Object, e As DispatcherUnhandledExceptionEventArgs) Handles Me.DispatcherUnhandledException
207: Private Shared Sub OldEnvironmentAssert(Optional ex As Exception = Nothing)
217: Private Sub New() '这里必须尽早调用，且不能使用任何库，否则加载 MeloongCore 就会导致崩溃
233: Private Shared Sub ExtractLibwebp() '这个方法会调用 ModBase，进而调用 MeloongCore，所以不能放在 New 里
244: Private Sub MyIconButton_Click(sender As Object, e As EventArgs)

## Plain Craft Launcher 2/Controls/Behaviors/ClipboardInterceptor.vb (199 lines)
20: Private Sub New()
27: Public Shared Sub SetEnableSafeClipboard(element As DependencyObject, value As Boolean)
31: Public Shared Function GetEnableSafeClipboard(element As DependencyObject) As Boolean
35: Private Shared Sub OnEnableSafeClipboardChanged(d As DependencyObject, e As DependencyPropertyChangedEventArgs)
45: Private Shared Sub AddCommandBindingsToTextBox(tb As TextBox)
51: Private Shared Sub AddCommandBindingsToRichTextBox(rtb As RichTextBox)
57: Private Shared Sub AddCommandBindingsToDataGrid(dg As DataGrid)
61: Private Shared Sub OnCopyTextBox(sender As Object, e As ExecutedRoutedEventArgs)
75: Private Shared Sub OnCutTextBox(sender As Object, e As ExecutedRoutedEventArgs)
90: Private Shared Sub OnPasteTextBox(sender As Object, e As ExecutedRoutedEventArgs)
114: Private Shared Sub OnCopyRichTextBox(sender As Object, e As ExecutedRoutedEventArgs)
131: Private Shared Sub OnCutRichTextBox(sender As Object, e As ExecutedRoutedEventArgs)
149: Private Shared Sub OnPasteRichTextBox(sender As Object, e As ExecutedRoutedEventArgs)
171: Private Shared Sub OnCopyDataGrid(sender As Object, e As ExecutedRoutedEventArgs)

## Plain Craft Launcher 2/Controls/Behaviors/Interfaces.vb (23 lines)
7: Sub Refresh()
14: Sub DispatcherUnhandledException(sender As Object, e As DispatcherUnhandledExceptionEventArgs)

## Plain Craft Launcher 2/Controls/Behaviors/LazyLoadBehavior.vb (46 lines)
1: Public Class LazyLoadBehavior
6: Public Shared Sub OnFirstEnterScrollViewerViewport(obj As DependencyObject, value As Action)
14: Private Shared Sub OnIsInViewportChanged(d As DependencyObject, e As DependencyPropertyChangedEventArgs)
38: Private Shared Function FindParentScrollViewer(d As DependencyObject) As ScrollViewer

## Plain Craft Launcher 2/Controls/MyButton.xaml (16 lines)


## Plain Craft Launcher 2/Controls/MyButton.xaml.vb (176 lines)
4: Public Class MyButton
46: Public Enum ColorState
74: Private Sub RefreshColor(Optional obj = Nothing, Optional e = Nothing) Handles Me.MouseEnter, Me.MouseLeave, Me.Loaded, Me.IsEnabledChanged
145: Private Sub Button_MouseUp(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonUp
151: Private Sub Button_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonDown
159: Private Sub Button_MouseEnter() Handles Me.MouseEnter
162: Private Sub Button_MouseUp() Handles Me.MouseLeftButtonUp
169: Private Sub Button_MouseLeave() Handles Me.MouseLeave

## Plain Craft Launcher 2/Controls/MyCard.vb (400 lines)
1: Public Class MyCard
65: Public Sub New()
76: Private Sub Init() Handles Me.Loaded
105: Public Sub StackInstall()
109: Public Shared Sub StackInstall(ByRef Stack As StackPanel, Type As Integer, Optional CardTitle As String = "")
178: Private Sub MyCard_MouseEnter(sender As Object, e As MouseEventArgs) Handles Me.MouseEnter
189: Private Sub MyCard_MouseLeave(sender As Object, e As MouseEventArgs) Handles Me.MouseLeave
201: #Region "高度改变动画"
209: Private Sub MySizeChanged(sender As Object, e As SizeChangedEventArgs) Handles Me.SizeChanged
216: Private Sub StartHeightAnimation(Delta As Double, PreviousHeight As Double, IsLoadAnimation As Boolean)
266: Public Sub TriggerForceResize()
274: #Region "折叠"
326: Private Sub MyCard_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonDown
335: Private Sub MyCard_MouseLeftButtonUp() Handles Me.MouseLeftButtonUp
358: Private Sub MyCard_MouseLeave_Swap(sender As Object, e As MouseEventArgs) Handles Me.MouseLeave
361: Private Sub UpdateCursorStyle() Handles Me.MouseMove
371: Partial Public Module ModAnimation
372: Public Sub AniDispose(Control As MyCard, RemoveFromChildren As Boolean, Optional CallBack As ParameterizedThreadStart = Nothing)

## Plain Craft Launcher 2/Controls/MyCheckBox.xaml (14 lines)


## Plain Craft Launcher 2/Controls/MyCheckBox.xaml.vb (230 lines)
4: Public Class MyCheckBox
39: Public Sub SetChecked(value As Boolean, user As Boolean)
65: Private Sub SyncUI()
134: Private Sub Checkbox_MouseUp() Handles Me.MouseLeftButtonUp
141: Private Sub Checkbox_MouseDown() Handles Me.MouseLeftButtonDown
155: Private Sub Checkbox_MouseLeave() Handles Me.MouseLeave
173: Private Sub Checkbox_IsEnabledChanged() Handles Me.IsEnabledChanged
196: Private Sub Checkbox_MouseEnterAnimation() Handles Me.MouseEnter
204: Private Sub Checkbox_MouseLeaveAnimation() Handles Me.MouseLeave
214: #Region "设置"
216: Private Sub RefreshSetting(NewValue As String) Implements ISettingControl.RefreshSetting
220: Private Function GetCurrentSetting() As String Implements ISettingControl.GetCurrentSetting
224: Private Sub SaveSetting() Handles Me.Change

## Plain Craft Launcher 2/Controls/MyComboBox.vb (173 lines)
1: Public Class MyComboBox
56: Private Sub MyComboBox_PreviewMouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonDown
59: Private Sub MyComboBox_PreviewMouseLeftButtonUp(sender As Object, e As EventArgs) Handles Me.PreviewMouseLeftButtonUp, Me.MouseLeave
64: Public Sub RefreshColor() Handles Me.IsEnabledChanged, Me.MouseEnter, Me.MouseLeave, Me.PreviewMouseLeftButtonDown, Me.PreviewMouseLeftButtonUp, Me.GotKeyboardFocus
104: Private Sub MyComboBox_DropDownOpened(sender As Object, e As EventArgs) Handles Me.DropDownOpened
114: Private Sub MyComboBox_DropDownClosed(sender As Object, e As EventArgs) Handles Me.DropDownClosed
120: Private Sub MyComboBox_TextChanged(sender As Object, e As TextChangedEventArgs) Handles Me.TextChanged
138: Private Sub MyComboBox_SelectionChanged(sender As Object, e As SelectionChangedEventArgs) Handles Me.SelectionChanged
142: #Region "设置"
144: Private Sub RefreshSetting(NewValue As String) Implements ISettingControl.RefreshSetting
157: Private Function GetCurrentSetting() As String Implements ISettingControl.GetCurrentSetting
166: Private Sub SaveSetting() Handles Me.SelectionChanged

## Plain Craft Launcher 2/Controls/MyComboBoxItem.vb (67 lines)
1: Public Class MyComboBoxItem
7: Public Sub New()
17: Private Sub RefreshColor() Handles Me.Unselected, Me.MouseMove, Me.MouseLeave, Me.Selected, Me.IsEnabledChanged
63: Private Sub MyComboBoxItem_MouseLeftButtonUp(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonUp

## Plain Craft Launcher 2/Controls/MyDropShadow.vb (324 lines)
1: Public Class MyDropShadow
43: Private Shared Function IsCornerRadiusValid(value As Object) As Boolean
168: Private Enum Placement
184: Private Shared Sub ClearBrushes(o As DependencyObject, e As DependencyPropertyChangedEventArgs)
187: Private Function CreateStops(c As Color, cornerRadius As Double) As GradientStopCollection
205: Private Function CreateBrushes(c As Color, cornerRadius As CornerRadius) As Brush()
300: Private Function GetBrushes(c As Color, cornerRadius As CornerRadius) As Brush()

## Plain Craft Launcher 2/Controls/MyExtraButton.xaml (30 lines)


## Plain Craft Launcher 2/Controls/MyExtraButton.xaml.vb (217 lines)
1: Public Class MyExtraButton
80: Public Sub ShowRefresh()
85: Private Sub Button_LeftMouseUp(sender As Object, e As MouseButtonEventArgs) Handles PanClick.MouseLeftButtonUp
93: Private Sub Button_RightMouseUp(sender As Object, e As MouseButtonEventArgs) Handles PanClick.MouseRightButtonUp
114: Private Sub Button_LeftMouseDown(sender As Object, e As MouseButtonEventArgs) Handles PanClick.MouseLeftButtonDown
124: Private Sub Button_RightMouseDown(sender As Object, e As MouseButtonEventArgs) Handles PanClick.MouseRightButtonDown
135: Private Sub Button_LeftMouseUp() Handles PanClick.MouseLeftButtonUp
145: Private Sub Button_RightMouseUp() Handles PanClick.MouseRightButtonUp
155: Private Sub Button_MouseLeave() Handles PanClick.MouseLeave
168: Public Sub RefreshColor() Handles PanClick.MouseEnter, PanClick.MouseLeave, Me.Loaded, Me.IsEnabledChanged
203: Public Sub Ribble()

## Plain Craft Launcher 2/Controls/MyExtraTextButton.xaml (33 lines)


## Plain Craft Launcher 2/Controls/MyExtraTextButton.xaml.vb (163 lines)
4: Public Class MyExtraTextButton
83: Private Sub Button_LeftMouseUp(sender As Object, e As MouseButtonEventArgs) Handles PanClick.MouseLeftButtonUp
94: Private Sub Button_LeftMouseDown(sender As Object, e As MouseButtonEventArgs) Handles PanClick.MouseLeftButtonDown
104: Private Sub Button_LeftMouseUp() Handles PanClick.MouseLeftButtonUp
111: Private Sub Button_RightMouseUp() Handles PanClick.MouseRightButtonUp
119: Private Sub Button_MouseLeave() Handles PanClick.MouseLeave
131: Public Sub RefreshColor() Handles PanClick.MouseEnter, PanClick.MouseLeave, Me.Loaded, Me.IsEnabledChanged

## Plain Craft Launcher 2/Controls/MyHint.xaml (16 lines)


## Plain Craft Launcher 2/Controls/MyHint.xaml.vb (148 lines)
4: Public Class MyHint
22: Public Enum Themes
37: Private Sub UpdateUI() Handles Me.Loaded
101: Private Sub MyHint_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
104: Private Sub BtnClose_Click(sender As Object, e As EventArgs) Handles BtnClose.Click
112: Private Sub MyHint_MouseUp(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonUp
121: Private Sub MyHint_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonDown
124: Private Sub MyHint_MouseLeave() Handles Me.MouseLeave
129: Partial Public Module ModAnimation
130: Public Sub AniDispose(Control As MyHint, RemoveFromChildren As Boolean, Optional CallBack As ParameterizedThreadStart = Nothing)

## Plain Craft Launcher 2/Controls/MyIconButton.xaml (15 lines)


## Plain Craft Launcher 2/Controls/MyIconButton.xaml.vb (187 lines)
3: Public Class MyIconButton
31: Public Enum Themes
56: Private Sub Button_MouseUp(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonUp
65: Private Sub Button_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonDown
72: Private Sub Button_MouseUp() Handles Me.MouseLeftButtonUp
83: Private Sub Button_MouseLeave() Handles Me.MouseLeave
95: Public Sub RefreshAnim() Handles Me.MouseEnter, Me.MouseLeave, Me.Loaded, Me.IsEnabledChanged
171: Partial Public Module ModAnimation
172: Public Sub AniDispose(Control As MyIconButton, RemoveFromChildren As Boolean, Optional CallBack As ParameterizedThreadStart = Nothing)

## Plain Craft Launcher 2/Controls/MyIconTextButton.xaml (9 lines)


## Plain Craft Launcher 2/Controls/MyIconTextButton.xaml.vb (173 lines)
4: Public Class MyIconTextButton
50: Public Enum ColorState
71: Private Sub MyIconTextButton_MouseUp() Handles Me.MouseLeftButtonUp
79: Private Sub MyIconTextButton_MouseDown() Handles Me.MouseLeftButtonDown
83: Private Sub MyIconTextButton_MouseLeave() Handles Me.MouseLeave
92: Private Sub RefreshColor(Optional obj = Nothing, Optional e = Nothing) Handles Me.MouseEnter, Me.Loaded, Me.IsEnabledChanged

## Plain Craft Launcher 2/Controls/MyImage.vb (156 lines)
1: Public Class MyImage
4: #Region "公开属性"
101: Private Sub Load() _

## Plain Craft Launcher 2/Controls/MyListItem.xaml (27 lines)


## Plain Craft Launcher 2/Controls/MyListItem.xaml.vb (657 lines)
4: Public Class MyListItem
12: #Region "后加载控件"
82: #Region "自定义属性"
288: Public Enum CheckType
329: Private Sub OnSizeChanged() Handles Me.SizeChanged
358: Public Sub SetChecked(value As Boolean, user As Boolean, anime As Boolean)
503: #Region "点击"
506: Private Sub Button_MouseUp(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonUp
531: Private Sub Button_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonDown
537: Private Sub Button_MouseLeave(sender As Object, e As Object) Handles Me.MouseLeave, Me.PreviewMouseLeftButtonUp
546: Public Sub RefreshColor(sender As Object, e As EventArgs) Handles Me.MouseEnter, Me.MouseLeave, Me.PreviewMouseLeftButtonDown, Me.PreviewMouseLeftButtonUp
635: Private Sub MyListItem_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded

## Plain Craft Launcher 2/Controls/MyLoading.xaml (37 lines)


## Plain Craft Launcher 2/Controls/MyLoading.xaml.vb (276 lines)
3: Public Class MyLoading
12: #Region "颜色"
23: Public Sub New()
30: #Region "文本"
70: Private Sub RefreshText() Handles Me.IsErrorChanged, Me.Loaded, _State.ProgressChanged
96: #Region "状态改变"
99: Public Enum MyLoadingState
118: Private Sub InitState() Handles Me.Loaded
124: Private Sub RefreshState() Handles _State.LoadingStateChanged, Me.Loaded, Me.Unloaded
166: #Region "动画"
177: Private Sub AniLoop()
212: Private Sub ErrorAnimation(sender As Object, isError As Boolean)
233: #Region "点击事件"
235: Private Sub Button_MouseUp(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonUp
239: Private Sub Button_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonDown
243: Private Sub Button_MouseLeave(sender As Object, e As Object) Handles Me.MouseLeave, Me.MouseLeftButtonUp
258: Public Class MyLoadingStateSimulator

## Plain Craft Launcher 2/Controls/MyMenuItem.vb (62 lines)
1: Public Class MyMenuItem
4: Private Sub MyMenuItem_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
24: Private Sub RefreshColor() Handles Me.MouseEnter, Me.MouseLeave, Me.IsEnabledChanged
59: Private Sub MyMenuItem_Click(sender As Object, e As RoutedEventArgs) Handles Me.Click

## Plain Craft Launcher 2/Controls/MyMsg/MyMsgInput.xaml (39 lines)


## Plain Craft Launcher 2/Controls/MyMsg/MyMsgInput.xaml.vb (97 lines)
1: Public Class MyMsgInput
6: Public Sub New(Converter As MyMsgBoxConverter)
33: Private Sub Load(sender As Object, e As EventArgs) Handles MyBase.Loaded
55: Private Sub Close()
74: Public Sub Btn1_Click() Handles Btn1.Click
81: Public Sub Btn2_Click() Handles Btn2.Click
88: Private Sub TextCaption_ValidateChanged(sender As Object, e As EventArgs) Handles TextArea.ValidateChanged
92: Private Sub Drag(sender As Object, e As MouseButtonEventArgs) Handles PanBorder.MouseLeftButtonDown, LabTitle.MouseLeftButtonDown

## Plain Craft Launcher 2/Controls/MyMsg/MyMsgSelect.xaml (36 lines)


## Plain Craft Launcher 2/Controls/MyMsg/MyMsgSelect.xaml.vb (104 lines)
1: Public Class MyMsgSelect
6: Public Sub New(Converter As MyMsgBoxConverter)
42: Private Sub Load(sender As Object, e As EventArgs) Handles MyBase.Loaded
62: Private Sub Close()
81: Public Sub Btn1_Click() Handles Btn1.Click
87: Public Sub Btn2_Click() Handles Btn2.Click
95: Private Sub OnChecked(sender As IMyRadio, e As EventArgs)
99: Private Sub Drag(sender As Object, e As MouseButtonEventArgs) Handles PanBorder.MouseLeftButtonDown, LabTitle.MouseLeftButtonDown

## Plain Craft Launcher 2/Controls/MyMsg/MyMsgText.xaml (38 lines)


## Plain Craft Launcher 2/Controls/MyMsg/MyMsgText.xaml.vb (108 lines)
1: Public Class MyMsgText
6: Public Sub New(Converter As MyMsgBoxConverter)
32: Private Sub Load(sender As Object, e As EventArgs) Handles MyBase.Loaded
53: Private Sub Close()
72: Public Sub Btn1_Click() Handles Btn1.Click
82: Public Sub Btn2_Click() Handles Btn2.Click
92: Public Sub Btn3_Click() Handles Btn3.Click
103: Private Sub Drag(sender As Object, e As MouseButtonEventArgs) Handles PanBorder.MouseLeftButtonDown, LabTitle.MouseLeftButtonDown

## Plain Craft Launcher 2/Controls/MyPageLeft.vb (108 lines)
1: Public Class MyPageLeft
16: Public Sub TriggerShowAnimation()
60: Public Sub TriggerHideAnimation()
86: Private Function GetAllAnimControls(Optional IgnoreInvisibility As Boolean = False) As List(Of FrameworkElement)
91: Private Sub GetAllAnimControls(Element As FrameworkElement, ByRef AllControls As List(Of FrameworkElement), IgnoreInvisibility As Boolean)

## Plain Craft Launcher 2/Controls/MyPageRight.vb (513 lines)
1: Public Class MyPageRight
18: Public Enum PageStates
42: #Region "加载器"
62: Public Sub PageLoaderInit(Of TIn, TOut)(LoaderUi As MyLoading, PanLoader As FrameworkElement, PanContent As FrameworkElement, PanAlways As FrameworkElement,
111: Public Sub PageLoaderInit(Of TIn)(LoaderUi As MyLoading, PanLoader As FrameworkElement, PanContent As FrameworkElement, PanAlways As FrameworkElement,
154: Public Sub PageLoaderRestart(Optional Input As Object = Nothing, Optional IsForceRestart As Boolean = True) '由外部调用的重试
166: #Region "事件"
173: Public Sub PageOnEnter()
212: Public Sub PageOnExit()
236: Public Sub PageOnForceExit()
254: Public Sub PageOnContentExit()
283: Private Sub PageOnEnterAnimationFinished()
299: Private Sub PageOnExitAnimationFinished()
317: Private Sub PageOnLoaderWaitFinished()
335: Private Sub PageOnLoaderStayFinished()
353: Private Sub PageLoaderState(sender As Object, NewState As LoadState, OldState As LoadState)
389: #Region "动画"
392: Public Sub TriggerEnterAnimation(ParamArray Elements As FrameworkElement())
431: Public Sub TriggerExitAnimation(ParamArray Elements As FrameworkElement())
471: Friend Function GetAllAnimControls(Element As FrameworkElement, Optional IgnoreInvisibility As Boolean = False) As IEnumerable(Of FrameworkElement)
476: Private Sub _GetAllAnimControls(Element As FrameworkElement, ByRef AllControls As List(Of FrameworkElement), IgnoreInvisibility As Boolean)
491: Private Function GetFirstScrollViewer(Elements As IEnumerable(Of FrameworkElement)) As MyScrollBar

## Plain Craft Launcher 2/Controls/MyRadioBox.xaml (9 lines)


## Plain Craft Launcher 2/Controls/MyRadioBox.xaml.vb (252 lines)
5: Public Class MyRadioBox
37: Public Sub SetChecked(value As Boolean, user As Boolean)
101: Private Sub SyncUI()
171: Private Sub Radiobox_MouseUp() Handles Me.MouseLeftButtonUp
178: Private Sub Radiobox_MouseDown() Handles Me.MouseLeftButtonDown
186: Private Sub Radiobox_MouseLeave() Handles Me.MouseLeave
200: Private Sub Radiobox_IsEnabledChanged() Handles Me.IsEnabledChanged
219: Private Sub Radiobox_MouseEnterAnimation() Handles Me.MouseEnter
223: Private Sub Radiobox_MouseLeaveAnimation() Handles Me.MouseLeave
236: #Region "设置"
238: Private Sub RefreshSetting(NewValue As String) Implements ISettingControl.RefreshSetting
242: Private Function GetCurrentSetting() As String Implements ISettingControl.GetCurrentSetting
246: Private Sub SaveSetting() Handles Me.Check

## Plain Craft Launcher 2/Controls/MyRadioButton.xaml (9 lines)


## Plain Craft Launcher 2/Controls/MyRadioButton.xaml.vb (262 lines)
4: Public Class MyRadioButton
47: Public Sub SetChecked(value As Boolean, raiseByMouse As Boolean, anime As Boolean)
126: Public Enum ColorState
145: Private Sub Radiobox_MouseUp() Handles Me.MouseLeftButtonUp
155: Private Sub Radiobox_MouseDown() Handles Me.MouseLeftButtonDown
160: Private Sub Radiobox_MouseLeave() Handles Me.MouseLeave
169: Private Sub RefreshColor(Optional obj = Nothing, Optional e = Nothing) Handles Me.MouseEnter, Me.MouseLeave, Me.Loaded

## Plain Craft Launcher 2/Controls/MyResizer.vb (315 lines)
5: Public Class MyResizer
9: Private Structure POINT
12: Public Sub New(x As Integer, y As Integer)
17: Private Structure MINMAXINFO
24: Private Structure RECT
42: Public Sub New(left As Integer, top As Integer, right As Integer, bottom As Integer)
48: Public Sub New(rcSrc As RECT)
57: Private Class MONITORINFO
64: Private Structure PointAPI
89: Public Sub New(target As Window)
95: Private Sub MyMacClass_SourceInitialized(sender As Object, e As EventArgs)
100: Private Function WndProc(hwnd As IntPtr, msg As Integer, wParam As IntPtr, lParam As IntPtr, ByRef handled As Boolean) As IntPtr
108: Private Shared Sub WmGetMinMaxInfo(hwnd As IntPtr, lParam As IntPtr)
133: Private Sub connectMouseHandlers(element As UIElement)
137: Public Sub addResizerRight(element As UIElement)
142: Public Sub addResizerLeft(element As UIElement)
147: Public Sub addResizerUp(element As UIElement)
152: Public Sub addResizerDown(element As UIElement)
157: Public Sub addResizerRightDown(element As UIElement)
163: Public Sub addResizerLeftDown(element As UIElement)
169: Public Sub addResizerRightUp(element As UIElement)
175: Public Sub addResizerLeftUp(element As UIElement)
181: Private Sub element_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs)
195: Private Sub updateSizeLoop()
206: Private Sub updateSize()
303: Private Sub updateMouseDown()

## Plain Craft Launcher 2/Controls/MyScrollBar.vb (51 lines)
1: Public Class MyScrollBar
10: Private Sub RefreshColor() Handles Me.IsEnabledChanged, Me.GotMouseCapture, Me.LostMouseCapture, Me.MouseEnter, Me.MouseLeave, Me.IsVisibleChanged

## Plain Craft Launcher 2/Controls/MyScrollViewer.vb (46 lines)
1: Public Class MyScrollViewer
7: Private Sub MyScrollViewer_PreviewMouseWheel(sender As Object, e As MouseWheelEventArgs) Handles Me.PreviewMouseWheel
22: Public Sub PerformVerticalOffsetDelta(Delta As Double)
30: Private Sub MyScrollViewer_ScrollChanged(sender As Object, e As ScrollChangedEventArgs) Handles Me.ScrollChanged
34: Private Sub MyScrollViewer_IsVisibleChanged(sender As Object, e As DependencyPropertyChangedEventArgs) Handles Me.IsVisibleChanged
39: Private Sub Load() Handles Me.Loaded
43: Private Sub MyScrollViewer_PreviewGotKeyboardFocus(sender As Object, e As KeyboardFocusChangedEventArgs) Handles Me.PreviewGotKeyboardFocus

## Plain Craft Launcher 2/Controls/MySearchBox.xaml (15 lines)


## Plain Craft Launcher 2/Controls/MySearchBox.xaml.vb (45 lines)
1: Class MySearchBox
5: Private Sub MySearchBox_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
27: Private Sub Text_TextChanged(sender As Object, e As TextChangedEventArgs) Handles TextBox.TextChanged
37: Private Sub BtnClear_Click(sender As Object, e As EventArgs) Handles BtnClear.Click
42: Private Sub MySearchBox_KeyUp(sender As Object, e As KeyEventArgs) Handles Me.KeyUp

## Plain Craft Launcher 2/Controls/MySlider.xaml (29 lines)


## Plain Craft Launcher 2/Controls/MySlider.xaml.vb (210 lines)
3: Public Class MySlider
70: Private Sub RefreshWidth(sender As Object, e As SizeChangedEventArgs) Handles Me.SizeChanged
82: Private Sub DragStart(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonDown
93: Public Sub DragDoing()
101: Public Sub DragStop()
108: Public Sub RefreshPopup()
119: Private Sub RefreshColor() Handles Me.IsEnabledChanged, Me.MouseEnter, Me.MouseLeave
166: Private Sub MySlider_MouseEnter() Handles Me.MouseEnter
169: Private Sub MySlider_KeyDown(sender As Object, e As KeyEventArgs) Handles Me.KeyDown
194: #Region "设置"
196: Private Sub RefreshSetting(NewValue As String) Implements ISettingControl.RefreshSetting
200: Private Function GetCurrentSetting() As String Implements ISettingControl.GetCurrentSetting
204: Private Sub SaveSetting() Handles Me.Change

## Plain Craft Launcher 2/Controls/MySliderDot.xaml (19 lines)


## Plain Craft Launcher 2/Controls/MySliderDot.xaml.vb (169 lines)
1: Public Class MySliderDot
66: Private Sub RefreshHeight(sender As Object, e As SizeChangedEventArgs) Handles Me.SizeChanged
78: Private Sub DragStart(sender As Object, e As MouseButtonEventArgs) Handles ShapeDot.MouseLeftButtonDown
85: Public Sub DragDoing()
90: Public Sub DragStop()
104: Private Sub RefreshColor() Handles Me.IsEnabledChanged, Me.MouseEnter, Me.MouseLeave

## Plain Craft Launcher 2/Controls/MyTextBox.vb (322 lines)
1: Public Class MyTextBox
116: Public Sub Validate() Handles Me.Loaded
158: Public Sub ForceShowAsSuccess()
163: Private Sub ChangeValidateResult(IsSuccessful As Boolean, IsLoaded As Boolean)
191: Private Enum ValidateState
219: Private Sub MyTextBox_TextChanged(sender As MyTextBox, e As TextChangedEventArgs) Handles Me.TextChanged
237: Private Sub RefreshColor() Handles Me.IsEnabledChanged, Me.MouseEnter, Me.MouseLeave, Me.GotFocus, Me.LostFocus
288: Private Sub RefreshTextColor() Handles Me.IsEnabledChanged
302: Private Sub MyTextBox_KeyUp(sender As Object, e As KeyEventArgs) Handles Me.KeyUp
306: #Region "设置"
308: Private Sub RefreshSetting(NewValue As String) Implements ISettingControl.RefreshSetting
312: Private Function GetCurrentSetting() As String Implements ISettingControl.GetCurrentSetting
316: Private Sub SaveSetting() Handles Me.ValidatedTextChanged

## Plain Craft Launcher 2/Controls/MyTextButton.vb (87 lines)
1: Public Class MyTextButton
9: Public Sub New()
38: Private Sub MyTextButton_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonDown
42: Private Sub MyTextButton_MouseLeave() Handles Me.MouseLeave
45: Private Sub MyTextButton_MouseLeftButtonUp(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonUp
59: Private Sub RefreshColor() Handles Me.MouseEnter, Me.MouseLeave, Me.IsEnabledChanged, Me.MouseLeftButtonDown, Me.MouseLeftButtonUp

## Plain Craft Launcher 2/Controls/MyVirtualizingElement.vb (70 lines)
1: Public Class MyVirtualizingElement(Of T As FrameworkElement)
5: Public Sub New(Initializer As Func(Of T))
13: Public Function Init() As T
31: Public Class MyVirtualizingElement
35: Public Sub New(Initializer As Func(Of FrameworkElement))
43: Public Function Init() As FrameworkElement
60: Public Shared Function TryInit(Element As FrameworkElement) As FrameworkElement

## Plain Craft Launcher 2/FormMain.xaml (184 lines)


## Plain Craft Launcher 2/FormMain.xaml.vb (1696 lines)
4: Public Class FormMain
6: #Region "基础"
9: Private Sub ShowUpdateLog(LastVersion As Integer)
264: Public Sub New()
329: Private Sub FormMain_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
439: Private Sub RunCountSub()
457: Private Sub UpgradeSub(LastVersionCode As Integer)
533: Private Sub DowngradeSub(LastVersionCode As Integer)
540: #Region "自定义窗口"
543: Private Sub FormMain_Closing(sender As Object, e As CancelEventArgs) Handles Me.Closing
551: Public Sub EndProgram(SendWarning As Boolean)
598: Public Shared Sub EndProgramForce(Optional ReturnCode As ProcessReturnValues = ProcessReturnValues.Success)
618: Private Sub BtnTitleClose_Click(sender As Object, e As RoutedEventArgs) Handles BtnTitleClose.Click
623: Private Sub FormDragMove(sender As Object, e As MouseButtonEventArgs) Handles PanTitle.MouseLeftButtonDown, PanMsg.MouseLeftButtonDown
633: Private Sub FormMain_SizeChanged() Handles Me.SizeChanged, Me.Loaded
647: Private Sub BtnTitleMin_Click() Handles BtnTitleMin.Click
652: Public Shared Sub UpdateBackgroundAndTitleBar(Value) '从设置更新
656: Public Sub UpdateBackgroundAndTitleBar()
778: #Region "窗体事件"
781: Private Sub FormMain_KeyDown(sender As Object, e As KeyEventArgs) Handles Me.KeyDown
845: Private Sub FormMain_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseDown
850: Private Sub TriggerPageBack()
859: Private Sub FormMain_Activated() Handles Me.Activated
895: Private Sub HandleDrag(sender As Object, e As DragEventArgs)
927: Private Sub FrmMain_Drop(sender As Object, e As DragEventArgs) Handles Me.Drop
1005: Private Sub FileDrag(FilePathList As IEnumerable(Of String))
1085: Private Function WndProc(hwnd As IntPtr, msg As Integer, wParam As IntPtr, lParam As IntPtr, ByRef handled As Boolean) As IntPtr
1132: Public Sub ShowWindowToTop()
1150: #Region "切换页面"
1157: Public Enum PageType
1203: Public Enum PageSubType
1228: Private Function PageNameGet(Stack As PageStackData) As String
1247: Public Sub PageNameRefresh(Type As PageStackData)
1253: Public Sub PageNameRefresh()
1293: Public Class PageStackData
1335: Public Sub PageChange(Stack As PageStackData, Optional SubType As PageSubType = PageSubType.Default)
1367: Private Sub BtnTitleSelect_Click(sender As MyRadioButton, raiseByMouse As Boolean) Handles BtnTitleSelect0.Check, BtnTitleSelect1.Check, BtnTitleSelect2.Check, BtnTitleSelect3.Check, BtnTitleSelect4.Check
1374: Public Sub PageBack() Handles BtnTitleInner.Click
1386: Private Sub PageChangeActual(Stack As PageStackData, Optional SubType As PageSubType = -1)
1391: #Region "子页面处理"
1432: #Region "实际更改页面框架 UI"
1470: #Region "设置为最新状态"
1482: Private Sub PageChangeAnim(TargetLeft As FrameworkElement, TargetRight As FrameworkElement)
1537: Private Sub PageChangeExit()
1557: Private Sub PanMainLeft_SizeChanged(sender As Object, e As SizeChangedEventArgs) Handles PanMainLeft.SizeChanged
1561: Private Sub PanMainLeft_Resize(NewWidth As Double)
1589: #Region "控件拖动"
1592: Public Sub DragTick()
1599: Public Sub DragDoing() Handles PanBack.MouseMove
1607: Public Sub DragStop()
1619: #Region "附加按钮"
1622: Private Sub BtnExtraMusic_Click(sender As Object, e As EventArgs) Handles BtnExtraMusic.Click
1625: Private Sub BtnExtraMusic_RightClick(sender As Object, e As EventArgs) Handles BtnExtraMusic.RightClick
1630: Private Sub BtnExtraDownload_Click(sender As Object, e As EventArgs) Handles BtnExtraDownload.Click
1633: Private Function BtnExtraDownload_ShowCheck() As Boolean
1638: Public Sub AprilGiveup() Handles BtnExtraApril.Click
1647: Public Function BtnExtraApril_ShowCheck() As Boolean
1652: Public Sub BtnExtraShutdown_Click() Handles BtnExtraShutdown.Click
1663: Public Function BtnExtraShutdown_ShowCheck() As Boolean
1670: Public Sub BackToTop() Handles BtnExtraBack.Click
1678: Private Function BtnExtraBack_ShowCheck() As Boolean
1682: Private Function BtnExtraBack_GetRealChild() As MyScrollViewer
1692: Private Sub FormMain_MouseMove(sender As Object, e As MouseEventArgs) Handles Me.MouseMove

## Plain Craft Launcher 2/GlobalSuppressions.vb (12 lines)


## Plain Craft Launcher 2/Modules/Base/ModAnimation.vb (1066 lines)
6: Public Module ModAnimation
8: #Region "声明"
23: Public Class AniGroupEntry
54: #Region "类与枚举"
60: Public Structure AniData
125: Public Enum AniType
163: Public Enum AniTypeSub
182: #Region "种类"
197: Public Function AaX(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
212: Public Function AaY(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
227: Public Function AaWidth(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
242: Public Function AaHeight(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
257: Public Function AaOpacity(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
272: Public Function AaValue(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
287: Public Function AaRadius(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
302: Public Function AaBorderThickness(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
315: Public Function AaStrokeThickness(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
328: Public Function AaGridLengthWidth(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
347: Public Function AaDouble(Obj As Object, Prop As DependencyProperty, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
360: Public Function AaDouble(Lambda As ParameterizedThreadStart, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
378: Public Function AaColor(Obj As FrameworkElement, Prop As DependencyProperty, Value As MyColor, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
393: Public Function AaColor(Obj As FrameworkElement, Prop As DependencyProperty, Res As String, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
411: Public Function AaScale(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False, Optional Absolute As Boolean = False) As AniData
434: Public Function AaTextAppear(Obj As Object, Optional Hide As Boolean = False, Optional TimePerText As Boolean = True, Optional Time As Integer = 70, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
449: Public Function AaCode(Code As ThreadStart, Optional Delay As Integer = 0, Optional After As Boolean = False) As AniData
467: Public Function AaScaleTransform(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
484: Public Function AaRotateTransform(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
499: Public Function AaTranslateX(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
512: Public Function AaTranslateY(Obj As Object, Value As Double, Optional Time As Integer = 400, Optional Delay As Integer = 0, Optional Ease As AniEase = Nothing, Optional After As Boolean = False) As AniData
523: Public Function AaStack(Stack As StackPanel, Optional Time As Integer = 100, Optional Delay As Integer = 25) As List(Of AniData)
536: #Region "缓动函数"
539: Public Enum AniEasePower As Integer
566: Public Class AniEaseInout
569: Public Sub New(EaseIn As AniEase, EaseOut As AniEase, Optional EaseInPercent As Double = 0.5)
585: Public Class AniEaseLinear
599: Public Class AniEaseInFluent
602: Public Sub New(Optional Power As AniEasePower = AniEasePower.Middle)
612: Public Class AniEaseOutFluent
615: Public Sub New(Optional Power As AniEasePower = AniEasePower.Middle)
625: Public Class AniEaseInoutFluent
628: Public Sub New(Optional Power As AniEasePower = AniEasePower.Middle, Optional Middle As Double = 0.5)
638: Public Class AniEaseOutFluentWithInitial
644: Public Sub New(InitialPixelPerSecond As Double, TotalSecond As Double, TotalDistance As Double)
660: Public Class AniEaseInBack
663: Public Sub New(Optional Power As AniEasePower = AniEasePower.Middle)
674: Public Class AniEaseOutBack
677: Public Sub New(Optional Power As AniEasePower = AniEasePower.Middle)
690: Public Class AniEaseInCar
693: Public Sub New(Optional Middle As Double = 0.7, Optional Power As AniEasePower = AniEasePower.Middle)
703: Public Class AniEaseOutCar
706: Public Sub New(Optional Middle As Double = 0.3, Optional Power As AniEasePower = AniEasePower.Middle)
718: Public Class AniEaseInElastic
721: Public Sub New(Optional Power As AniEasePower = AniEasePower.Middle)
732: Public Class AniEaseOutElastic
735: Public Sub New(Optional Power As AniEasePower = AniEasePower.Middle)
746: #Region "接口（开始、中断、检测）"
753: Public Sub AniStart(AniGroup As IList, Optional Name As String = "", Optional RefreshTime As Boolean = False)
775: Public Sub AniStart(AniGroup As AniData, Optional Name As String = "", Optional RefreshTime As Boolean = False)
782: Public Sub AniStop(Name As String)
788: Public Function AniIsRun(Name As String) As Boolean
805: Public Sub AniStart()
856: Public Sub AniTimer(DeltaTick As Double)
931: Private Function AniRun(Ani As AniData) As AniData

## Plain Craft Launcher 2/Modules/Base/ModBase.vb (1210 lines)
4: Public Module ModBase
6: #Region "声明"
29: Public Enum BuildTypes
88: #Region "矢量图标"
90: Public Class Logo
191: #Region "自定义类"
196: Public Class MyColor
255: Public Shared Function Lerp(ValueA As MyColor, ValueB As MyColor, Percent As Double) As MyColor
258: Public Shared Function Round(col As MyColor, Optional w As Integer = 0) As MyColor
264: Public Shared Function ClampToByte(d As Double) As Byte
272: Public Sub New()
274: Public Sub New(col As Color)
280: Public Sub New(HexString As String)
287: Public Sub New(newA As Double, col As MyColor)
293: Public Sub New(newR As Double, newG As Double, newB As Double)
299: Public Sub New(newA As Double, newR As Double, newG As Double, newB As Double)
305: Public Sub New(brush As Brush)
312: Public Sub New(brush As SolidColorBrush)
319: Public Sub New(obj As Object)
340: Public Function Hue(v1 As Double, v2 As Double, vH As Double) As Double
348: Public Function FromHSL(sH As Double, sS As Double, sL As Double) As MyColor
365: Public Function FromHSL2(sH As Double, sS As Double, sL As Double) As MyColor
403: Public Class MyRect
412: Public Sub New()
414: Public Sub New(left As Double, top As Double, width As Double, height As Double)
426: Public Enum LoadState
437: Public Enum ProcessReturnValues
466: #Region "文件"
475: Public Sub IniClearCache(FileName As String)
484: Private Function IniGetContent(FileName As String) As ConcurrentDictionary(Of String, String)
511: Public Function ReadIni(FileName As String, Key As String, Optional DefaultValue As String = "") As String
519: Public Function HasIniKey(FileName As String, Key As String) As Boolean
526: Public Sub DeleteIniKey(FileName As String, Key As String)
536: Public Sub WriteIni(FileName As String, Key As String, Value As String)
575: Public Function CheckPermission(Folder As String) As Boolean
593: Public Sub CheckPermissionWithException(Folder As String)
605: #Region "文本"
613: Public Function Val(Str As Object) As Double
624: #Region "搜索"
631: Private Function SearchSimilarity(Source As String, Query As String) As Double
671: Private Function SearchSimilarityWeighted(Source As List(Of SearchSource), Query As String) As Double
685: Public Class SearchEntry(Of T)
710: Public Class SearchSource
713: Public Sub New(Aliases As String(), Optional Weight As Double = 1)
717: Public Sub New(Text As String, Optional Weight As Double = 1)
729: Public Function Search(Of T)(Entries As List(Of SearchEntry(Of T)), Query As String, Optional MaxBlurCount As Integer = 5, Optional MinBlurSimilarity As Double = 0.1) As List(Of SearchEntry(Of T))
763: #Region "系统"
807: Public Class RestartException
815: Public Function RunAsAdmin(Argument As String) As Integer
826: Public Function GetUuid() As Integer
838: Public Function GetTimeMs() As Long
844: Public Function GetUnixTimestampUtc() As Long
850: Public Function GetDate(timeStamp As Integer) As Date
856: Public Function GetLocalTime(UtcDate As Date) As Date
867: Public Sub New(Optional RaiseByMouse As Boolean = False)
876: Public Function StartProcess(FileName As String, Optional Arguments As String = "") As Process
883: Public Function StartProcess(StartInfo As ProcessStartInfo) As Process
893: Public Function RunInNewThread(Action As Action, Optional Name As String = Nothing, Optional Priority As ThreadPriority = ThreadPriority.Normal) As Thread
910: Public Function RunInUiWait(Of Output)(Action As Func(Of Output)) As Output
922: Public Sub RunInUiWait(Action As Action)
933: Public Sub RunInUi(Action As Action, Optional ForceWaitUntilLoaded As Boolean = False)
945: Public Sub RunInThread(Action As Action)
975: Public Function GetProgramArgument(Name As String, Optional DefaultValue As Object = "")
989: Public Sub OpenWebsite(Url As String)
1007: Public Sub OpenExplorer(Location As String)
1024: Public Sub ClipboardSet(Text As String, Optional ShowSuccessHint As Boolean = True)
1045: Public Function ClipboardGetText() As String
1061: Public Sub ExtractResources(FilePath As String, ResourceName As String)
1080: #Region "UI"
1087: Public Function GetPixelSize(WPFSize As Double) As Double
1093: Public Function GetWPFSize(PixelSize As Double) As Double
1101: Public Function GetObjectFromXML(Str As XElement)
1108: Public Function GetObjectFromXML(Str As String) As Object
1146: Public Function RunInUi() As Boolean
1178: #Region "随机"
1185: Public Function RandomOne(Of T)(objects As ICollection(Of T)) As T
1192: Public Function RandomInteger(min As Integer, max As Integer) As Integer

## Plain Craft Launcher 2/Modules/Base/ModLoader.vb (791 lines)
1: Public Module ModLoader
75: Protected Sub RaisePreviewFinish()
170: Public Function CreateSyncProgressProvider(Optional FromPercentage As Double = 0, Optional ToPercentage As Double = 1) As ProgressProvider
193: Public Function CreateCancellationToken() As CancellationToken
210: Public Sub WaitForExit(Optional Input As Object = Nothing, Optional LoaderToSyncProgress As LoaderBase = Nothing, Optional IsForceRestart As Boolean = False,
234: Public Sub WaitForExitTime(Timeout As Integer, Optional Input As Object = Nothing, Optional TimeoutMessage As String = WaitForExitTimeoutMessage, Optional LoaderToSyncProgress As Object = Nothing, Optional IsForceRestart As Boolean = False)
263: Public Class LoaderTask(Of TIn, TOut)
283: Public Function IsCanceledWithThread(Thread As Thread) As Boolean
303: Public Function StartGetInput(Optional Input As TIn = Nothing, Optional InputDelegate As Func(Of TIn) = Nothing) As TIn 'InputDelegate 参数存在匿名调用
312: Public Function ShouldStart(ByRef Input As TIn, Optional IsForceRestart As Boolean = False, Optional IgnoreReloadTimeout As Boolean = False) As Boolean
397: Private Sub TriggerThreadInterrupt()
406: Public Sub New()
409: Public Sub New(Name As String, LoadDelegate As Action(Of LoaderTask(Of TIn, TOut)), Optional InputDelegate As Func(Of TIn) = Nothing, Optional Priority As ThreadPriority = ThreadPriority.Normal)
421: Public Class LoaderWorker
424: Public Sub New(Name As String, Worker As IWorker)
438: Private Sub Worker_Succeeded() Handles Worker.Succeeded
467: Public Class LoaderCombo(Of InputType)
494: Public Sub New(Name As String, Loaders As IEnumerable(Of LoaderBase))
563: Private Sub SubTaskStateChanged(Loader As LoaderBase, NewState As LoadState, OldState As LoadState)
584: Private Sub Update()
648: Public Shared Sub GetLoaderList(Loader As Object, ByRef List As List(Of LoaderBase), Optional RequireShow As Boolean = True)
657: Public Sub GetLoaderList(ByRef List As List(Of LoaderBase), Optional RequireShow As Boolean = True)
663: Public Function GetLoaderList(Optional RequireShow As Boolean = True) As List(Of LoaderBase)
676: Public Sub LoaderTaskbarAdd(Of T)(Loader As LoaderCombo(Of T))
681: Public Sub LoaderTaskbarProgressRefresh()
719: Public Function LoaderTaskbarProgressGet() As Double
731: Private Structure LoaderFolderDictionaryEntry
741: Public Enum LoaderFolderRunType
751: Public Function LoaderFolderRun(Loader As LoaderBase, FolderPath As String, Type As LoaderFolderRunType, Optional MaxDepth As Integer = 0, Optional ExtraPath As String = "", Optional WaitForExit As Boolean = False) As Boolean
780: Private Function GetActualLastWriteTimeUtc(FolderInfo As DirectoryInfo, MaxDepth As Integer) As Date

## Plain Craft Launcher 2/Modules/Base/ModNet.vb (1933 lines)
3: Public Module ModNet
5: #Region "网络请求"
10: Public Function NetRequestByClient(Url As String, Optional Method As HttpMethod = Nothing,
44: Public Function NetRequestByClientRetry(Url As String, Optional Method As HttpMethod = Nothing, Optional BackupUrl As String = Nothing,
93: Public Function NetRequestByClientMultiple(Url As String, Optional Method As HttpMethod = Nothing, Optional ThreadCount As Integer = 3,
144: Public Function NetRequestByLoader(Url As String, Optional Timeout As Integer = 45000, Optional IsJson As Boolean = False, Optional SimulateBrowserHeaders As Boolean = False) As String
151: Public Function NetRequestByLoader(Urls As IEnumerable(Of String), Optional Timeout As Integer = 45000, Optional IsJson As Boolean = False, Optional SimulateBrowserHeaders As Boolean = False) As String
166: #Region "文件下载"
172: Public Sub NetDownloadByClient(Url As String, LocalPath As String, Optional SimulateBrowserHeaders As Boolean = False)
192: Public Sub NetDownloadByLoader(Url As String, LocalPath As String, Optional LoaderToSyncProgress As LoaderBase = Nothing, Optional Check As FileChecker = Nothing, Optional SimulateBrowserHeaders As Boolean = False)
200: Public Sub NetDownloadByLoader(Urls As IEnumerable(Of String), LocalPath As String, Optional LoaderToSyncProgress As LoaderBase = Nothing, Optional Check As FileChecker = Nothing, Optional SimulateBrowserHeaders As Boolean = False)
213: #Region "基础请求引擎"
216: Private Function SendRequest(Url As String, Method As HttpMethod,
302: #Region "多线程下载引擎"
341: Public Sub UpdateNetTaskSpeedLimitHigh(Value As Integer)
356: Public Class NetSource
373: Public Enum NetState
410: Public Enum NetPreDownloadBehaviour
428: Public Class NetThread
452: Public Function GetEnumerator() As IEnumerator(Of NetThread) Implements IEnumerable(Of NetThread).GetEnumerator
455: Private Function IEnumerable_GetEnumerator() As IEnumerator Implements IEnumerable.GetEnumerator
579: Public Class NetFile
581: #Region "属性"
607: Private Function GetSource(Optional Id As Integer = 0) As NetSource
631: Public Function HasAvailableSource(Optional AllowOnceSource As Boolean = True) As Boolean
789: Public Sub New(Urls As IEnumerable(Of String), LocalPath As String, Optional Checker As FileChecker = Nothing, Optional SimulateBrowserHeaders As Boolean = False)
808: Public Function TryBeginThread() As NetThread
902: Private Sub Thread(Th As NetThread)
1070: Private Sub SourceFail(Th As NetThread, ex As Exception, IsMergeFailure As Boolean)
1147: Private Sub Reset()
1163: Private Sub Merge(Th As NetThread)
1251: Private Sub Fail(Optional RaiseEx As Exception = Nothing)
1267: Public Sub Cancel(CanceledTask As LoaderDownload)
1279: Private Sub CancelInternal()
1289: Public Sub Finish(Optional PrintLog As Boolean = True)
1302: Private Class RangeNotSupportedException
1304: Public Sub New(Message As String)
1311: Public Class LoaderDownload
1314: #Region "属性"
1374: Public Sub RefreshStat()
1392: Public Sub New(Name As String, FileTasks As IEnumerable(Of NetFile))
1474: Private Sub CheckExistingFiles(Files As List(Of NetFile), FolderList As List(Of String))
1509: Private Function CheckExistingFile(FolderList As List(Of String), VersionFolders As List(Of String), File As NetFile) As String
1566: Public Sub OnFileFinish(File As NetFile)
1574: Public Sub OnFinish()
1581: Public Sub OnFileFail(File As NetFile)
1591: Public Sub OnFail(ExList As List(Of Exception))
1639: Public Class NetManagerClass
1641: #Region "属性"
1676: Private Sub RefreshStat()
1681: #Region "刷新整体速度"
1705: #Region "刷新下载任务属性"
1719: Private Sub StartManager()
1802: Public Function Start(Task As LoaderDownload) As List(Of NetFile)
1846: Public Function HasDownloadingTask(Optional IgnoreCustomDownload As Boolean = False) As Boolean
1854: #Region "端口"
1859: Public Function FindFreePort() As Integer
1870: Public Function GetUsedPorts() As List(Of Integer)
1882: Public Function FindFreePorts(ConsecutiveCount As Integer, ParamArray ExtraBlackLists As Integer()) As List(Of Integer)
1896: Public Function Ping(Ip As String, Optional Timeout As Integer = 10000, Optional MakeLog As Boolean = True) As Integer
1916: Public Sub ShouldValidateSslCertificateOnLogin(Enabled As Boolean)

## Plain Craft Launcher 2/Modules/Base/ModValidate.vb (424 lines)
2: Public Module ModValidate
8: Public Function Validate(Text As String, ValidateRules As IEnumerable(Of Validate)) As String
33: Public Class ValidateNullable
35: Public Sub New()
46: Public Class ValidateNullOrEmpty
48: Public Sub New()
59: Public Class ValidateNullOrWhiteSpace
61: Public Sub New()
72: Public Class ValidateFunc
75: Public Sub New(F As Func(Of String, String))
86: Public Class ValidateRegex
90: Public Sub New()
92: Public Sub New(Regex As String, Optional ErrorDescription As String = "正则检查失败！")
105: Public Class ValidateHttp
107: Public Sub New()
119: Public Class ValidateInteger
123: Public Sub New()
125: Public Sub New(Min As Integer, Max As Integer)
142: Public Class ValidateLength
146: Public Sub New()
148: Public Sub New(Min As Integer, Optional Max As Integer = Integer.MaxValue)
163: Public Class ValidateExcept
167: Public Sub New()
170: Public Sub New(Excepts As ObjectModel.Collection(Of String), Optional ErrorMessage As String = "输入内容不能包含 %")
174: Public Sub New(Excepts As IEnumerable(Of String), Optional ErrorMessage As String = "输入内容不能包含 %")
179: Public Sub New(Excepts As IEnumerable(Of Char), Optional ErrorMessage As String = "输入内容不能包含 %")
199: Public Class ValidateExceptSame
204: Public Sub New()
206: Public Sub New(Excepts As ObjectModel.Collection(Of String), Optional ErrorMessage As String = "输入内容不能为 %", Optional IgnoreCase As Boolean = False)
211: Public Sub New(Excepts As IEnumerable(Of String), Optional ErrorMessage As String = "输入内容不能为 %", Optional IgnoreCase As Boolean = False)
216: Public Sub New(Except As String, Optional ErrorMessage As String = "输入内容不能为 %", Optional IgnoreCase As Boolean = False)
238: Public Class ValidateSame
243: Public Sub New()
245: Public Sub New(Required As String, Optional ErrorMessage As String = "输入内容有误", Optional IgnoreCase As Boolean = False)
259: Public Class ValidateFolderName
265: Public Sub New()
267: Public Sub New(Folder As String, Optional UseMinecraftCharCheck As Boolean = True, Optional IgnoreList As List(Of String) = Nothing)
317: Public Class ValidateFileName
324: Public Sub New()
326: Public Sub New(Name As String, Optional UseMinecraftCharCheck As Boolean = True, Optional IgnoreCase As Boolean = True)
374: Public Class ValidateFolderPath
377: Public Sub New()
379: Public Sub New(UseMinecraftCharCheck As Boolean)

## Plain Craft Launcher 2/Modules/Base/MyBitmap.vb (168 lines)
5: Public Class MyBitmap
59: Public Sub New()
61: Public Sub New(FilePathOrResourceName As String)
105: Public Sub New(Image As ImageSource)
113: Public Sub New(Image As System.Drawing.Image)
116: Public Sub New(Image As System.Drawing.Bitmap)
119: Public Sub New(Image As ImageBrush)
127: Private Class WebPDecoder '将代码隔离在另外一个类中，这样只要不调用这个方法就不会加载 Imazen.WebP.dll
128: Public Shared Function DecodeFromBytes(Bytes As Byte()) As System.Drawing.Bitmap
136: Public Function Clip(X As Integer, Y As Integer, Width As Integer, Height As Integer) As MyBitmap
150: Public Function RotateFlip(Type As System.Drawing.RotateFlipType) As MyBitmap
160: Public Sub Save(FilePath As String)

## Plain Craft Launcher 2/Modules/Base/PclLogger.vb (54 lines)
1: Public Class PclLogger

## Plain Craft Launcher 2/Modules/Minecraft/ModCrash.vb (1122 lines)
1: Public Class CrashAnalyzer
6: Public Sub New(Optional TargetInstance As McInstance = Nothing)
21: Public Sub Collect(VersionPathIndie As String, Optional LatestLog As IList(Of String) = Nothing)
89: Public Sub Import(FilePath As String)
127: Private Enum AnalyzeFileType
139: Public Function Prepare() As Boolean
306: Private Function GetHeadTailLines(Raw As String(), HeadLines As Integer, TailLines As Integer) As String
340: Private Enum CrashReason
391: Public Sub Analyze()
455: Private Sub AppendReason(Reason As CrashReason, Optional Additional As IEnumerable(Of String) = Nothing)
466: Private Sub AppendReason(Reason As CrashReason, Additional As String)
474: Private Sub AnalyzeCrit1()
589: Private Sub AnalyzeCrit2()
649: Private Sub AnalyzeCrit3()
674: Private Function AnalyzeStackKeyword(ErrorStack As String) As List(Of String)
738: Private Function AnalyzeModName(Keywords As IEnumerable(Of String)) As List(Of String)
843: Private Function TryAnalyzeModName(Keyword As String) As List(Of String)
851: Private Function TryAnalyzeModName(Keywords As IEnumerable(Of String)) As List(Of String)
861: Public Sub Output(IsManualAnalyze As Boolean, Optional ExtraFiles As List(Of String) = Nothing)
929: Private Function GetAnalyzeResult(IsHandAnalyze As Boolean) As String

## Plain Craft Launcher 2/Modules/Minecraft/ModDownload.vb (1391 lines)
1: Public Module ModDownload
3: #Region "DlClient* | Minecraft 客户端"
9: Public Function DlClientJarGet(Instance As McInstance, ReturnNothingOnFileUseable As Boolean) As NetFile
34: Public Function DlClientAssetIndexGet(Instance As McInstance) As NetFile
54: Public Function DlClientFix(Instance As McInstance, CheckAssetsHash As Boolean, DownloadAssetIndexInBackground As Boolean) As List(Of LoaderBase)
57: #Region "下载支持库文件"
66: #Region "下载资源文件"
157: #Region "DlClientList | Minecraft 客户端 版本列表"
179: Public Structure DlClientListResult
198: Private Sub DlClientListMain(Loader As LoaderTask(Of String, DlClientListResult))
233: Private Sub DlClientListMojangMain(Loader As LoaderTask(Of String, DlClientListResult))
276: Private Sub DlClientListBmclapiMain(Loader As LoaderTask(Of String, DlClientListResult))
300: Public Function DlClientListGet(Id As String)
333: #Region "DlOptiFineList | OptiFine 版本列表"
335: Public Structure DlOptiFineListResult
350: Public Class DlOptiFineListEntry
394: Private Sub DlOptiFineListMain(Loader As LoaderTask(Of Integer, DlOptiFineListResult))
418: Private Sub DlOptiFineListOfficialMain(Loader As LoaderTask(Of Integer, DlOptiFineListResult))
454: Private Sub DlOptiFineListBmclapiMain(Loader As LoaderTask(Of Integer, DlOptiFineListResult))
479: #Region "DlForgeList | Forge Minecraft 版本列表"
481: Public Structure DlForgeListResult
500: Private Sub DlForgeListMain(Loader As LoaderTask(Of Integer, DlForgeListResult))
524: Private Sub DlForgeListOfficialMain(Loader As LoaderTask(Of Integer, DlForgeListResult))
538: Private Sub DlForgeListBmclapiMain(Loader As LoaderTask(Of Integer, DlForgeListResult))
548: #Region "DlForgeVersion | Forge 版本列表"
580: Public Function CompareTo(other As DlForgelikeEntry) As Integer Implements IComparable(Of DlForgelikeEntry).CompareTo
589: Public Class DlForgeVersionEntry
630: Public Sub New(Version As String, Branch As String, Inherit As String)
647: Public Sub DlForgeVersionMain(Loader As LoaderTask(Of String, List(Of DlForgeVersionEntry)))
672: Public Sub DlForgeVersionOfficialMain(Loader As LoaderTask(Of String, List(Of DlForgeVersionEntry)))
745: Public Sub DlForgeVersionBmclapiMain(Loader As LoaderTask(Of String, List(Of DlForgeVersionEntry)))
798: #Region "DlNeoForgeList | NeoForge 版本列表"
800: Public Structure DlNeoForgeListResult
815: Public Class DlNeoForgeListEntry
853: Public Sub New(ApiName As String)
884: Private Sub DlNeoForgeListMain(Loader As LoaderTask(Of Integer, DlNeoForgeListResult))
908: Private Sub DlNeoForgeListOfficialMain(Loader As LoaderTask(Of Integer, DlNeoForgeListResult))
926: Public Sub DlNeoForgeListBmclapiMain(Loader As LoaderTask(Of Integer, DlNeoForgeListResult))
940: Private Function GetNeoForgeEntries(LatestJson As String, LatestLegacyJson As String) As List(Of DlNeoForgeListEntry)
953: #Region "DlLiteLoaderList | LiteLoader 版本列表"
955: Public Structure DlLiteLoaderListResult
974: Public Class DlLiteLoaderListEntry
1009: Private Sub DlLiteLoaderListMain(Loader As LoaderTask(Of Integer, DlLiteLoaderListResult))
1033: Private Sub DlLiteLoaderListOfficialMain(Loader As LoaderTask(Of Integer, DlLiteLoaderListResult))
1061: Private Sub DlLiteLoaderListBmclapiMain(Loader As LoaderTask(Of Integer, DlLiteLoaderListResult))
1087: #Region "DlFabricList | Fabric 列表"
1089: Public Structure DlFabricListResult
1108: Private Sub DlFabricListMain(Loader As LoaderTask(Of Integer, DlFabricListResult))
1132: Private Sub DlFabricListOfficialMain(Loader As LoaderTask(Of Integer, DlFabricListResult))
1147: Private Sub DlFabricListBmclapiMain(Loader As LoaderTask(Of Integer, DlFabricListResult))
1172: #Region "DlMod | Mod 镜像源请求"
1178: Public Function DlModRequest(Url As String, Optional Method As HttpMethod = Nothing,
1215: #Region "DlSource | 镜像下载源"
1229: Public Function DlSourceOrder(OfficialUrls As IEnumerable(Of String), MirrorUrls As IEnumerable(Of String)) As IEnumerable(Of String)
1243: Public Function DlVersionListOrder(OfficialUrls As IEnumerable(Of String), MirrorUrls As IEnumerable(Of String)) As IEnumerable(Of String)
1251: Public Function DlSourceAssetsGet(Original As String) As IEnumerable(Of String)
1264: Public Function DlSourceLibraryGet(Original As String) As IEnumerable(Of String)
1294: Public Function DlSourceLauncherOrMetaGet(Original As String) As IEnumerable(Of String)
1307: Public Function DlSourceModGet(Original As String) As String
1319: Private Sub DlSourceLoader(Of InputType, OutputType)(MainLoader As LoaderTask(Of InputType, OutputType),
1383: Private Sub DlSourceLoaderCancel(Of InputType, OutputType)(LoaderList As List(Of KeyValuePair(Of LoaderTask(Of InputType, OutputType), Integer)))

## Plain Craft Launcher 2/Modules/Minecraft/ModJava.vb (580 lines)
1: Public Module ModJava
7: Public Sub JavaInit()
54: #Region "UI 事件"
59: Public Sub UpdateJavaLists() Handles JavaListRefreshWorker.Started, JavaListRefreshWorker.Stopped
70: Public Sub ManuallyImportJava()
95: Public Sub ManuallyRemoveJava(JavaEntry As Java)
106: Public Sub ManuallySearchJava(Optional CancellationToken As CancellationToken = Nothing)
122: #Region "选取"
128: Public Function GetJavaRequirement(Instance As McInstance) As (Range As ValueRange(Of Version), RecommendedComponent As String)
276: Public Function SelectOrDownloadJava(Target As OneOf(Of ValueRange(Of Version), McInstance), TryFixOrHint As Boolean, Optional c As CancellationToken = Nothing, Optional p As ProgressProvider = Nothing) As Java
469: Private Sub SwitchToInstanceSetup(Instance As McInstance)
481: Private Sub MigrateInstanceJavaSettings(Instance As McInstance, Optional c As CancellationToken = Nothing, Optional p As ProgressProvider = Nothing)
530: #Region "下载（均为内部工具方法，无外部调用）"
532: Private Class JavaDownloadInfo
541: Private Function CreateJavaDownloadLoader(Target As JavaDownloadInfo) As LoaderCombo(Of Integer)

## Plain Craft Launcher 2/Modules/Minecraft/ModLaunch.vb (2229 lines)
1: Public Module ModLaunch
3: #Region "开始"
6: Public Class McLaunchOptions
31: Public Function McLaunchStart(Optional Options As McLaunchOptions = Nothing) As Boolean
71: Public Sub McLaunchLog(Text As String, Optional Level As LogLevel = LogLevel.Info)
82: Private Sub McLaunchState(Loader As LoaderTask(Of McLaunchOptions, Object))
97: Private Sub McLaunchStart(Loader As LoaderTask(Of McLaunchOptions, Object))
201: #Region "内存优化"
203: Private Sub McLaunchMemoryOptimize(Loader As LoaderTask(Of Integer, Integer))
223: #Region "预检测"
225: Private Sub McLaunchPrecheck()
284: #Region "主登录模块"
287: Public Enum McLoginType
304: Public Class McLoginServer
332: Public Sub New(Type As McLoginType)
340: Public Class McLoginMs
352: Public Sub New()
360: Public Class McLoginLegacy
375: Public Sub New()
384: Public Structure McLoginResult
399: Public Function McLoginName() As String
421: Public Function McLoginAble() As String
450: Public Function McLoginAble(LoginData As McLoginData) As String
468: Public Function McLoginInput() As McLoginData
499: Private Sub McLoginStart(Data As LoaderTask(Of McLoginData, McLoginResult))
524: #Region "分方式登录模块"
533: Private Sub McLoginMsStart(Data As LoaderTask(Of McLoginMs, McLoginResult))
602: Private Sub McLoginServerStart(Data As LoaderTask(Of McLoginServer, McLoginResult))
676: Private Sub McLoginLegacyStart(Data As LoaderTask(Of McLoginLegacy, McLoginResult))
697: Private Sub McLoginRequestValidate(ByRef Data As LoaderTask(Of McLoginServer, McLoginResult))
721: Private Sub McLoginRequestRefresh(ByRef Data As LoaderTask(Of McLoginServer, McLoginResult), RequestUser As Boolean)
751: Private Function McLoginRequestLogin(ByRef Data As LoaderTask(Of McLoginServer, McLoginResult)) As Boolean
873: Private Function MsLoginStep1New(Data As LoaderTask(Of McLoginMs, McLoginResult)) As (OAuthAccessToken As String, OAuthRefreshToken As String)
905: Private Function MsLoginStep1Refresh(Code As String) As (OAuthAccessToken As String, OAuthRefreshToken As String)
939: Private Function MsLoginStep2(AccessToken As String) As String
955: Private Function MsLoginStep3(XBLToken As String) As (XSTSToken As String, UHS As String)
1007: Private Function MsLoginStep4(Tokens As (XSTSToken As String, UHS As String)) As (AccessToken As String, ExpiresAt As Integer)
1039: Private Sub MsLoginStep5(AccessToken As String)
1059: Private Function MsLoginStep6(AccessToken As String) As (UUID As String, UserName As String, ProfileJson As String)
1092: Private Function McLoginLegacyUuidWithCustomSkin(UserName As String, SkinType As Integer, SkinName As String) As String
1131: Public Function McLoginMojangUuid(Name As String, ThrowOnNotFound As Boolean)
1154: Public Function McLoginLegacyUuid(Name As String)
1161: #Region "Java 处理"
1164: Private Sub McLaunchJava(Task As LoaderTask(Of Integer, Integer))
1177: #Region "启动参数"
1182: Private Sub McLaunchArgumentMain(Loader As LoaderTask(Of String, Integer))
1212: Private Function McLaunchArgumentsJVM() As List(Of String)
1305: #Region "内存管理"
1400: Private Function McLaunchArgumentsGame() As List(Of String)
1613: Private Function DeduplicateJavaArguments(Args As List(Of String), IsJVMArgs As Boolean) As List(Of String)
1655: #Region "解压 Natives"
1657: Private Sub McLaunchNatives(Loader As LoaderTask(Of Integer, Integer))
1722: Private Function GetNativesFolder() As String
1736: #Region "启动与前后处理"
1738: Private Sub McLaunchPrerun()
2011: Private Sub McLaunchCustom(Loader As LoaderTask(Of Integer, Integer))
2101: Private Sub McLaunchRun(Loader As LoaderTask(Of Integer, Process))
2150: Private Sub McLaunchWait(Loader As LoaderTask(Of Process, Integer))
2193: Private Sub McLaunchEnd()

## Plain Craft Launcher 2/Modules/Minecraft/ModMinecraft.vb (2529 lines)
1: Public Module ModMinecraft
3: #Region "文件夹"
17: Private Sub SetMcFolder(Value As String) '等同 McFolderSelected.Set
30: Public Class McFolder
38: Public Enum Types
58: Private Sub McFolderListLoadSub()
63: #Region "读取默认（Original）文件夹，即当前、官启文件夹，可能没有结果"
86: #Region "读取自定义（Custom）文件夹，可能没有结果"
146: Public Sub McFolderLauncherProfilesJsonCreate(Folder As String)
172: #Region "版本处理"
218: Public Class McInstance
317: #Region "获取游戏版本"
461: Public Function GetJsonPath() As String
663: Public Sub ResetSettingsCache()
675: Public Sub New(NameOrFullPath As String)
684: Public Function Check() As Boolean
734: Public Function Load() As McInstance
738: #Region "确定版本分类"
853: Private Function IsSnapshot() As Boolean
865: Public Function VersionDisplayName() As String
902: Public Function ToListItem(Optional ContentHandler As Action(Of MyListItem, EventArgs) = Nothing) As MyVirtualizingElement(Of MyListItem)
944: Public Enum McInstanceState
960: Public Class McVersion
1145: Public Shared Function IsFormatFit(Version As String) As Boolean
1155: Public Shared Function VersionToDrop(VanillaName As String) As Integer
1164: Public Shared Function DropToVersion(Drop As Integer) As String
1180: Public Shared Function NameToVersion(Name As String) As Version
1216: Public Function GetMcFoolName(Name As String) As String
1250: #Region "版本列表加载"
1266: Private Sub InitMcInstanceList(Loader As LoaderTask(Of String, Integer))
1345: Private Function InitMcInstanceListWithCache(Folder As String) As Dictionary(Of McInstanceCardType, List(Of McInstance))
1434: Private Function InitMcInstanceListWithoutCache(Folder As String) As Dictionary(Of McInstanceCardType, List(Of McInstance))
1437: #Region "循环加载每个版本的信息"
1466: #Region "将版本分类到各个卡片"
1567: #Region "对卡片与版本进行排序"
1604: #Region "保存卡片缓存"
1623: Private Sub McInstanceFilter(ByRef InstanceList As List(Of McInstance), ByRef Target As Dictionary(Of McInstanceCardType, List(Of McInstance)), Formula As McInstanceState(), CardType As McInstanceCardType)
1637: Private Sub McInstanceFilter(ByRef InstanceList As List(Of McInstance), Formula As McInstanceState(), ByRef KeepList As List(Of McInstance))
1644: Public Enum McInstanceCardType
1657: #Region "皮肤"
1659: Public Structure McSkinInfo
1667: Public Function McSkinSelect() As McSkinInfo
1701: Public Function McSkinGetAddress(UUID As String, Type As String) As String
1753: Public Function McSkinDownload(Address As String) As String
1769: Public Function McSkinSex(Uuid As String) As String
1793: #Region "支持库文件（Library）"
1795: Public Class McLibEntry
1850: Public Function McJsonRuleCheck(RuleToken As JToken) As Boolean
1897: Public Function McLibListGet(Instance As McInstance, IncludeMainJar As Boolean) As List(Of McLibEntry)
1949: Public Function McLibListGetWithJson(JsonObject As JObject, Optional KeepSameNameDifferentVersionResult As Boolean = False, Optional CustomMcFolder As String = Nothing) As List(Of McLibEntry)
2062: Public Function McLibNetFilesFromInstance(Instance As McInstance) As List(Of NetFile)
2141: Public Function McLibNetFilesFromTokens(Libs As List(Of McLibEntry), Optional CustomMcFolder As String = Nothing) As List(Of NetFile)
2200: Public Function McLibGet(Original As String, Optional WithHead As Boolean = True, Optional IgnoreLiteLoader As Boolean = False, Optional CustomMcFolder As String = Nothing) As String
2214: Public Function ShouldIgnoreFileCheck(Instance As McInstance)
2220: #Region "资源文件（Assets）"
2226: Public Function McAssetsGetIndex(Instance As McInstance, Optional ReturnLegacyOnError As Boolean = False, Optional CheckURLEmpty As Boolean = False) As JToken
2263: Public Function McAssetsGetIndexName(Instance As McInstance) As String
2282: Private Structure McAssetsToken
2307: Private Function McAssetsListGet(Instance As McInstance) As List(Of McAssetsToken)
2347: Public Function McAssetsFixList(Instance As McInstance, CheckHash As Boolean, Optional ByRef ProgressFeed As LoaderBase = Nothing) As List(Of NetFile)
2385: Public Sub McDownloadClientUpdateHint(VersionName As String, Json As JObject)
2423: Public Function CompareVersionGE(Left As String, Right As String) As Boolean
2431: Public Function CompareVersion(Left As String, Right As String) As Integer
2487: Public Class VersionComparer
2489: Public Function Compare(x As String, y As String) As Integer Implements IComparer(Of String).Compare
2497: Public Function FilterAccessToken(Raw As String, FilterChar As Char) As String
2515: Public Function FilterUserName(Raw As String, FilterChar As Char) As String

## Plain Craft Launcher 2/Modules/Minecraft/ModModpack.vb (860 lines)
4: Public Module ModModpack
10: Public Sub ModpackInstall()
27: Public Function ModpackInstall(File As String, Optional InstanceName As String = Nothing, Optional Logo As String = Nothing) As LoaderCombo(Of String)
112: Private Sub ExtractModpackFiles(InstallTemp As String, FileAddress As String, Optional c As CancellationToken = Nothing, Optional p As ProgressProvider = Nothing)
121: Private Sub CopyOverrideDirectory(OverridesFolder As String, VersionFolder As String, Loader As LoaderBase)
149: Private Sub NotifyIncompatibleLoader(LoaderName As String)
154: #Region "不同类型整合包的安装方法"
157: Private Function InstallPackCurseForge(FileAddress As String, Archive As ZipArchive, ArchiveBaseFolder As String,
368: Private Function InstallPackModrinth(FileAddress As String, Archive As ZipArchive, ArchiveBaseFolder As String, Optional InstanceName As String = Nothing, Optional Logo As String = Nothing) As LoaderCombo(Of String)
504: Private Function InstallPackHMCL(FileAddress As String, Archive As ZipArchive, ArchiveBaseFolder As String) As LoaderCombo(Of String)
556: Private Function InstallPackMMC(FileAddress As String, Archive As ZipArchive, ArchiveBaseFolder As String) As LoaderCombo(Of String)
680: Private Function InstallPackMCBBS(FileAddress As String, Archive As ZipArchive, ArchiveBaseFolder As String,
758: Private Function InstallPackLauncherPack(FileAddress As String, Archive As ZipArchive, ArchiveBaseFolder As String) As LoaderCombo(Of String)
820: Private Function InstallPackCompress(FileAddress As String, Archive As ZipArchive) As LoaderCombo(Of String)

## Plain Craft Launcher 2/Modules/Minecraft/ModWatcher.vb (390 lines)
1: Public Module ModWatcher
7: Private Sub WatcherStateChanged()
27: Private Sub MinecraftStart()
32: Private Sub MinecraftStop(TriggerLauncherShutdown As Boolean)
58: Public Class Watcher
66: Public Sub New(Loader As LoaderTask(Of Process, Integer), Instance As McInstance, WindowTitle As String)
130: Public Enum MinecraftState
141: Private Sub LogReceived(sender As Object, e As DataReceivedEventArgs)
146: Private Sub TimerLog()
185: Private Sub GameLog(Text As String)
238: Private Sub WatcherLog(Text As String, Optional Level As LogLevel = LogLevel.Info)
244: Private Sub ProgressUpdate()
263: Private Sub TimerWindow()
312: Private Function TryGetMinecraftWindow() As KeyValuePair(Of IntPtr, String)?
352: Private Sub Crashed()
377: Public Sub Kill()

## Plain Craft Launcher 2/Modules/ModDevelop.vb (6 lines)
1: Public Class ModDevelop
3: Public Shared Sub Start()

## Plain Craft Launcher 2/Modules/ModEvent.vb (429 lines)
2: #Region "附加属性"
9: Public Class CustomEventCollection
17: Public Function GetEnumerator() As IEnumerator(Of CustomEvent) Implements IEnumerable(Of CustomEvent).GetEnumerator
20: Private Function IEnumerable_GetEnumerator() As IEnumerator Implements IEnumerable.GetEnumerator
28: Public Class CustomEventService
34: Public Shared Sub SetEvents(d As DependencyObject, value As CustomEventCollection)
38: Public Shared Function GetEvents(d As DependencyObject) As CustomEventCollection
47: Public Shared Sub SetEventType(d As DependencyObject, value As CustomEvent.EventType)
51: Public Shared Function GetEventType(d As DependencyObject) As CustomEvent.EventType
59: Public Shared Sub SetEventData(d As DependencyObject, value As String)
63: Public Shared Function GetEventData(d As DependencyObject) As String
69: Partial Public Module ModMain
76: Public Sub RaiseCustomEvent(Control As DependencyObject)
98: Public Class CustomEvent
101: #Region "属性与触发"
129: Public Sub New()
131: Public Sub New(Type As EventType, Data As String)
139: Public Sub Raise()
145: Public Enum EventType
176: Public Shared Sub Raise(Type As EventType, Arg As String)
345: Public Shared Function GetAbsoluteUrls(RelativeUrl As String, Type As EventType) As String()
416: Private Shared Function EventSafetyConfirm(Message As String) As Boolean

## Plain Craft Launcher 2/Modules/ModMain.vb (1082 lines)
5: Public Module ModMain
7: #Region "弹出提示"
13: Public Enum HintType
18: Private Structure HintMessage
31: Public Sub Hint(Text As String, Optional Type As HintType = HintType.Blue, Optional Log As Boolean = True)
35: Private Sub HintTick()
140: Private Sub HideAllHint()
155: #Region "弹窗"
160: Public Class MyMsgBoxConverter
211: Public Enum MyMsgBoxType
230: Public Function MyMsgBox(Caption As String, Optional Title As String = "提示",
286: Public Function MyMsgBoxInput(Title As String, Optional Text As String = Nothing, Optional DefaultInput As String = Nothing, Optional ValidateRules As Collection(Of Validate) = Nothing, Optional HintText As String = "", Optional Button1 As String = "确定", Optional Button2 As String = "取消", Optional IsWarn As Boolean = False) As String
309: Public Function MyMsgBoxSelect(Selections As IEnumerable(Of IMyRadio), Optional Title As String = "提示", Optional Button1 As String = "确定", Optional Button2 As String = "", Optional IsWarn As Boolean = False) As Integer?
330: Public Sub MyMsgBoxTick()
361: #Region "页面声明"
423: #Region "帮助"
425: Public Class HelpEntry
487: Public Sub New(FilePath As String)
525: Public Function ToListItem() As MyListItem
531: Public Function SetToListItem(Item As MyListItem) As MyListItem
566: Private Sub HelpLoad(Loader As LoaderTask(Of Integer, List(Of HelpEntry)))
643: Public Sub HelpTryExtract()
655: #Region "愚人节"
670: Private Sub TimerFool()
780: #Region "系统"
785: Public Sub ShowWindowToTop(Handle As IntPtr)
801: Public Sub SetGPUPreference(Executeable As String)
817: Public Function ArgumentReplace(Text As String, Optional EscapeHandler As Func(Of String, String) = Nothing, Optional ReplaceTime As Boolean = True) As String
904: #Region "任务缓存"
913: Public Sub TryClearTaskTemp()
940: Public Function RequestTaskTempFolder(Optional RequireNonSpace As Boolean = False) As String
960: #Region "反馈与遥测"
963: Public Sub Feedback(Optional ShowMsgbox As Boolean = True, Optional ForceOpenLog As Boolean = False)
974: Public Sub FeedbackInfo()
985: Public Sub Telemetry([Event] As String, ParamArray Datas As String())
1009: Private Sub TimerMain()
1011: #Region "每 50ms 执行一次的代码"
1025: #Region "每 250ms 执行一次的代码"
1036: #Region "每 7.5s 执行一次的代码"
1052: Public Sub TimerMainStart()

## Plain Craft Launcher 2/Modules/ModMusic.vb (347 lines)
3: Public Module ModMusic
5: #Region "播放列表"
20: Private Sub MusicListInit(ForceReload As Boolean, Optional PreventFirst As String = Nothing)
48: Private Function DequeueNextMusicAddress() As String
65: #Region "UI 控制"
70: Private Sub MusicRefreshUI()
114: Public Sub MusicControlPause()
133: Public Sub MusicControlNext()
151: #Region "主状态控制"
169: Public Enum MusicStates
181: Public Sub MusicRefreshPlay(ShowHint As Boolean, Optional IsFirstLoad As Boolean = False)
213: Private Sub MusicStartPlay(Address As String, Optional IsFirstLoad As Boolean = False)
225: Public Function MusicPause() As Boolean
242: Public Function MusicResume() As Boolean
277: Private Sub MusicLoop(Optional IsFirstLoad As Boolean = False)

## Plain Craft Launcher 2/Modules/ModSecret.vb (202 lines)
3: Friend Module ModSecret
16: #Region "网络鉴权"
18: Friend Function SecretCdnSign(UrlWithMark As String) As String
25: Friend Sub SecretHeadersSign(Url As String, ByRef Req As HttpRequestMessage, Optional SimulateBrowserHeaders As Boolean = False)
41: #Region "主题"
67: Public Sub ThemeRefresh(Optional NewTheme As Integer = -1)
109: Public Sub ThemeRefreshMain()
134: Friend Sub ThemeCheckAll(EffectSetup As Boolean)
136: Friend Function ThemeCheckOne(Id As Integer) As Boolean
139: Friend Function ThemeUnlock(Id As Integer, Optional ShowDoubleHint As Boolean = True, Optional UnlockHint As String = Nothing) As Boolean
145: #Region "更新"
147: Friend Sub UpdateCheckByButton()
152: Public Sub UpdateRestart(TriggerRestartAndByEnd As Boolean)
154: Public Sub UpdateReplace(ProcessId As Integer, OldFileName As String, NewFileName As String, TriggerRestart As Boolean)
161: Friend Sub DownloadLatestPCL(Optional LoaderToSyncProgress As LoaderBase = Nothing)
167: #Region "联网配置"
180: #Region "赞助等级"
188: Public Sub InputPotatoCode(IsUpdating As Boolean)
190: Friend Sub GeneratePotatoCode()
196: Friend Function GetIdentify() As String

## Plain Craft Launcher 2/Modules/Resource/LocalResourceFile.vb (277 lines)
4: Public Class LocalResourceFile
6: #Region "文件信息"
12: Public Sub New(FileInfo As FileInfo)
15: Public Sub New(FullName As String)
46: #Region "信息项"
109: #Region "网络信息"
156: Public Function ToJson() As JObject
168: Public Sub FromJson(Json As JObject)
265: #Region "API"

## Plain Craft Launcher 2/Modules/Resource/LocalResourceLoaders.vb (349 lines)
1: Public Module LocalResourceLoaders
5: Private Sub LocalResourceFileLoad(Loader As LoaderTask(Of String, List(Of LocalResourceFile)))
106: Private Sub LocalResourceOnlineLoad(Loader As LoaderTask(Of (ModList As List(Of LocalResourceFile), Cache As JObject, Target As McVersion), Integer))

## Plain Craft Launcher 2/Modules/Resource/ResourceProject.vb (711 lines)
4: Public Class ResourceProject
123: Public Sub New(Data As JObject)
125: #Region "缓存 JSON"
148: #Region "CurseForge"
277: #Region "Modrinth"
391: Public Shared Function FromProjectId(ProjectId As String, Platform As ResourcePlatforms) As ResourceProject
432: Public Function ToJson() As JObject
455: Public Function ToResourceItem(ShowMcVersionDesc As Boolean, ShowLoaderDesc As Boolean) As MyVirtualizingElement(Of MyResourceItem)
569: Public Sub ApplyLogoToMyImage(Img As MyImage)
577: Public Function GetControlTitle(HasModLoaderDescription As Boolean) As (Title As String, SubTitle As String)
664: Public Function IsLike(Project As ResourceProject) As Boolean

## Plain Craft Launcher 2/Modules/Resource/ResourceSearcher.vb (521 lines)
1: Public Class ResourceSearcher
6: Public Class SearchRequest
59: Public Sub New(Type As ResourceTypes, Storage As SearchResult, TargetResultCount As Integer)
70: Public Function GetCurseForgeAddress(SearchText As String, IgnoreModLoaderFilter As Boolean) As String
96: Public Function GetModrinthAddress(SearchText As String, IgnoreModLoaderFilter As Boolean) As String
135: Public Class SearchResult
161: Public Shared Function GetLoader(InputDelegate As Func(Of SearchRequest)) As LoaderTask(Of SearchRequest, Integer)
164: Private Shared Sub Run(Task As LoaderTask(Of SearchRequest, Integer))
168: #Region "前置检查"
184: #Region "中文搜索"
294: #Region "从 CurseForge 和 Modrinth 获取结果列表，存储于 RawResults"
444: #Region "提取非重复项，存储于 RealResults"
459: #Region "检查结果数量，如果不足且可继续，会继续加载下一页"
473: #Region "将结果排序并添加"

## Plain Craft Launcher 2/Modules/Resource/ResourceVersion.vb (426 lines)
4: Public Class ResourceVersion
67: Public Enum ReleaseTypes
115: Public Shared Function FromPlatformJson(Data As JObject, ExpectedResourceType As ResourceTypes) As ResourceVersion
120: #Region "CurseForge"
166: #Region "Modrinth"
226: Public Shared Function FromProjectId(ProjectId As String, Platform As ResourcePlatforms, Optional LoadDependencies As Boolean = True) As List(Of ResourceVersion)
288: Public Shared Function FromCacheJson(Data As JObject) As ResourceVersion
312: Public Function ToCacheJson() As JObject
339: Public Function ToListItem(ClickHandler As MyListItem.ClickEventHandler, Optional SaveAsButtonHandler As MyIconButton.ClickEventHandler = Nothing,
381: Public Function ToNetFile(LocalFileOrFolder As String,
404: Public Enum DownloadReason
413: Public Shared Function ParseCurseForgeDownloadUrls(Url As String) As List(Of String)

## Plain Craft Launcher 2/Modules/ThirdParty/DragHelper.vb (151 lines)
7: Public Class DragHelper
33: Public Sub AddHook()
42: Public Sub RemoveDragHook()
47: Private Function WndProc(hwnd As IntPtr, msg As Integer, wParam As IntPtr, lParam As IntPtr, ByRef handled As Boolean) As IntPtr
61: Private Shared Function ChangeWindowMessageFilterEx(hWnd As IntPtr, msg As UInteger, action As UInteger, ByRef pChangeFilterStruct As CHANGEFILTERSTRUCT) As Boolean
65: Private Shared Function ChangeWindowMessageFilter(msg As UInteger, flags As UInteger) As Boolean
69: Private Shared Sub DragAcceptFiles(hWnd As IntPtr, fAccept As Boolean)
73: Private Shared Function DragQueryFile(hWnd As IntPtr, iFile As UInteger, lpszFile As StringBuilder, cch As Integer) As UInteger
77: Private Shared Function DragQueryPoint(hDrop As IntPtr, ByRef lppt As POINT) As Boolean
81: Private Shared Sub DragFinish(hDrop As IntPtr)
85: Private Shared Function RevokeDragDrop(hWnd As IntPtr) As Integer
89: Private Shared Function IsUserAnAdmin() As Boolean
93: Public Structure POINT
99: Private Structure CHANGEFILTERSTRUCT
111: Private Shared Sub ChangeMessageFilter(handle As IntPtr)
131: Private Shared Function TryGetDropInfo(msg As Integer, wParam As IntPtr, ByRef dropFilePaths As String(), ByRef dropPoint As POINT) As Boolean

## Plain Craft Launcher 2/My Project/AssemblyInfo.vb (56 lines)


## Plain Craft Launcher 2/My Project/MyExtensions/MyWpfExtension.vb (121 lines)
9: Module MyWpfExtension
66: Private Shared Function Create__Instance__(Of T As {New, Global.System.Windows.Window})(Instance As T) As T
84: Private Sub Dispose__Instance__(Of T As Global.System.Windows.Window)(ByRef instance As T)
89: Public Sub New()
110: Partial Class Application

## Plain Craft Launcher 2/My Project/Resources.Designer.vb (233 lines)
29: Friend Module Resources

## Plain Craft Launcher 2/My Project/Resources.resx (175 lines)


## Plain Craft Launcher 2/My Project/Settings.Designer.vb (71 lines)
24: #Region "My.Settings 自动保存功能"
31: Private Shared Sub AutoSaveSettings(sender As Global.System.Object, e As Global.System.EventArgs)
62: Friend Module MySettingsProperty

## Plain Craft Launcher 2/My Project/Settings.settings (7 lines)


## Plain Craft Launcher 2/My Project/app.manifest (69 lines)


## Plain Craft Launcher 2/Pages/PageDownload/ModDownloadLib.vb (2169 lines)
1: Public Module ModDownloadLib
3: #Region "Minecraft 下载"
9: Private Function McDownloadClientLoader(Id As String, Optional JsonUrl As String = Nothing, Optional InstanceName As String = Nothing) As List(Of LoaderBase)
77: #Region "Minecraft 下载菜单"
79: Public Function McDownloadListItem(Entry As JObject, OnClick As MyListItem.ClickEventHandler, IsSaveOnly As Boolean) As MyVirtualizingElement(Of MyListItem)
113: Private Sub McDownloadSaveMenuBuild(sender As Object, e As EventArgs)
120: Private Sub McDownloadMenuBuild(sender As Object, e As EventArgs)
129: Private Sub McDownloadMenuLog(sender As Object, e As RoutedEventArgs)
140: Private Sub McDownloadMenuSaveServer(sender As Object, e As RoutedEventArgs)
216: Public Sub McDownloadMenuSave(sender As Object, e As RoutedEventArgs)
265: Public Sub McUpdateLogShow(InstanceJson As JToken)
325: #Region "OptiFine 下载"
327: Private Sub McDownloadOptiFineSave(DownloadInfo As DlOptiFineListEntry)
350: Private Sub McDownloadOptiFineInstall(BaseMcFolderHome As String, Target As String, Task As LoaderTask(Of List(Of NetFile), Boolean), UseJavaWrapper As Boolean)
473: Private Function McDownloadOptiFineLoader(DownloadInfo As DlOptiFineListEntry, McFolder As String, ClientDownloadLoader As LoaderCombo(Of String), ClientFolder As String) As List(Of LoaderBase)
635: Private Function McDownloadOptiFineSaveLoader(DownloadInfo As DlOptiFineListEntry, TargetFolder As String) As List(Of LoaderBase)
671: #Region "OptiFine 下载菜单"
673: Public Function OptiFineDownloadListItem(Entry As DlOptiFineListEntry, OnClick As MyListItem.ClickEventHandler, IsSaveOnly As Boolean) As MyVirtualizingElement(Of MyListItem)
694: Private Sub OptiFineSaveContMenuBuild(sender As Object, e As EventArgs)
699: Private Sub OptiFineContMenuBuild(sender As Object, e As EventArgs)
706: Private Sub OptiFineLog_Click(sender As Object, e As RoutedEventArgs)
717: Public Sub OptiFineSave_Click(sender As Object, e As RoutedEventArgs)
731: #Region "LiteLoader 下载"
733: Private Sub McDownloadLiteLoaderSave(DownloadInfo As DlLiteLoaderListEntry)
787: Private Function McDownloadLiteLoaderLoader(DownloadInfo As DlLiteLoaderListEntry, McFolder As String) As List(Of LoaderBase)
826: #Region "LiteLoader 下载菜单"
828: Public Function LiteLoaderDownloadListItem(Entry As DlLiteLoaderListEntry, OnClick As MyListItem.ClickEventHandler, IsSaveOnly As Boolean) As MyVirtualizingElement(Of MyListItem)
848: Private Sub LiteLoaderSaveContMenuBuild(sender As MyListItem, e As EventArgs)
857: Private Sub LiteLoaderContMenuBuild(sender As MyListItem, e As EventArgs)
868: Private Sub LiteLoaderAll_Click(sender As Object, e As RoutedEventArgs)
877: Public Sub LiteLoaderSave_Click(sender As Object, e As RoutedEventArgs)
890: #Region "Forgelike 下载"
892: Public Sub McDownloadForgelikeSave(Info As DlForgelikeEntry)
940: Private Sub ForgelikeInjector(Target As String, Task As LoaderTask(Of Boolean, Boolean), McFolder As String, UseJavaWrapper As Boolean, IsNeoForge As Boolean)
1038: Private Sub ForgelikeInjectorLine(Content As String, Task As LoaderTask(Of Boolean, Boolean))
1080: Private Function McDownloadForgelikeLoader(IsNeoForge As Boolean, LoaderVersion As String, NewInstanceName As String, Inherit As String, Info As DlForgelikeEntry, McFolder As String, ClientDownloadLoader As LoaderCombo(Of String), ClientFolder As String) As List(Of LoaderBase)
1200: #Region "Forgelike 文件"
1209: #Region "原版文件"
1361: #Region "Forge 下载菜单"
1363: Public Sub ForgeDownloadListItemPreload(Stack As StackPanel, Entries As List(Of DlForgeVersionEntry), OnClick As MyListItem.ClickEventHandler, IsSaveOnly As Boolean)
1393: Public Function ForgeDownloadListItem(Entry As DlForgeVersionEntry, OnClick As MyListItem.ClickEventHandler, IsSaveOnly As Boolean) As MyVirtualizingElement(Of MyListItem)
1414: Private Sub ForgeContMenuBuild(sender As MyListItem, e As EventArgs)
1421: Private Sub ForgeSaveContMenuBuild(sender As MyListItem, e As EventArgs)
1426: Private Sub ForgeLog_Click(sender As Object, e As RoutedEventArgs)
1437: Public Sub ForgeSave_Click(sender As Object, e As RoutedEventArgs)
1451: #Region "Forge 推荐版本获取"
1456: Public Sub McDownloadForgeRecommendedRefresh()
1490: Public Function McDownloadForgeRecommendedGet(McVersion As String) As String
1509: #Region "NeoForge 下载菜单"
1511: Public Sub NeoForgeDownloadListItemPreload(Stack As StackPanel, Entries As List(Of DlNeoForgeListEntry), OnClick As MyListItem.ClickEventHandler, IsSaveOnly As Boolean)
1543: Public Function NeoForgeDownloadListItem(Info As DlNeoForgeListEntry, OnClick As MyListItem.ClickEventHandler, IsSaveOnly As Boolean) As MyVirtualizingElement(Of MyListItem)
1563: Private Sub NeoForgeContMenuBuild(sender As MyListItem, e As EventArgs)
1570: Private Sub NeoForgeSaveContMenuBuild(sender As MyListItem, e As EventArgs)
1575: Private Sub NeoForgeLog_Click(sender As Object, e As RoutedEventArgs)
1586: Public Sub NeoForgeSave_Click(sender As Object, e As RoutedEventArgs)
1600: #Region "Fabric 下载"
1602: Public Sub McDownloadFabricLoaderSave(DownloadInfo As JObject)
1640: Private Function McDownloadFabricLoader(FabricVersion As String, MinecraftName As String, McFolder As String) As List(Of LoaderBase)
1664: #Region "Fabric 下载菜单"
1666: Public Function FabricDownloadListItem(Entry As JObject, OnClick As MyListItem.ClickEventHandler) As MyVirtualizingElement(Of MyListItem)
1678: Public Function FabricApiDownloadListItem(Entry As ResourceVersion, OnClick As MyListItem.ClickEventHandler) As MyVirtualizingElement(Of MyListItem)
1690: Public Function OptiFabricDownloadListItem(Entry As ResourceVersion, OnClick As MyListItem.ClickEventHandler) As MyVirtualizingElement(Of MyListItem)
1705: #Region "合并安装"
1710: Public Class McInstallRequest
1786: Public Sub LoaderStateChangedHintOnly(Loader As LoaderBase)
1799: Public Sub McInstallState(Loader As LoaderBase)
1815: Public Sub McInstallFailedClearFolder(Loader)
1835: Public Function McInstall(Request As McInstallRequest) As Boolean
1856: Public Function McInstallLoader(Request As McInstallRequest) As List(Of LoaderBase)
1996: Private Sub MergeJson(OutputFolder As String, MinecraftFolder As String, Optional OptiFineFolder As String = Nothing, Optional OptiFineAsMod As Boolean = False, Optional ForgeFolder As String = Nothing, Optional ForgeVersion As String = Nothing, Optional NeoForgeFolder As String = Nothing, Optional NeoForgeVersion As String = Nothing, Optional FabricFolder As String = Nothing, Optional LiteLoaderFolder As String = Nothing)
2009: #Region "初始化路径信息"
2052: #Region "读取文件并检查文件是否合规"
2088: #Region "处理 JSON 文件"
2150: #Region "保存"

## Plain Craft Launcher 2/Pages/PageDownload/PageDownloadInstall.xaml (199 lines)


## Plain Craft Launcher 2/Pages/PageDownload/PageDownloadInstall.xaml.vb (1173 lines)
1: Public Class PageDownloadInstall
3: Private Sub LoaderInit() Handles Me.Initialized
9: Private Sub Init() Handles Me.Loaded
35: #Region "页面切换"
40: Private Sub EnterSelectPage()
119: Public Sub ExitSelectPage() Handles BtnBack.Click
147: Public Sub MinecraftSelected(sender As MyListItem, e As MouseButtonEventArgs)
156: #Region "选择"
180: Private Sub ReloadSelected() Handles CardOptiFine.Swap, LoadOptiFine.StateChanged, CardForge.Swap, LoadForge.StateChanged, CardNeoForge.Swap, LoadNeoForge.StateChanged, CardFabric.Swap, LoadFabric.StateChanged, CardFabricApi.Swap, LoadFabricApi.StateChanged, CardOptiFabric.Swap, LoadOptiFabric.StateChanged, CardLiteLoader.Swap, LoadLiteLoader.StateChanged
359: Private Sub ClearSelected()
373: Private Sub SetPanelVisibility(Panel As Grid, IsVisible As Boolean)
392: Private Function GetSelectLogo() As String
412: Private Function GetSelectName() As String
423: Private Sub SelectNameUpdate()
429: Private Sub TextSelectName_TextChanged(sender As Object, e As TextChangedEventArgs) Handles TextSelectName.TextChanged
434: Private Sub TextSelectName_ValidateChanged(sender As Object, e As EventArgs) Handles TextSelectName.ValidateChanged
440: #Region "加载器"
443: Private Sub LoadMinecraft_OnFinish()
548: #Region "OptiFine 列表"
553: Private Function LoadOptiFineGetError() As String
587: Private Function IsOptiFineSuitForForge(OptiFine As DlOptiFineListEntry, Forge As DlForgeVersionEntry)
599: Private Sub CardOptiFine_PreviewSwap(sender As Object, e As RouteEventArgs) Handles CardOptiFine.PreviewSwap
606: Private Sub OptiFine_Loaded() Handles LoadOptiFine.StateChanged
635: Private Sub OptiFine_Selected(sender As MyListItem, e As EventArgs)
644: Private Sub OptiFine_Clear(sender As Object, e As MouseButtonEventArgs) Handles BtnOptiFineClear.MouseLeftButtonUp
657: #Region "LiteLoader 列表"
662: Private Function LoadLiteLoaderGetError() As String
670: Private Sub CardLiteLoader_PreviewSwap(sender As Object, e As RouteEventArgs) Handles CardLiteLoader.PreviewSwap
677: Private Sub LiteLoader_Loaded() Handles LoadLiteLoader.StateChanged
697: Private Sub LiteLoader_Selected(sender As MyListItem, e As EventArgs)
702: Private Sub LiteLoader_Clear(sender As Object, e As MouseButtonEventArgs) Handles BtnLiteLoaderClear.MouseLeftButtonUp
711: #Region "Forge 列表"
716: Private Function LoadForgeGetError() As String
738: Private Sub CardForge_PreviewSwap(sender As Object, e As RouteEventArgs) Handles CardForge.PreviewSwap
745: Private Sub Forge_Loaded() Handles LoadForge.StateChanged
771: Private Sub Forge_Selected(sender As MyListItem, e As EventArgs)
778: Private Sub Forge_Clear(sender As Object, e As MouseButtonEventArgs) Handles BtnForgeClear.MouseLeftButtonUp
788: #Region "NeoForge 列表"
793: Private Function LoadNeoForgeGetError() As String
804: Private Sub CardNeoForge_PreviewSwap(sender As Object, e As RouteEventArgs) Handles CardNeoForge.PreviewSwap
811: Private Sub NeoForge_Loaded() Handles LoadNeoForge.StateChanged
829: Private Sub NeoForge_Selected(sender As MyListItem, e As EventArgs)
835: Private Sub NeoForge_Clear(sender As Object, e As MouseButtonEventArgs) Handles BtnNeoForgeClear.MouseLeftButtonUp
845: #Region "Fabric 列表"
850: Private Function LoadFabricGetError() As String
867: Private Sub CardFabric_PreviewSwap(sender As Object, e As RouteEventArgs) Handles CardFabric.PreviewSwap
874: Private Sub Fabric_Loaded() Handles LoadFabric.StateChanged
891: Public Sub Fabric_Selected(sender As MyListItem, e As EventArgs)
898: Private Sub Fabric_Clear(sender As Object, e As MouseButtonEventArgs) Handles BtnFabricClear.MouseLeftButtonUp
911: #Region "Fabric API 列表"
916: Public Function IsFabricApiCompatible(FabricApi As ResourceVersion) As Boolean
957: Private Function LoadFabricApiGetError() As String
970: Private Sub CardFabricApi_PreviewSwap(sender As Object, e As RouteEventArgs) Handles CardFabricApi.PreviewSwap
978: Private Sub FabricApi_Loaded() Handles LoadFabricApi.StateChanged
1014: Private Sub FabricApi_Selected(sender As MyListItem, e As EventArgs)
1019: Private Sub FabricApi_Clear(sender As Object, e As MouseButtonEventArgs) Handles BtnFabricApiClear.MouseLeftButtonUp
1028: #Region "OptiFabric 列表"
1033: Private Function IsOptiFabricCompatible(ModFile As ResourceVersion) As Boolean
1047: Private Function LoadOptiFabricGetError() As String
1069: Private Sub CardOptiFabric_PreviewSwap(sender As Object, e As RouteEventArgs) Handles CardOptiFabric.PreviewSwap
1076: Private Sub OptiFabric_Loaded() Handles LoadOptiFabric.StateChanged
1106: Private Sub OptiFabric_Selected(sender As MyListItem, e As EventArgs)
1111: Private Sub OptiFabric_Clear(sender As Object, e As MouseButtonEventArgs) Handles BtnOptiFabricClear.MouseLeftButtonUp
1120: #Region "安装"
1122: Private Sub TextSelectName_KeyDown(sender As Object, e As KeyEventArgs) Handles TextSelectName.KeyDown
1125: Private Sub BtnStart_Click() Handles BtnStart.Click
1157: Private Function GetLoaderError(Loader As MyLoading) As String

## Plain Craft Launcher 2/Pages/PageDownload/PageDownloadLeft.xaml (59 lines)


## Plain Craft Launcher 2/Pages/PageDownload/PageDownloadLeft.xaml.vb (150 lines)
1: Public Class PageDownloadLeft
4: #Region "页面切换"
14: Private Sub PageCheck(sender As FrameworkElement, e As RouteEventArgs) Handles ItemInstall.Check, ItemMod.Check, ItemPack.Check, ItemResourcePack.Check, ItemShader.Check, ItemDataPack.Check
20: Public Function PageGet(Optional ID As FormMain.PageSubType = -1)
49: Public Sub PageChange(ID As FormMain.PageSubType)
61: Private Shared Sub PageChangeRun(Target As MyPageRight)
85: Public Sub Refresh_Click(sender As Object, e As EventArgs) '由边栏按钮匿名调用
88: Public Sub Refresh() Implements IRefreshable.Refresh
91: Public Sub Refresh(SubType As FormMain.PageSubType)
145: Private Sub ItemInstall_Click(sender As Object, e As MouseButtonEventArgs) Handles ItemInstall.Click

## Plain Craft Launcher 2/Pages/PageDownload/Resource/MyResourceItem.xaml (83 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/MyResourceItem.xaml.vb (214 lines)
1: Public Class MyResourceItem
3: #Region "基础属性"
40: Private Sub LabInfo_MouseEnter(sender As Object, e As MouseEventArgs) Handles LabInfo.MouseEnter
64: #Region "点击"
68: Private Sub Button_MouseUp(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonUp
75: Private Sub MyResourceItem_Click(sender As MyResourceItem, e As EventArgs) Handles Me.Click
120: Private Sub Button_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonDown
123: Private Sub Button_MouseLeave(sender As Object, e As Object) Handles Me.MouseLeave, Me.PreviewMouseLeftButtonUp
129: #Region "后加载指向背景"
166: Public Sub RefreshColor(sender As Object, e As EventArgs) Handles Me.MouseEnter, Me.MouseLeave, Me.MouseLeftButtonDown, Me.MouseLeftButtonUp

## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadCompDetail.xaml (34 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadCompDetail.xaml.vb (538 lines)
3: Public Class PageDownloadResourceDetail
14: Public Sub LoadPageArguments() Handles Me.Loaded
22: #Region "加载器"
34: Private Sub PageDownloadResourceDetail_Inited(sender As Object, e As EventArgs) Handles Me.Initialized
39: Private Sub Load_State(sender As Object, state As MyLoading.MyLoadingState, oldState As MyLoading.MyLoadingState) Handles Load.StateChanged
51: Private Class CardSorter
54: Public Function Compare(x As String, y As String) As Integer Implements IComparer(Of String).Compare
72: Public Sub New(Optional Topmost As String = "")
81: Private Function GetResults() As List(Of ResourceVersion)
93: Private Sub Load_OnFinish()
158: Private Sub UpdateFilterResult()
243: Private Function GetGroupedVersionName(Name As String, GroupedByDrop As Boolean, FoldOld As Boolean) As String
261: Public Sub Init() Handles Me.PageEnter
289: Public Sub Install_Click(sender As MyListItem, e As EventArgs)
337: Public Sub Save_Click(sender As Object, e As EventArgs)
496: Private Sub BtnIntroWeb_Click(sender As Object, e As EventArgs) Handles BtnIntroWeb.Click
499: Private Sub BtnIntroWiki_Click(sender As Object, e As EventArgs) Handles BtnIntroWiki.Click
502: Private Sub BtnIntroCopy_Click(sender As Object, e As EventArgs) Handles BtnIntroCopy.Click
507: Private Sub HintAlternative_Click() Handles HintAlternative.Click
516: Public Shared Sub ResourceFilesCardPreload(Stack As StackPanel, Files As List(Of ResourceVersion))

## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadDataPack.xaml (26 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadDataPack.xaml.vb (2 lines)
1: Public Class PageDownloadDataPack

## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadMod.xaml (36 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadMod.xaml.vb (2 lines)
1: Public Class PageDownloadMod

## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadPack.xaml (28 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadPack.xaml.vb (2 lines)
1: Public Class PageDownloadPack

## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadResourcePack.xaml (45 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadResourcePack.xaml.vb (2 lines)
1: Public Class PageDownloadResourcePack

## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadShader.xaml (34 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageDownloadShader.xaml.vb (2 lines)
1: Public Class PageDownloadShader

## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageResource.xaml (95 lines)


## Plain Craft Launcher 2/Pages/PageDownload/Resource/PageResource.xaml.vb (266 lines)
4: Public Class PageResource
6: #Region "属性"
65: #Region "加载"
79: Private Sub PageResource_Loaded(sender As Object, e As EventArgs) Handles Me.Loaded
121: Private Function LoaderInput() As ResourceSearcher.SearchRequest
145: Private Sub Load_OnFinish()
185: Private Sub Load_State(sender As Object, state As MyLoading.MyLoadingState, oldState As MyLoading.MyLoadingState) Handles Load.StateChanged
198: Private Sub BtnPageFirst_Click(sender As Object, e As RoutedEventArgs) Handles BtnPageFirst.Click
201: Private Sub BtnPageLeft_Click(sender As Object, e As RoutedEventArgs) Handles BtnPageLeft.Click
204: Private Sub BtnPageRight_Click(sender As Object, e As RoutedEventArgs) Handles BtnPageRight.Click
207: Private Sub ChangePage(NewPage As Integer)
220: #Region "搜索"
223: Private Sub StartNewSearch() Handles BtnSearchRun.Click
228: Private Sub EnterTrigger(sender As Object, e As KeyEventArgs) Handles TextSearchName.KeyDown, TextSearchVersion.KeyDown
233: Private Sub ResetFilter() Handles BtnSearchReset.Click
245: Private Sub TextSearchVersion_TextChanged() Handles TextSearchVersion.TextChanged
248: Private Sub UpdateSearchLoaderVisibility() Handles TextSearchVersion.DropDownClosed
262: Private Sub BtnSearchInstallModPack_Click(sender As Object, e As EventArgs) Handles BtnSearchInstallModPack.Click

## Plain Craft Launcher 2/Pages/PageInstance/MyLocalModItem.xaml (56 lines)


## Plain Craft Launcher 2/Pages/PageInstance/MyLocalModItem.xaml.vb (537 lines)
3: Public Class MyLocalModItem
5: #Region "基础属性"
75: #Region "点击与勾选"
79: Private Sub Button_MouseUp(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonUp
89: Private Sub Button_MouseDown(sender As Object, e As MouseButtonEventArgs) Handles Me.PreviewMouseLeftButtonDown
94: Private Sub Button_MouseLeave(sender As Object, e As Object) Handles Me.MouseLeave, Me.PreviewMouseLeftButtonUp
112: Private Sub Button_MouseSwipeStart(sender As Object, e As Object) Handles Me.MouseLeftButtonDown
121: Private Sub Button_MouseSwipe(sender As Object, e As Object) Handles Me.MouseEnter, Me.MouseLeave, Me.MouseLeftButtonUp
214: #Region "后加载内容"
297: Private Function GetUpdateCompareDescription() As String
319: Public Sub New()
324: Private Sub FirstEnterScrollViewerViewport()
328: Public Sub Refresh()
411: Public Sub RefreshColor(sender As Object, e As EventArgs) Handles Me.MouseEnter, Me.MouseLeave, Me.MouseLeftButtonDown, Me.MouseLeftButtonUp, Me.Changed
450: Private Sub InitLate(sender As Object, e As EventArgs)
458: Private Sub BtnUpdate_PreviewMouseRightButtonUp(sender As Object, e As MouseButtonEventArgs) Handles BtnUpdate.PreviewMouseRightButtonUp
462: Private Sub ShowUpdateLog()
478: Private Sub BtnUpdate_Click(sender As Object, e As EventArgs) Handles BtnUpdate.Click
489: Private Sub PanTitle_SizeChanged() Handles PanTitle.SizeChanged

## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceExport.xaml (314 lines)


## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceExport.xaml.vb (784 lines)
1: Public Class ExportOption
16: Public Class PageInstanceExport
20: Private Sub PageInstanceExport_Initialized(sender As Object, e As EventArgs) Handles Me.Initialized
23: Private Sub PageInstanceExport_Loaded() Handles Me.Loaded
30: Public Sub RefreshAll() Implements IRefreshable.Refresh
48: #Region "子选项"
54: Private Sub ReloadAllSubOptions()
60: Private Sub ReloadSubOptions(Panel As StackPanel, AcceptCompressedFile As Boolean, AcceptFolder As Boolean, ParamArray Folders As String())
89: #Region "选项"
94: Private Sub RefreshAllOptionsUI()
199: Private Function GetExportOption(CheckBox As MyCheckBox) As ExportOption
205: #Region "配置文件"
309: Private Sub ResetConfigOverrides()
315: Private Sub CardOptions_MouseLeftButtonDown() Handles CardOptions.MouseLeftButtonDown
323: Private Sub ExportConfig() Handles BtnAdvancedExport.Click
372: Private Sub ImportConfig() Handles BtnAdvancedImport.Click
411: #Region "导出"
421: Private Sub StartExport() Handles BtnExport.Click
476: #Region "准备 PCL 文件"
488: #Region "复制文件"
584: #Region "联网检查"
671: #Region "生成压缩包"
734: Private Sub RefreshJavaInfo() Handles Me.Loaded
768: Private Sub TextExportName_GotFocus() Handles TextExportName.GotFocus
775: Private Sub CheckAdvancedInclude_Change(sender As Object, user As Boolean) Handles CheckAdvancedInclude.Change
780: Private Sub CheckAdvancedModrinth_Change(sender As Object, user As Boolean) Handles CheckAdvancedModrinth.Change, CheckOptionsPcl.Change

## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceLeft.xaml (35 lines)


## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceLeft.xaml.vb (127 lines)
1: Public Class PageInstanceLeft
9: Public Sub RefreshModDisabled() Handles Me.Loaded
19: #Region "页面切换"
29: Private Sub PageCheck(sender As FrameworkElement, e As RouteEventArgs) Handles ItemOverall.Check, ItemMod.Check, ItemModDisabled.Check, ItemSetup.Check, ItemExport.Check
35: Public Function PageGet(Optional ID As FormMain.PageSubType = -1)
61: Public Sub PageChange(ID As FormMain.PageSubType)
73: Private Shared Sub PageChangeRun(Target As MyPageRight)
94: Public Sub Refresh_Click(sender As Object, e As EventArgs) '由边栏按钮匿名调用
97: Public Sub Refresh() Implements IRefreshable.Refresh
100: Public Sub Refresh(SubType As FormMain.PageSubType)
111: Public Sub Reset(sender As Object, e As EventArgs)
121: Public Shared Sub ReloadCurrentJava() Handles Me.Loaded

## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceMod.xaml (79 lines)


## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceMod.xaml.vb (839 lines)
1: Public Class PageInstanceMod
4: #Region "初始化"
7: Public Sub PageOther_Loaded() Handles Me.Loaded
30: Public Sub ReloadModList(Optional ForceReload As Boolean = False)
38: Private Sub RefreshSelf() Implements IRefreshable.Refresh
41: Public Shared Sub Refresh()
55: Private Sub LoaderInit() Handles Me.Initialized
58: Private Sub Load_Click(sender As Object, e As MouseButtonEventArgs) Handles Load.Click
61: Public Function LoaderRun(Type As LoaderFolderRunType) As Boolean
67: #Region "UI 化"
76: Private Sub LoadUIFromLoaderOutput()
100: Private Function McModListItem(Entry As LocalResourceFile) As MyLocalModItem
108: Private Sub McModContent(sender As MyLocalModItem, e As EventArgs)
132: Public Sub RefreshUI()
157: Public Sub RefreshBars()
253: #Region "管理"
258: Private Sub BtnManageOpen_Click(sender As Object, e As EventArgs) Handles BtnManageOpen.Click, BtnHintOpen.Click
270: Private Sub BtnManageSelectAll_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnManageSelectAll.Click
277: Private Sub BtnManageInstall_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnManageInstall.Click, BtnHintInstall.Click
286: Public Shared Function InstallMods(FilePathList As IEnumerable(Of String)) As Boolean
336: Private Sub BtnManageDownload_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnManageDownload.Click, BtnHintDownload.Click
345: #Region "选择"
351: Public Sub CheckChanged(sender As MyLocalModItem, e As RouteEventArgs)
364: Private Sub ChangeAllSelected(Value As Boolean)
376: Private Sub UnselectedAllWithAnimation() Handles Load.StateChanged, Me.PageExit
382: Private Sub FrmMain_KeyDown(sender As Object, e As KeyEventArgs) '监听自己的事件的话进入页面后不点击右侧控件就没办法监听到事件 (#4311)
386: Private Sub SearchBox_PreviewKeyDown(sender As Object, e As KeyEventArgs) Handles SearchBox.PreviewKeyDown
394: #Region "筛选"
417: Public Enum FilterType As Integer
427: Private Function CanPassFilter(CheckingMod As LocalResourceFile) As Boolean
443: Private Sub ChangeFilter(sender As MyRadioButton, raiseByMouse As Boolean) Handles BtnFilterAll.Check, BtnFilterCanUpdate.Check, BtnFilterDisabled.Check, BtnFilterEnabled.Check
450: #Region "下边栏"
453: Private Sub BtnSelectED_Click(sender As MyIconTextButton, e As RouteEventArgs) Handles BtnSelectEnable.Click, BtnSelectDisable.Click
458: Private Sub EDMods(ModList As IEnumerable(Of LocalResourceFile), IsEnable As Boolean)
528: Private Sub BtnSelectUpdate_Click() Handles BtnSelectUpdate.Click
538: Public Sub UpdateMods(ModList As IEnumerable(Of LocalResourceFile))
662: Private Sub BtnSelectDelete_Click() Handles BtnSelectDelete.Click
666: Private Sub DeleteMods(ModsToDelete As IEnumerable(Of LocalResourceFile))
728: Private Sub BtnSelectCancel_Click() Handles BtnSelectCancel.Click
734: #Region "单个 Mod 项"
737: Public Sub Info_Click(sender As Object, e As EventArgs)
780: Public Sub Open_Click(sender As MyIconButton, e As EventArgs)
789: Public Sub Delete_Click(sender As MyIconButton, e As EventArgs)
794: Public Sub ED_Click(sender As MyIconButton, e As EventArgs)
801: #Region "搜索"
809: Public Sub SearchRun() Handles SearchBox.TextChanged

## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceModDisabled.xaml (30 lines)


## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceModDisabled.xaml.vb (19 lines)
1: Public Class PageInstanceModDisabled
3: Private Sub BtnDownload_Click(sender As Object, e As EventArgs) Handles BtnDownload.Click
6: Private Sub BtnVersion_Click(sender As Object, e As EventArgs) Handles BtnVersion.Click
11: Public Sub BtnDownload_Loaded() Handles BtnDownload.Loaded

## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceOverall.xaml (88 lines)


## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceOverall.xaml.vb (333 lines)
1: Public Class PageInstanceOverall
4: Private Sub PageSetupLaunch_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
23: Private Sub Reload()
52: #Region "卡片：个性化"
55: Private Sub ComboDisplayType_SelectionChanged(sender As Object, e As SelectionChangedEventArgs) Handles ComboDisplayType.SelectionChanged
91: Private Sub BtnDisplayDesc_Click(sender As Object, e As EventArgs) Handles BtnDisplayDesc.Click
105: Private Sub BtnDisplayRename_Click(sender As Object, e As EventArgs) Handles BtnDisplayRename.Click
161: Private Sub ComboDisplayLogo_SelectionChanged() Handles ItemDisplayLogoCustom.PreviewMouseLeftButtonUp, ComboDisplayLogo.SelectionChanged
194: Private Sub BtnDisplayStar_Click(sender As Object, e As EventArgs) Handles BtnDisplayStar.Click
208: #Region "卡片：快捷方式"
211: Private Sub BtnFolderVersion_Click() Handles BtnFolderVersion.Click
214: Public Shared Sub OpenInstanceFolder(Instance As McInstance)
219: Private Sub BtnFolderSaves_Click() Handles BtnFolderSaves.Click
226: Private Sub BtnFolderMods_Click() Handles BtnFolderMods.Click
233: Private Sub BtnFolderScreen_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnFolderScreen.Click
241: #Region "卡片：管理"
244: Private Sub BtnManageScript_Click() Handles BtnManageScript.Click
268: Private Sub BtnManageCheck_Click(sender As Object, e As EventArgs) Handles BtnManageCheck.Click
305: Private Sub BtnManageDelete_Click(sender As Object, e As EventArgs) Handles BtnManageDelete.Click

## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceSetup.xaml (276 lines)


## Plain Craft Launcher 2/Pages/PageInstance/PageInstanceSetup.xaml.vb (570 lines)
1: Public Class PageInstanceSetup
4: Private Sub PageSetupSystem_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
47: Public Sub Reload()
78: Public Sub Reset()
98: #Region "游戏内存"
100: Public Shared Sub OnVersionRamTypeChanged(Type As Integer)
105: Public Sub RamType(Type As Integer)
113: Public Sub RefreshRam(ShowAnim As Boolean)
151: Private Sub RefreshRam() Handles SliderRamCustom.Change, RadioRamType0.Check, RadioRamType1.Check, RadioRamType2.Check
159: Private Sub RefreshRamText() Handles RectRamGame.SizeChanged, RectRamEmpty.SizeChanged, LabRamGame.SizeChanged
240: Public Shared Function GetRam(Instance As McInstance) As Double
324: #Region "服务器"
328: Public Shared Sub OnVersionServerLoginChanged(Type As Integer)
337: Private Sub TextServerEnter_Change() Handles TextServerEnter.TextChanged
347: Private Sub ComboServerLogin_Changed() Handles ComboServerLogin.SelectionChanged, TextServerNide.ValidatedTextChanged, TextServerAuthServer.ValidatedTextChanged, TextServerAuthRegister.ValidatedTextChanged
359: Private Sub UpdateServerLoginUI()
376: Private Sub BtnServerAuthLittle_Click(sender As Object, e As EventArgs) Handles BtnServerAuthLittle.Click
387: #Region "Java 主类别和预览"
389: Private Sub ReloadCurrentJava() Handles ComboArgumentJava.SelectionChanged, TextArgumentJavaRange.ValidatedTextChanged
393: Private Sub UpdateJavaRelatedUi() Handles ComboArgumentJava.SelectionChanged, TextArgumentJavaRange.TextChanged
396: Private Sub _UpdateJavaRelatedUi()
454: Private Sub HintArgumentJava_Click(sender As Object, e As MouseButtonEventArgs) Handles HintArgumentJava.Click
460: #Region "选择特定 Java 的下拉框"
464: Public Sub UpdateJavaList()
528: Private Sub BtnAdvanceJavaSearch_Click() Handles BtnArgumentJavaSearch.Click
535: Private Sub ComboArgumentIndieV2_SelectionChanged(sender As Object, e As SelectionChangedEventArgs) Handles ComboArgumentIndieV2.SelectionChanged
552: Private Sub TextAdvanceRun_TextChanged(sender As Object, e As TextChangedEventArgs) Handles TextAdvanceRun.TextChanged
557: Private Sub BtnSwitch_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnSwitch.Click
562: Private Sub ReplaceEnter(sender As MyTextBox, e As TextChangedEventArgs) Handles TextAdvanceJvm.TextChanged, TextAdvanceGame.TextChanged

## Plain Craft Launcher 2/Pages/PageLaunch/MyMsgLogin.xaml (40 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/MyMsgLogin.xaml.vb (160 lines)
1: Public Class MyMsgLogin
7: #Region "弹窗"
12: Public Sub New(Converter As MyMsgBoxConverter)
27: Private Sub Load(sender As Object, e As EventArgs) Handles MyBase.Loaded
43: Private Sub Close()
60: Public Sub Btn1_Click() Handles Btn1.Click
62: Public Sub Btn3_Click() Handles Btn3.Click
66: Private Sub Drag(sender As Object, e As MouseButtonEventArgs) Handles PanBorder.MouseLeftButtonDown, LabTitle.MouseLeftButtonDown
73: Private Sub Finished(Result As Object)
82: Private Sub Init()
98: Private Sub WorkThread()

## Plain Craft Launcher 2/Pages/PageLaunch/MySkin.xaml (21 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/MySkin.xaml.vb (312 lines)
1: Public Class MySkin
20: Private Sub PanSkin_MouseEnter(sender As Object, e As MouseEventArgs) Handles Me.MouseEnter
23: Private Sub PanSkin_MouseLeave(sender As Object, e As MouseEventArgs) Handles Me.MouseLeave
31: Private Sub PanSkin_MouseLeftButtonDown(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonDown
35: Private Sub PanSkin_MouseLeftButtonUp(sender As Object, e As MouseButtonEventArgs) Handles Me.MouseLeftButtonUp
44: Public Sub BtnSkinSave_Click() Handles BtnSkinSave.Click
47: Public Shared Sub Save(Loader As LoaderTask(Of (String, String), String))
71: Private Sub BtnSkinSave_Checked(sender As MyMenuItem, e As RoutedEventArgs) Handles BtnSkinSave.Checked
78: Public Sub Load()
125: Public Sub Clear()
132: Public Sub RefreshClick() Handles BtnSkinRefresh.Click
138: Public Shared Sub RefreshCache(Optional sender As LoaderTask(Of (String, String), String) = Nothing)
176: Public Shared Sub ReloadCache(SkinAddress As String)
209: Public Sub BtnSkinCape_Click() Handles BtnSkinCape.Click

## Plain Craft Launcher 2/Pages/PageLaunch/PageLaunchLeft.xaml (156 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLaunchLeft.xaml.vb (833 lines)
3: Public Class PageLaunchLeft
8: Public Sub PageLaunchLeft_Loaded() Handles Me.Loaded
118: #Region "切换大页面"
123: Public Sub PageChangeToLaunching()
175: Public Sub PageChangeToLogin()
192: #Region "切换登录页面"
194: Private Enum PageType
209: Private Function PageGet(Type As PageType)
241: Private Function PageChange(Type As PageType, Anim As Boolean)
245: #Region "确定更改的页面实例并实例化"
250: #Region "切换页面"
291: Public Sub RefreshPage(KeepInput As Boolean, Anim As Boolean)
373: Private Sub RadioLoginType_Change(sender As Object, raiseByMouse As Boolean) Handles RadioLoginType0.Check, RadioLoginType5.Check
379: #Region "皮肤"
383: Private Shared Function SkinMsInput() As (String, String)
387: Private Shared Sub SkinMsLoad(Data As LoaderTask(Of (String, String), String))
431: Private Shared Function SkinLegacyInput() As (String, String)
449: Private Shared Sub SkinLegacyLoad(Data As LoaderTask(Of (String, String), String))
505: Private Shared Function SkinNideInput() As (String, String)
509: Private Shared Sub SkinNideLoad(Data As LoaderTask(Of (String, String), String))
553: Private Shared Function SkinAuthInput() As (String, String)
557: Private Shared Sub SkinAuthLoad(Data As LoaderTask(Of (String, String), String))
606: Private Sub BtnVersion_Click() Handles BtnVersion.Click
611: Public Sub LaunchButtonClick() Handles BtnLaunch.Click
634: Public Sub RefreshButtonsUI() Handles BtnLaunch.Loaded
694: Private Sub BtnCancel_Click() Handles BtnCancel.Click
710: Private Sub BtnMore_Click() Handles BtnMore.Click
719: Public Sub LaunchingRefresh()
802: Private Sub PanLaunchingInfo_SizeChangedW(sender As Object, e As SizeChangedEventArgs) Handles PanLaunchingInfo.SizeChanged
818: Private Sub PanLaunchingInfo_SizeChangedH(sender As Object, e As SizeChangedEventArgs) Handles PanLaunchingInfo.SizeChanged

## Plain Craft Launcher 2/Pages/PageLaunch/PageLaunchRight.xaml (18 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLaunchRight.xaml.vb (278 lines)
3: Public Class PageLaunchRight
6: Private Sub Init() Handles Me.Loaded
15: #Region "主页"
20: Private Sub Refresh() Handles Me.Loaded
32: Private Sub RefreshReal()
144: Private Sub OnlineLoaderSub(Task As LoaderTask(Of (Address As String, ShouldRefresh As Boolean), Integer))
192: Public Sub ForceRefresh() Implements IRefreshable.Refresh
207: Private Sub ClearCache()
219: Private Sub LoadContent(Content As String)
254: Private Sub OnLoadContentFailed(ex As Exception)
266: Private Sub DispatcherUnhandledException(sender As Object, e As DispatcherUnhandledExceptionEventArgs) Implements IDispatcherUnhandledException.DispatcherUnhandledException

## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginAuth.xaml (24 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginAuth.xaml.vb (86 lines)
1: Public Class PageLoginAuth
6: Public Sub Reload(KeepInput As Boolean)
29: Public Shared Function GetLoginData() As McLoginServer
40: Public Shared Function IsVaild(LoginData As McLoginServer) As String
45: Public Function IsVaild() As String
50: Private Sub ComboName_TextChanged(sender As Object, e As TextChangedEventArgs) Handles ComboName.TextChanged
54: Private Sub TextPass_PasswordChanged(sender As Object, e As RoutedEventArgs) Handles TextPass.PasswordChanged
57: Private Sub ComboName_SelectionChanged(sender As MyComboBox, e As SelectionChangedEventArgs) Handles ComboName.SelectionChanged
64: Private Sub CheckBoxChange(sender As MyCheckBox, e As Object) Handles CheckRemember.Change
69: Private Sub ComboName_TextChanged() Handles ComboName.TextChanged
72: Private Sub Btn_Click(sender As Object, e As EventArgs) Handles BtnLink.Click
81: Private Sub ReloadRegisterButton() Handles Me.Loaded

## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginAuthSkin.xaml (27 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginAuthSkin.xaml.vb (85 lines)
1: Public Class PageLoginAuthSkin
3: Public Sub New()
7: Private Sub PageLoginLegacy_Loaded() Handles Me.Loaded
14: Public Sub Reload(KeepInput As Boolean)
23: Public Shared Function GetLoginData() As McLoginServer
28: Private Sub PageLoginAuthSkin_MouseEnter(sender As Object, e As MouseEventArgs) Handles PanData.MouseEnter
38: Private Sub PageLoginAuthSkin_MouseLeave(sender As Object, e As MouseEventArgs) Handles PanData.MouseLeave
47: Private Sub BtnEdit_Click(sender As Object, e As EventArgs) Handles BtnEdit.Click
72: Public Shared Sub ExitLogin() Handles BtnExit.Click
80: Private Sub Skin_Click(sender As Object, e As MouseButtonEventArgs) Handles Skin.Click

## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginLegacy.xaml (13 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginLegacy.xaml.vb (77 lines)
3: Public Class PageLoginLegacy
5: Public Sub New()
9: Private Sub PageLoginLegacy_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
17: Public Sub Reload(KeepInput As Boolean)
37: Public Shared Function GetLoginData() As McLoginData
44: Public Shared Function IsVaild(LoginData As McLoginLegacy) As String
54: Public Function IsVaild() As String
58: Private Sub ComboName_PreviewKeyDown(sender As Object, e As Input.KeyEventArgs) Handles ComboName.PreviewKeyDown
64: Private Sub ComboLegacy_TextChanged(sender As Object, e As TextChangedEventArgs) Handles ComboName.TextChanged
69: Private Sub Skin_Click() Handles Skin.Click

## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginMs.xaml (36 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginMs.xaml.vb (108 lines)
1: Public Class PageLoginMs
6: Public Sub Reload(KeepInput As Boolean)
27: Private Sub ComboAccounts_SelectionChanged(sender As Object, e As SelectionChangedEventArgs) Handles ComboAccounts.SelectionChanged
39: Public Shared Function GetLoginData() As McLoginMs
56: Public Shared Function IsVaild(LoginData As McLoginMs) As String
63: Public Function IsVaild() As String
67: Private Sub BtnLogin_Click(sender As Object, e As EventArgs) Handles BtnLogin.Click

## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginMsSkin.xaml (55 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginMsSkin.xaml.vb (180 lines)
1: Public Class PageLoginMsSkin
3: Public Sub New()
7: Private Sub PageLoginLegacy_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
14: Public Sub Reload(KeepInput As Boolean)
21: Public Shared Function GetLoginData() As McLoginMs
29: #Region "下边栏其他内容"
32: Private Sub ShowPanel(sender As Object, e As MouseEventArgs) Handles PanData.MouseEnter
35: Public Sub HidePanel(sender As Object, e As EventArgs) Handles PanData.MouseLeave
41: Private Sub BtnEdit_Click(sender As Object, e As EventArgs) Handles BtnEdit.Click
46: Private Sub BtnExit_Click() Handles BtnExit.Click
59: #Region "皮肤/披风"
62: Private Sub BtnSkin_Click(sender As Object, e As RoutedEventArgs) Handles BtnSkin.Click
68: Public Sub BtnSkinEdit_Click(sender As Object, e As RoutedEventArgs)
85: Private Sub EditSkin(SkinInfo As McSkinInfo)
146: Public Sub BtnSkinSave_Click(sender As Object, e As RoutedEventArgs)
151: Public Sub BtnSkinRefresh_Click(sender As Object, e As RoutedEventArgs)
156: Public Sub BtnSkinCape_Click(sender As Object, e As RoutedEventArgs)
161: Public Sub BtnSkinCapeRefresh_Click(sender As Object, e As RoutedEventArgs)

## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginNide.xaml (24 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginNide.xaml.vb (80 lines)
1: Public Class PageLoginNide
6: Public Sub Reload(KeepInput As Boolean)
29: Public Shared Function GetLoginData() As McLoginServer
40: Public Shared Function IsVaild(LoginData As McLoginServer) As String
45: Public Function IsVaild() As String
50: Private Sub ComboName_TextChanged(sender As Object, e As TextChangedEventArgs) Handles ComboName.TextChanged
54: Private Sub TextPass_PasswordChanged(sender As Object, e As RoutedEventArgs) Handles TextPass.PasswordChanged
57: Private Sub ComboName_SelectionChanged(sender As MyComboBox, e As SelectionChangedEventArgs) Handles ComboName.SelectionChanged
64: Private Sub CheckBoxChange(sender As MyCheckBox, e As Object) Handles CheckRemember.Change
69: Private Sub ComboName_TextChanged() Handles ComboName.TextChanged
72: Private Sub Btn_Click(sender As Object, e As EventArgs) Handles BtnLink.Click

## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginNideSkin.xaml (28 lines)


## Plain Craft Launcher 2/Pages/PageLaunch/PageLoginNideSkin.xaml.vb (57 lines)
1: Public Class PageLoginNideSkin
3: Public Sub New()
7: Private Sub PageLoginLegacy_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
14: Public Sub Reload(KeepInput As Boolean)
23: Public Shared Function GetLoginData() As McLoginServer
28: Private Sub PageLoginNideSkin_MouseEnter(sender As Object, e As MouseEventArgs) Handles PanData.MouseEnter
38: Private Sub PageLoginNideSkin_MouseLeave(sender As Object, e As MouseEventArgs) Handles PanData.MouseLeave
47: Public Shared Sub ExitLogin() Handles BtnExit.Click
53: Private Sub Skin_Click(sender As Object, e As MouseButtonEventArgs) Handles Skin.Click

## Plain Craft Launcher 2/Pages/PageLink/PageLinkMain.xaml (207 lines)


## Plain Craft Launcher 2/Pages/PageLink/PageLinkMain.xaml.vb (1116 lines)
7: Public Class PageLinkMain
14: #Region "状态管理"
16: Public Enum LinkStates
27: Private Sub ChangeState(NewState As LinkStates)
49: Private Sub LoaderInit() Handles Me.Initialized
64: Private Sub UpdatePanelVisibility() Handles Me.PageEnter
71: #Region "初始页面 (Waiting)"
74: Private Sub SwitchToWaiting(OldState As LinkStates)
95: Private Sub Create_MouseLeftButtonUp() Handles PanSelectCreate.MouseLeftButtonUp
125: Public Shared Sub Join() Handles PanSelectJoin.MouseLeftButtonUp
132: Public Sub JoinInternal(Code As String)
157: Public Shared Function ValidateCodeFormat(Code As String) As String
175: Private Shared Function FixCodeFormat(Code As String) As String
190: Public Shared Sub Join(Code As String)
202: Private Sub PanSelectJoin_Loaded() Handles PanSelectJoin.Loaded
210: #Region "加载页面 (Loading | Failed)"
213: Private Sub SwitchToLoading(OldState As LinkStates)
227: Private Sub SwitchToFailed(OldState As LinkStates)
250: Private Sub UpdateLoadingPage(Title As String, FailBrief As String)
263: Private Sub BtnLoadCancel_Click() Handles BtnLoadCancel.Click
268: Private Sub CardLoad_MouseLeftButtonUp() Handles CardLoad.MouseLeftButtonUp
273: Private Sub UpdateProgressBar(Optional Value As Double = -1)
290: Private Sub CardLoad_SizeChanged() Handles CardLoad.SizeChanged
296: #Region "完成页面 (Finished)"
299: Private Sub SwitchToFinished(OldState As LinkStates)
338: Private Sub BtnFinishExit_Click() Handles BtnFinishExit.Click
345: Public Function TryExit(Silent As Boolean, Closing As Boolean) As Boolean
359: Private Sub Copy() Handles BtnFinishCopy.Click
365: Private Function GetInviteCode() As String
371: Private Sub BtnFinishIp_MouseLeftButtonUp(sender As Object, e As MouseButtonEventArgs) Handles BtnFinishIp.MouseLeftButtonUp
417: #Region "加载"
427: Private Sub InitConfig(Task As LoaderTask(Of Integer, Integer))
445: Private Sub InitPrepareDownload(Task As LoaderTask(Of Integer, List(Of NetFile)))
484: Private Sub InitLaunch(Task As LoaderTask(Of Integer, Integer))
607: Private Function GetTargetPeers() As List(Of String)
698: #Region "进程与日志"
710: Public Shared Sub ProcessStop()
741: Private Sub Panic(Brief As String, Detail As String)
760: Private Sub ProcessStart(Arguments As String)
794: Private Sub ProcessLogLine(Line As String)
812: #Region "CLI 节点信息获取"
814: Private Class Peer
819: Public Enum Types
858: Public Sub New(Info As JObject)
880: Private Enum NATTypes
914: Private Sub RefreshPeer()
954: Private Function GetPeerPing() As Double
963: Private Function GetTargetPeer() As Peer
990: #Region "定时任务"
993: Private Sub StartTimerThread() Handles Me.Loaded
1019: Private Sub Update() Handles Me.Loaded
1109: Private Sub CheckCrash()

## Plain Craft Launcher 2/Pages/PageOther/PageOtherAbout.xaml (659 lines)


## Plain Craft Launcher 2/Pages/PageOther/PageOtherAbout.xaml.vb (34 lines)
1: Public Class PageOtherAbout
4: Private Sub PageOtherAbout_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
21: Public Shared Sub CopyIdentify() Handles BtnDonateCopy.Click
24: Private Sub BtnDonateCodeInput_Click() Handles BtnDonateInput.Click
27: Private Sub BtnDonateOutput_Click(sender As Object, e As EventArgs) Handles BtnDonateOutput.Click
30: Private Sub BtnAboutUpdate_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnAboutUpdate.Click

## Plain Craft Launcher 2/Pages/PageOther/PageOtherHelp.xaml (23 lines)


## Plain Craft Launcher 2/Pages/PageOther/PageOtherHelp.xaml.vb (178 lines)
1: Public Class PageOtherHelp
4: #Region "初始化"
7: Private Sub PageOther_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
11: Private Sub PageOther_Inited(sender As Object, e As EventArgs) Handles Me.Initialized
20: Private Sub HelpListLoad(Loader As LoaderTask(Of Integer, List(Of HelpEntry)))
71: Public Shared Sub OnItemClick(Entry As HelpEntry)
82: Public Shared Sub EnterHelpPage(Location As String)
98: Public Shared Sub EnterHelpPage(Entry As HelpEntry)
117: Public Sub SearchRun() Handles SearchBox.TextChanged
175: Public Sub Refresh() Implements IRefreshable.Refresh

## Plain Craft Launcher 2/Pages/PageOther/PageOtherHelpDetail.xaml (24 lines)


## Plain Craft Launcher 2/Pages/PageOther/PageOtherHelpDetail.xaml.vb (37 lines)
1: Public Class PageOtherHelpDetail
5: Public Sub Refresh() Implements IRefreshable.Refresh
9: Private Sub PageOtherHelpDetail_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
16: Public Function Init(Entry As HelpEntry) As Boolean

## Plain Craft Launcher 2/Pages/PageOther/PageOtherLeft.xaml (23 lines)


## Plain Craft Launcher 2/Pages/PageOther/PageOtherLeft.xaml.vb (159 lines)
1: Public Class PageOtherLeft
5: Private Sub PageOtherLeft_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
27: Private Sub PageOtherLeft_Unloaded(sender As Object, e As RoutedEventArgs) Handles Me.Unloaded
31: #Region "页面切换"
37: Public Sub New()
52: Private Sub PageCheck(sender As FrameworkElement, e As RouteEventArgs) Handles ItemAbout.Check, ItemHelp.Check, ItemTest.Check
58: Public Function PageGet(Optional ID As FormMain.PageSubType = -1)
78: Public Sub PageChange(ID As FormMain.PageSubType)
91: Private Shared Sub PageChangeRun(Target As MyPageRight)
113: Public Sub Refresh(sender As Object, e As EventArgs) '由边栏按钮匿名调用
121: Public Shared Sub RefreshHelp()
128: Private Sub TryFeedback(sender As Object, e As RouteEventArgs) Handles ItemFeedback.Changed
133: Public Shared Sub TryFeedback()
148: Private Sub TryVote(sender As Object, e As RouteEventArgs) Handles ItemVote.Changed
153: Public Shared Sub TryVote()

## Plain Craft Launcher 2/Pages/PageOther/PageOtherTest.xaml (12 lines)


## Plain Craft Launcher 2/Pages/PageOther/PageOtherTest.xaml.vb (28 lines)
1: Public Class PageOtherTest
3: Public Shared Sub StartCustomDownload(Url As String, FileName As String, Optional Folder As String = Nothing)
6: Public Shared Sub Jrrp()
9: Public Shared Sub RubbishClear()
12: Public Shared Sub MemoryOptimize(ShowHint As Boolean)
15: Public Shared Sub MemoryOptimizeInternal(ShowHint As Boolean)
18: Public Shared Function GetRandomCave() As String
21: Public Shared Function GetRandomHint() As String
24: Public Shared Function GetRandomPresetHint() As String

## Plain Craft Launcher 2/Pages/PageSelectLeft.xaml (17 lines)


## Plain Craft Launcher 2/Pages/PageSelectLeft.xaml.vb (405 lines)
1: Public Class PageSelectLeft
4: Private Sub PageSelectLeft_Initialized(sender As Object, e As EventArgs) Handles Me.Initialized
8: Private Sub PageSelectLeft_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
12: Private Sub McFolderListUI()
140: Public Sub Add_Click()
168: Public Shared Sub AddFolder(FolderPath As String, DisplayName As String, ShowHint As Boolean)
248: Public Sub Create_Click()
257: Public Shared Sub CreateMcFolderInCurrentPath()
267: Public Sub Remove_Click(sender As Object, e As RoutedEventArgs)
294: Public Sub Delete_Click(sender As Object, e As RoutedEventArgs)
327: Private Shared Function RemoveFolderFromSetup(Target As McFolder) As String
340: Public Sub Open_Click(sender As Object, e As RoutedEventArgs)
343: Public Sub Refresh_Click(sender As Object, e As RoutedEventArgs)
347: Public Sub RefreshCurrent() Implements IRefreshable.Refresh
350: Public Shared Sub RefreshCurrent(Folder As String)
354: Public Sub Rename_Click(sender As Object, e As RoutedEventArgs)
391: Public Sub Folder_Change(sender As MyListItem, e As RouteEventArgs)

## Plain Craft Launcher 2/Pages/PageSelectRight.xaml (25 lines)


## Plain Craft Launcher 2/Pages/PageSelectRight.xaml.vb (240 lines)
1: Public Class PageSelectRight
4: Private Sub PageSelectRight_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
8: Private Sub LoaderInit() Handles Me.Initialized
11: Private Sub Load_Click(sender As Object, e As MouseButtonEventArgs) Handles Load.Click
23: #Region "结果 UI 化"
25: Private Sub McInstanceListUI(Loader As LoaderTask(Of String, Integer))
33: #Region "确认卡片名称"
116: Public Shared Sub McInstanceListContent(sender As MyListItem, e As EventArgs)
164: #Region "页面事件"
167: Public Shared Sub Item_Click(sender As MyListItem, e As EventArgs)
179: Private Sub BtnDownload_Click(sender As Object, e As EventArgs) Handles BtnEmptyDownload.Click
184: Public Shared Sub DeleteInstance(Item As MyListItem, Instance As McInstance)
230: Public Sub BtnEmptyDownload_Loaded() Handles BtnEmptyDownload.Loaded

## Plain Craft Launcher 2/Pages/PageSetup/PageSetupLaunch.xaml (299 lines)


## Plain Craft Launcher 2/Pages/PageSetup/PageSetupLaunch.xaml.vb (515 lines)
1: Public Class PageSetupLaunch
3: Private Sub PageSetupLaunch_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
24: Public Sub Refresh()
37: Public Sub Reset()
51: #Region "离线皮肤"
53: Private Sub BtnSkinChange_Click(sender As Object, e As EventArgs) Handles BtnSkinChange.Click
58: Private Sub RadioSkinType3_Check(sender As Object, e As RouteEventArgs) Handles RadioSkinType4.PreviewCheck
72: Private Function ChangeSkin(SkinInfo As McSkinInfo) As Boolean
98: Private Sub BtnSkinDelete_Click(sender As Object, e As EventArgs) Handles BtnSkinDelete.Click
107: Private Sub BtnSkinSave_Click(sender As Object, e As EventArgs) Handles BtnSkinSave.Click
110: Private Sub BtnSkinCache_Click(sender As Object, e As EventArgs) Handles BtnSkinCache.Click
114: Public Shared Sub UpdateSkinType()
134: #Region "游戏内存"
136: Public Shared Sub UpdateRamType()
144: Public Sub RefreshRam(ShowAnim As Boolean)
182: Private Sub RefreshRam() Handles SliderRamCustom.Change, RadioRamType0.Check, RadioRamType1.Check
190: Private Sub RefreshRamText() Handles RectRamGame.SizeChanged, RectRamEmpty.SizeChanged, LabRamGame.SizeChanged
273: Public Shared Function GetRam(Instance As McInstance, UseVersionJavaSetup As Boolean) As Double
352: #Region "Java 选择"
356: Public Sub UpdateJavaList()
425: Private Sub MoveJavaInList(JavaEntry As Java, Offset As Integer)
436: Private Sub BtnAdvanceJavaSearch_Click() Handles BtnAdvanceJavaSearch.Click
442: #Region "其他选项"
444: Private Sub WindowTypeUIRefresh() Handles ComboArgumentWindowType.SelectionChanged
452: Private Sub ComboArgumentVisibie_SizeChanged(sender As Object, e As SelectionChangedEventArgs) Handles ComboArgumentVisibie.SelectionChanged
463: Private Sub CheckArgumentRam_Change() Handles CheckArgumentRam.Change
475: Private Sub ComboArgumentIndie_SelectionChanged(sender As Object, e As SelectionChangedEventArgs) Handles ComboArgumentIndieV2.SelectionChanged
482: #Region "高级设置"
484: Private Sub TextAdvanceRun_TextChanged(sender As Object, e As TextChangedEventArgs) Handles TextAdvanceRun.TextChanged
489: Private Sub TextAdvanceJvm_TextChanged() Handles TextAdvanceJvm.ValidatedTextChanged
492: Private Sub BtnAdvanceJvmReset_Click(sender As Object, e As EventArgs) Handles BtnAdvanceJvmReset.Click
498: Private Sub ReplaceEnter(sender As MyTextBox, e As TextChangedEventArgs) Handles TextAdvanceJvm.TextChanged, TextAdvanceGame.TextChanged
509: Private Sub BtnSwitch_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnSwitch.Click

## Plain Craft Launcher 2/Pages/PageSetup/PageSetupLeft.xaml (40 lines)


## Plain Craft Launcher 2/Pages/PageSetup/PageSetupLeft.xaml.vb (175 lines)
1: Public Class PageSetupLeft
5: Private Sub PageSetupLeft_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
32: Private Sub PageOtherLeft_Unloaded(sender As Object, e As RoutedEventArgs) Handles Me.Unloaded
36: #Region "页面切换"
42: Public Sub New()
61: Private Sub PageCheck(sender As MyListItem, e As EventArgs) Handles ItemLaunch.Check, ItemSystem.Check, ItemUI.Check, ItemLink.Check
70: Public Function PageGet(Optional ID As FormMain.PageSubType = -1)
93: Public Sub PageChange(ID As FormMain.PageSubType)
123: Private Shared Sub PageChangeRun(Target As MyPageRight)
146: Public Sub Reset(sender As Object, e As EventArgs)

## Plain Craft Launcher 2/Pages/PageSetup/PageSetupLink.xaml (55 lines)


## Plain Craft Launcher 2/Pages/PageSetup/PageSetupLink.xaml.vb (34 lines)
1: Public Class PageSetupLink
3: Private Sub PageSetupLink_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
18: Public Sub Reload()
23: Public Sub Reset()

## Plain Craft Launcher 2/Pages/PageSetup/PageSetupSystem.xaml (212 lines)


## Plain Craft Launcher 2/Pages/PageSetup/PageSetupSystem.xaml.vb (133 lines)
1: Public Class PageSetupSystem
4: Private Sub PageSetupSystem_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
27: Public Sub Reload()
30: Public Sub Reset()
42: Private Sub SliderLoad()
59: Private Sub SliderDownloadThread_PreviewChange(sender As Object, e As RouteEventArgs) Handles SliderDownloadThread.PreviewChange
69: Private Sub BtnSystemIdentify_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnSystemIdentify.Click
72: Private Sub BtnSystemUnlock_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnSystemUnlock.Click
77: Private Sub CheckDebugMode_Change() Handles CheckDebugMode.Change
82: Private Sub ComboSystemActivity_SelectionChanged(sender As Object, e As SelectionChangedEventArgs) Handles ComboSystemActivity.SelectionChanged
92: Private Sub ComboSystemUpdate_SelectionChanged(sender As Object, e As SelectionChangedEventArgs) Handles ComboSystemUpdate.SelectionChanged
102: Private Sub BtnSystemUpdate_Click(sender As Object, e As EventArgs) Handles BtnSystemUpdate.Click
109: Public Shared Function IsLauncherNewest() As Boolean?
122: #Region "导出 / 导入设置"
124: Private Sub BtnSystemSettingExp_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnSystemSettingExp.Click
127: Private Sub BtnSystemSettingImp_Click(sender As Object, e As MouseButtonEventArgs) Handles BtnSystemSettingImp.Click

## Plain Craft Launcher 2/Pages/PageSetup/PageSetupUI.xaml (340 lines)


## Plain Craft Launcher 2/Pages/PageSetup/PageSetupUI.xaml.vb (614 lines)
1: Public Class PageSetupUI
3: Private Sub PageSetupUI_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
41: Public Sub Refresh()
63: Public Sub Reset()
75: Private Sub BtnUIBgOpen_Click(sender As Object, e As EventArgs) Handles BtnBackgroundOpen.Click
78: Private Sub BtnBackgroundRefresh_Click(sender As Object, e As EventArgs) Handles BtnBackgroundRefresh.Click
81: Public Sub BackgroundRefreshUI(Show As Boolean, Count As Integer)
98: Private Sub BtnBackgroundClear_Click(sender As Object, e As EventArgs) Handles BtnBackgroundClear.Click
110: Public Shared Sub BackgroundRefresh(IsHint As Boolean, Refresh As Boolean)
157: Private Sub BtnLogoChange_Click(sender As Object, e As EventArgs) Handles BtnLogoChange.Click
176: Private Sub RadioLogoType3_Check(sender As Object, e As RouteEventArgs) Handles RadioLogoType3.PreviewCheck
215: Private Sub BtnLogoDelete_Click(sender As Object, e As EventArgs) Handles BtnLogoDelete.Click
226: Private Sub BtnMusicOpen_Click(sender As Object, e As EventArgs) Handles BtnMusicOpen.Click
229: Private Sub BtnMusicRefresh_Click(sender As Object, e As EventArgs) Handles BtnMusicRefresh.Click
232: Public Sub MusicRefreshUI()
249: Private Sub BtnMusicClear_Click(sender As Object, e As EventArgs) Handles BtnMusicClear.Click
275: Private Sub CheckMusicStart_Change() Handles CheckMusicStart.Change
279: Private Sub CheckMusicStop_Change() Handles CheckMusicStop.Change
285: Private Sub BtnCustomFile_Click(sender As Object, e As EventArgs) Handles BtnCustomFile.Click
297: Private Sub BtnCustomRefresh_Click() Handles BtnCustomRefresh.Click
301: Private Sub BtnCustomTutorial_Click(sender As Object, e As EventArgs) Handles BtnCustomTutorial.Click
309: Public Shared Sub OnMainPageTypeChanged()
346: Private Sub LabLauncherTheme5Unlock_MouseLeftButtonUp(sender As Object, e As MouseButtonEventArgs) Handles LabLauncherTheme5Unlock.MouseLeftButtonUp
359: Private Sub LabLauncherTheme11Click_MouseLeftButtonUp() Handles LabLauncherTheme11Click.MouseLeftButtonUp, RadioLauncherTheme11.MouseRightButtonUp
372: Private Sub LabLauncherTheme8Copy_MouseRightButtonUp() Handles LabLauncherTheme8Copy.MouseRightButtonUp, RadioLauncherTheme8.MouseRightButtonUp
375: Private Sub LabLauncherTheme9Copy_MouseRightButtonUp() Handles LabLauncherTheme9Copy.MouseRightButtonUp, RadioLauncherTheme9.MouseRightButtonUp
380: Private Sub RadioLauncherTheme14_Change(sender As Object, e As RouteEventArgs) Handles RadioLauncherTheme14.Changed
404: Private Sub HSL_Change() Handles SliderLauncherHue.Change, SliderLauncherLight.Change, SliderLauncherSat.Change, SliderLauncherDelta.Change
409: #Region "功能隐藏"
428: Public Shared Sub HiddenRefresh() Handles Me.Loaded
501: Private Sub HiddenSetupMain() Handles CheckHiddenPageSetup.Change
519: Private Sub HiddenSetupSub() Handles CheckHiddenSetupLaunch.Change, CheckHiddenSetupSystem.Change, CheckHiddenSetupLink.Change, CheckHiddenSetupUI.Change
529: Private Sub HiddenOtherMain() Handles CheckHiddenPageOther.Change
550: Private Sub HiddenOtherSub(sender As Object, user As Boolean) Handles CheckHiddenOtherHelp.Change, CheckHiddenOtherAbout.Change, CheckHiddenOtherTest.Change
566: Private Sub HiddenOtherNet(sender As Object, user As Boolean) Handles CheckHiddenOtherFeedback.Change, CheckHiddenOtherVote.Change
578: Private Sub HiddenHint(sender As Object, user As Boolean) Handles CheckHiddenFunctionHidden.Change, CheckHiddenPageSetup.Change, CheckHiddenSetupUI.Change
585: Private Sub SliderLoad()

## Plain Craft Launcher 2/Pages/PageSetup/SettingService.vb (81 lines)
1: Public Class SettingService
3: #Region "属性"
8: Public Shared Function GetKey(obj As DependencyObject) As String
12: Public Shared Sub SetKey(obj As DependencyObject, value As String)
21: Public Shared Function GetValue(obj As DependencyObject) As String
25: Public Shared Sub SetValue(obj As DependencyObject, value As String)
36: Public Shared Sub ResetSettings(Target As DependencyObject)
46: Public Shared Sub RefreshSettings(Target As DependencyObject)
57: Public Shared Sub SaveSetting(sender As Object)
74: Sub RefreshSetting(NewValue As String)
79: Function GetCurrentSetting() As String

## Plain Craft Launcher 2/Pages/PageSetup/Settings.vb (478 lines)
3: Public Class Settings
199: Public Enum Sources
204: Public Class Setting
217: Public Sub New(Key As String, Value As Object, Optional Source As Sources = Sources.Normal, Optional Encrypted As Boolean = False, Optional OnChanged As Action(Of Object) = Nothing)
235: Public Function GetCache(Instance As McInstance)
240: Public Sub [Set](Value As Object, Instance As McInstance)
248: Public Sub Save(Optional Instance As McInstance = Nothing)
279: Public Shared Sub [Set](Key As String, Value As Object, Optional Instance As McInstance = Nothing)
300: Public Shared Sub SetSafe(Key As String, Value As Object, Optional Instance As McInstance = Nothing)
310: Public Shared Function [Get](Key As String, Optional Instance As McInstance = Nothing)
362: Public Shared Function [Get](Of T)(Key As String, Optional Instance As McInstance = Nothing) As T
369: Public Shared Function GetSafe(Key As String, Optional Instance As McInstance = Nothing)
379: Public Shared Sub Reset(Key As String, Optional Instance As McInstance = Nothing)
411: Public Shared Function GetDefault(Key As String) As String
419: Public Shared Function HasSaved(Key As String, Optional Instance As McInstance = Nothing) As Boolean
436: #Region "DES 加密"
443: Private Shared Function DesEncrypt(sourceString As String, Optional key As String = Nothing) As String
461: Private Shared Function DesDecrypt(encryptedString As String, Optional key As String = Nothing) As String

## Plain Craft Launcher 2/Pages/PageSpeedLeft.xaml (60 lines)


## Plain Craft Launcher 2/Pages/PageSpeedLeft.xaml.vb (235 lines)
1: Public Class PageSpeedLeft
6: Private Sub Page_Loaded(sender As Object, e As RoutedEventArgs) Handles Me.Loaded
34: Private Sub Watcher()
38: #Region "更新左边栏"
69: Public Sub TaskRefresh(Loader As LoaderBase)
88: #Region "失败，更新卡片"
102: #Region "完成或中断，销毁卡片并返回"
106: #Region "进度不同，更新卡片"
145: #Region "没有卡片且未中断或完成，添加新的卡片"
213: Public Sub TaskRemove(Loader As Object)
229: Private Sub TryReturnToHome()

## Plain Craft Launcher 2/Pages/PageSpeedRight.xaml (40 lines)


## Plain Craft Launcher 2/Pages/PageSpeedRight.xaml.vb (7 lines)
1: Public Class PageSpeedRight
3: Private Sub Init() Handles Me.Loaded

## Plain Craft Launcher 2/Plain Craft Launcher 2.vbproj (953 lines)


## Plain Craft Launcher 2/Resources/Custom.xaml (345 lines)


## Plain Craft Launcher 2/app.manifest (77 lines)


## Plain Craft Launcher 2.sln (64 lines)


## README.md (17 lines)


## patches/Release 2.12.6.1 9a121b67d985e547b3e91efab989cb37.patch (24124 lines)


## patches/Release 2.12.6.2 92886839e678a82edf4d0eb44de79e7b.patch (23647 lines)


## patches/Release 2.12.7.0 59bd8d9e0fca84018f1de85eb475de72.patch (23467 lines)


## patches/Release 2.12.7.1 2f8e93f0f5a6fe1196bcff57e72ce846.patch (23369 lines)


## patches/Release 2.12.7.2 f98967def1023f767826c8e091a929ad.patch (23245 lines)


## patches/Release 2.12.7.3 be51f8b75323affbcd0019bdc338e860.patch (23525 lines)


## patches/Release 2.12.8.0 4fe696b473f51336787769f9f7d1f64b.patch (13533 lines)


## patches/Release 2.12.8.1 f9ea50a2f833f5c9ac962cfea2a9a119.patch (13719 lines)


## patches/Release 2.12.8.2 6765e08a37c1ee3fff49c529769ab1c9.patch (13442 lines)


## patches/Release 2.13.0.0 7fd5ff082ec9c6b74a6e9bfa322df201.patch (3010 lines)
