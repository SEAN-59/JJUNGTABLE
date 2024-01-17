//
//  Prefix.swift
//  SomeFuncTest
//
//  Created by Sean Kim on 2023/09/21.
//

import UIKit

// MARK: - TYPEALIAS
typealias VOID_TO_VOID = () -> ()

// MARK: - ABBREVIATION
let T = true
let F = false




// MARK: - VARIABLE
public let naviController = BaseNaviController()
public let viewControllers = naviController.viewControllers

public var KEYBOARD_UP_HEIGHT: CGFloat = 46.0

enum DEError: Error {
    case eseanError
    case dseanError
}



// MARK: - FUNCTION
/// print 를 조금 더 자세하게 표기해주는 함수
public func printLog<T>(_ object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
#if DEBUG
    let dateString = Date().convertString("yyyy/MM/dd HH:mm:ss:SSS")
    Swift.print("""
                _____ _____ _____ _____ _____ _____ _____ _____ _____ _____
                |*   TIME = [\(dateString)] || FILE = [\(file.lastPathComponent)]
                |    NAME = [\(function)] || LINE = [\(line)]
                |>>> PRINT = \(object)
                """)
    
    //    let process = ProcessInfo.processInfo
    //    var tid: UInt64 = 0
    //    pthread_threadid_np(nil, &tid)
    //    let threadId = tid
    //    Swift.print("\(dateString) \(process.processName)[\(process.processIdentifier):\(threadId)] \(file.lastPathComponent)(\(line)) \(function):\t \(object)")
#else
    
#endif
}

public func getDeviceWidth() -> CGFloat { UIScreen.main.bounds.size.width }

public func getDeviceHeight() -> CGFloat { UIScreen.main.bounds.size.height }

/// 탈옥 여부 파악 함수 : true 면 탈옥임
public func isIllegalDevice() -> Bool {
    func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
    
    guard let cydiaUrlScheme = NSURL(string: "cydia://package/com.example.package") else { return false }
    if UIApplication.shared.canOpenURL(cydiaUrlScheme as URL) {
        return true
    }
    
#if arch(i386) || arch(x86_64)
    return false
#endif
    
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
        fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
        fileManager.fileExists(atPath: "/bin/bash") ||
        fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
        fileManager.fileExists(atPath: "/etc/apt") ||
        fileManager.fileExists(atPath: "/usr/bin/ssh") ||
        fileManager.fileExists(atPath: "/private/var/lib/apt") {
        return true
    }
    if canOpen(path: "/Applications/Cydia.app") ||
        canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
        canOpen(path: "/bin/bash") ||
        canOpen(path: "/usr/sbin/sshd") ||
        canOpen(path: "/etc/apt") ||
        canOpen(path: "/usr/bin/ssh") {
        return true
    }
    let path = "/private/" + NSUUID().uuidString
    do {
        try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        try fileManager.removeItem(atPath: path)
        return true
    } catch let error { // 이 부분
        printLog("Jail ERROR: \(error))")
        return false
    }
}
/// ALERT 띄우기
///
/// <최상단 VC에 올리는 방법>
///
/// makeAlert(naviController.viewControllers[naviController.viewControllers.count - 1], title: "오류", message: "다시 한 번 시도해주세요.", actionTitle: ["확인"], handler: [{_ in}])
public func makeAlert(_ vc: UIViewController, title: String, message: String, actionTitle: [String], style: [UIAlertAction.Style] = [.default], handler: [((UIAlertAction)->())?]) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    
    let actionStyle: [UIAlertAction.Style] = {
        if style.count != actionTitle.count {
            var array = style
            for _ in 0 ..< (actionTitle.count - style.count) { array.append(.default) }
            return array
        } else {
            return style
        }
    }()
    
    let actionHandler: [((UIAlertAction)->())?] = {
        if handler.count != actionTitle.count {
            var array = handler
            for _ in 0 ..< (actionTitle.count - handler.count) { array.append(nil) }
            return array
        } else {
            return handler
        }
    }()
    
    for i in 0 ..< actionTitle.count {
        alertController.addAction(UIAlertAction(title: actionTitle[i],
                                                style: actionStyle[i],
                                                handler: actionHandler[i]))
    }
    
    vc.present(alertController, animated: true, completion: nil)
}


// 암호화
func esean(_ key: String, str: String) -> Result<String,DEError> {
    printLog("[eevsean]: \(key), \(str)")
    if let eevsean = AES256CBC.encryptString(str, password: key) {
        printLog("[eevsean]: \(eevsean)")
        return .success(eevsean)
    } else {
        return .failure(.eseanError)
    }
}

// 복호화
func dseae(_ key: String, str: String) -> Result<String,DEError> {
    printLog("[devseae]: \(key), \(str)")
    if let devseae = AES256CBC.decryptString(str, password: key) {
        printLog("[devseae]: \(devseae)")
        return .success(devseae)
    } else {
        return .failure(.dseanError)
    }
}


func getTextfieldValue(_ txfText: String?) -> String {
    guard let text = txfText else { return "" }
    return text
}

func optStr(_ optional: Any?) -> String {
    guard let optional = optional as? String else { return "" }
    return optional
}

func compareAppVersion(_ version: String, _ compareVer: String) -> CompareValue {
    let ver = version.components(separatedBy: ["."]).map{Int($0) ?? 0}
    let compare = compareVer.components(separatedBy: ["."]).map{Int($0) ?? 0}
    
    for i in 0 ..< ver.count {
        // 비교 대상보다 더 큼
        if ver[i] > compare[i] { return .bigger }
        // 비교 대상보다 더 작음
        else if ver[i] < compare[i] { return .smaller }
    }
    // 비교 대상과 동일
    return .equal
}

// MARK: - CUSTOM COMPONENTS
public final class BaseNaviController: UINavigationController {
    
}

public final class FuncTimer {
    public static let shared = FuncTimer()
    private var timer = Timer()
    
    private init() {
        
    }
    
    public func startTimer(_ interval: Double, repeats: Bool = false, completion: @escaping (_ isStop: Bool) -> ()) {
        let nowDate = Date()
        
        // 타이머 시작전 다른 타이머가 동작 중이면 중지
        if self.timer.isValid {
            self.timer.invalidate()
        }
        
        self.timer = .scheduledTimer(withTimeInterval: interval,
                                     repeats: repeats,
                                     block: { [weak self] timer in
            guard let weakSelf = self else {return}
            let firstTime = Date().timeIntervalSince(nowDate)
            let secondTime = Int(interval - firstTime)
            
            if secondTime == 0 {
                // 정지는 되었겠지만 그래도 혹시 몰라서
                weakSelf.timer.invalidate()
                print("TIMER_END")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    public func stopTimer(completion: (Bool) -> ()) {
        // 중간에 타이머를 정지시키기 위해서 사용x
        if self.timer.isValid {
            self.timer.invalidate()
            completion(true)
        } else {
            completion(false)
        }
    }
    
}

public class UICustomLabel: UILabel {
    private var padding: UIEdgeInsets = UIEdgeInsets()
    
    public func setPadding(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        padding.top = top
        padding.bottom = bottom
        padding.left = left
        padding.right = right
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}

public final class UICustomButton: UIButton {
    @IBInspectable var animateBig: Bool = false
    @IBInspectable var animateSmall: Bool = false
    
    private enum BtnSize {
        typealias Element = (
            duration: TimeInterval,
            delay: TimeInterval,
            options: UIView.AnimationOptions,
            scale: CGAffineTransform,
            alpha: CGFloat
        )
        
        case sizeUPTouchDown
        case sizeDownTouchDown
        case touchUp
        
        var element: Element {
            switch self {
            case .sizeUPTouchDown:
                return Element(duration: 0,
                               delay: 0,
                               options: .curveLinear,
                               scale: .init(scaleX: 1.1, y: 1.1),
                               alpha: 0.8)
                
            case .sizeDownTouchDown:
                return Element(duration: 0,
                               delay: 0,
                               options: .curveLinear,
                               scale: .init(scaleX: 0.9, y: 0.9),
                               alpha: 0.8)
            case .touchUp:
                return Element(duration: 0,
                               delay: 0,
                               options: .curveLinear,
                               scale: .identity,
                               alpha: 1)
            }
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            if animateBig {
                let animation: BtnSize = BtnSize.sizeUPTouchDown
                self.doAnimating(animation: animation)
            } else if animateSmall {
                let animation: BtnSize = BtnSize.sizeDownTouchDown
                self.doAnimating(animation: animation)
            }
        }
    }
    
    private func doAnimating(animation: BtnSize) {
        let animationElement = self.isHighlighted ? animation.element : BtnSize.touchUp.element
        UIView.animate(withDuration: animationElement.duration,
                       delay: animationElement.delay,
                       options: animationElement.options) {
            self.transform = animationElement.scale
            self.alpha = animationElement.alpha
        }
    }
}

public class UICustomView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
    }
    
    private func loadNib () {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        guard let nibView = nibs?.first as? UIView else { return }
        self.addSubview(nibView)
        self.viewLoad()
    }
    
    func viewLoad(){
        
    }
}



// MARK: - EXTENSION
extension SceneDelegate {
    func setNavigationController(_ scene: UIScene, firstVC: UIViewController) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        naviController.viewControllers = [firstVC]
        naviController.navigationBar.isHidden = true
        naviController.interactivePopGestureRecognizer?.isEnabled = false
        window?.windowScene = windowScene
        window?.rootViewController = naviController
        window?.makeKeyAndVisible()
    }
}

extension UIViewController {
    func popVC(popAnimate: Bool = false, completion: (() -> ())? = nil) {
        naviController.popViewController(animated: popAnimate)
    }
    
    func pushVC(nextVC: UIViewController, pushAnimate: Bool = false, completion: (() -> ())? = nil) {
        naviController.pushViewController(nextVC, animated: pushAnimate)
    }
    
    func popAndPushVC(nextVC: UIViewController, popAnimate: Bool = false, pushAnimate: Bool = false) {
        printLog("popAndPushVC : \(nextVC)")
        popVC(popAnimate: popAnimate)
        pushVC(nextVC: nextVC, pushAnimate: pushAnimate)
    }
    
    func printNaviVC() {
        printLog(naviController.viewControllers)
    }
    
    /// presentVC()
    ///
    /// Present 에서는 dismiss로 날려 버리는 겁니다~
    func presentVC(fromVC: UIViewController, nextVC: UIViewController, modalStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical, presentAnimate: Bool, completion: (() -> ())? = nil){
        nextVC.modalPresentationStyle = modalStyle
        nextVC.modalTransitionStyle = transitionStyle
        fromVC.present(nextVC, animated: presentAnimate,completion: completion)
    }
    
    
}

extension UILabel {
    
}

extension UIView {
    /// override, required 선언한 init 두 부분에서 이거 선언해주면 됨
    //    func loadNib() {
    //        let identifier = String(describing: type(of: self))
    //        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
    //        guard let nibView = nibs?.first as? UIView else { return }
    //        nibView.frame = self.bounds
    //        self.addSubview(nibView)
    //    }
    
    //    func makeToast(message: String) -> UILabel {
    //
    //    }
    enum simpleType{
        case top
        case down
    }
    
    private func makeToast(message: String) -> UICustomLabel {
        let label: UICustomLabel = {
            let label = UICustomLabel()
            
            label.backgroundColor = .black.withAlphaComponent(0.5)
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 20.0)
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0
            label.textAlignment = .center
            label.alpha = 1.0
            label.text = message
            label.layer.cornerRadius = label.font.pointSize / 2
            label.clipsToBounds = true
            return label
        }()
        label.setPadding(top: 5, bottom: 10, left: 5, right: 10)
//        label.setPadding(top: 5, left: 10, bottom: 5, right: 10)
        
        return label
    }
    
    
    func showToast(message: String, type: simpleType = .down, constatns: CGFloat = 100, duration: CGFloat = 2.0, delay:CGFloat = 0.4 ,isRepeat: Bool = false) {
        var isUILabel: Bool = false
        
        if isRepeat {
            self.subviews.forEach {
                if $0 is UICustomLabel {
                    isUILabel = true
                }
            }
        }
        
        if !isUILabel {
            let toast: UICustomLabel = makeToast(message: message)
            self.addToast(toast)
            
            switch type{
            case .down:
                self.simpleDownToast(toast: toast,constant: constatns,duration: duration,delay: delay)
            case .top:
                self.simpleTopToast(toast: toast,constant: constatns,duration: duration,delay: delay)
            }
            //            self.willRemoveSubview(toast)
        }
    }
    
    // completion == 타이머가 있어야 동작함
    func showIndicator(_ time: Double = 5, isTimer: Bool = false, removeBack: Bool = false,completion: ((Bool) -> ())? = nil) {
        let indicator: UIActivityIndicatorView = makeIndicatorToast()
        
        if removeBack {
            indicator.color = .lightGray
            indicator.backgroundColor = UIColor.clear
        }
        
        self.isUserInteractionEnabled = false
        self.subviews.forEach {
            if $0 is UIActivityIndicatorView {
                $0.removeFromSuperview()
            }
        }
        self.addToast(indicator)
        indicator.startAnimating()
        
        self.indicatorToast(toast: indicator)
        
        if isTimer {
            FuncTimer.shared.startTimer(time) { isStop in
                if isStop {
                    self.stopIndicator { isDone in
                        completion?(isDone)
                    }
                }
            }
        }
    }
    
    func stopIndicator(completion: ((Bool)->())? = nil) {
        var completionType: Bool = false
        self.isUserInteractionEnabled = true
        self.subviews.forEach {
            if $0 is UIActivityIndicatorView {
                $0.removeFromSuperview()
                completionType = true
            }
        }
        completion?(completionType)
        
    }
    
    private func addToast<T>(_ toast: T) {
        guard let toast = toast as? UIView else { return }
        self.addSubview(toast)
    }
    
    //MARK: - Simple Toast Animation
    private func simpleDownToast(toast: UICustomLabel, constant: CGFloat, duration:CGFloat, delay:CGFloat) {
        toast.translatesAutoresizingMaskIntoConstraints = false
        [
            NSLayoutConstraint.init(item: toast,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0),
            
            NSLayoutConstraint.init(item: toast,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .bottom,
                                    multiplier: 1,
                                    constant: constant * -1),
            
            NSLayoutConstraint.init(item: toast,
                                    attribute: .leading,
                                    relatedBy: .greaterThanOrEqual,
                                    toItem: toast.superview,
                                    attribute: .leading,
                                    multiplier: 1,
                                    constant: 30)
        ].forEach{$0.isActive = true}
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseOut,
                       animations: {
            toast.alpha = 0.0
        },
                       completion: { _ in
            toast.removeFromSuperview()
            
        })
        
    }
    
    private func simpleTopToast(toast: UICustomLabel, constant: CGFloat, duration:CGFloat, delay:CGFloat) {
        toast.translatesAutoresizingMaskIntoConstraints = false
        [
            NSLayoutConstraint.init(item: toast,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0),
            
            NSLayoutConstraint.init(item: toast,
                                    attribute: .top,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: constant),
            
            NSLayoutConstraint.init(item: toast,
                                    attribute: .leading,
                                    relatedBy: .greaterThanOrEqual,
                                    toItem: toast.superview,
                                    attribute: .leading,
                                    multiplier: 1,
                                    constant: 30)
        ].forEach{$0.isActive = true}
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseOut,
                       animations: {
            toast.alpha = 0.0
        },
                       completion: { _ in
            toast.removeFromSuperview()
        })
        
    }
    
    //MARK: - Toast Indicator
    private func indicatorToast(toast: UIActivityIndicatorView) {
        toast.translatesAutoresizingMaskIntoConstraints = false
        [
            NSLayoutConstraint.init(item: toast,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0),
            
            NSLayoutConstraint.init(item: toast,
                                    attribute: .centerY,
                                    relatedBy: .equal,
                                    toItem: toast.superview,
                                    attribute: .centerY,
                                    multiplier: 1,
                                    constant: 0),
            
            toast.widthAnchor.constraint(equalToConstant: 100),
            toast.heightAnchor.constraint(equalToConstant: 100)
        ].forEach{$0.isActive = true}
        
    }
    
    private func makeIndicatorToast() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView()
            indicator.backgroundColor = .black.withAlphaComponent(0.5)
            indicator.style = .large
            indicator.color = .white
            indicator.alpha = 1.0
            indicator.layer.cornerRadius = 15
            indicator.isHidden = false
            return indicator
        }()
        return indicator
    }
}


extension UIColor {
    // RGB CODE: E65344
    class var brandColor: UIColor? { return UIColor(named: "BrandColor")}
    class var backColor: UIColor? { return UIColor(named: "BackColor")}
    class var accentColor: UIColor? { return UIColor(named: "AccentColor")}
    class var greenColor: UIColor? { return UIColor(named: "GreenColor")}
    class var separateColor: UIColor? { return UIColor(named: "SeparateColor")}
    class var viewBackColor: UIColor? { return UIColor(named: "ViewBackColor")}
    
}

extension String {
    /// 마지막 경로 구성 요소
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    /// 원하는 길이 만큼 절단
    func cut(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex,offsetBy: start >= 0 ? start : 0)
        let endIndex = self.index(self.startIndex,offsetBy: end >= 0 ? end : 0)
        let result: String = "\(self[startIndex ..< endIndex])"
        return result
    }
    
    /// 글자 하나 단위로 구분
    func letter() -> [String] {
        return self.map { String($0) }
    }
    
    /// 단어 하나 단위로 구문 (띄어쓰기)
    func word() -> [String] {
        return self.components(separatedBy: " ")
    }
    
    /// Date() 로 변환 -> (Bool, Date) 출력
    func convertDate(_ dateFormat: String = "yyyyMMdd") -> (Bool, Date) {
        let dateFormatter = Date().setDateFormatter(dateFormat)
        if let convert = dateFormatter.date(from: self) {
            return (true, convert)
        } else {
            return (false, Date())
        }
    }
    
    /// 정규식 체크
    ///
    /// 이메일 정규식 예시: "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._%+-]+\\.[A-Za-z]{2,64}"
    /// 비밀번호 정규식 에시: "[A-Z0-9a-z._%+-]{6,12}"
//    let emailFilterForm = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z._%+-]+\\.[A-Za-z]{2,64}"
//    let passwordFilterForm = "[A-Z0-9a-z._%+-]{6,12}"
    func checkFilter(_ filter: String) -> Bool {
        var result = false
        if self == "" { return result }
        if (self.range(of: filter, options: .regularExpression) != nil) {
            result = true
        } else {
            result = false
        }
        
        return result
    }
    
    /// Bool 값에 맞게  DateFormat을 반환
    static func makeDateFormat(year: Bool, month: Bool, day: Bool, dayOfWeek: Bool = false, am_pm: Bool = false, hour: Bool = false,_ fullTime: Bool = true, minute: Bool = false, second: Bool = false, mSecond: Bool = false, mSDigit: Int = 1) -> String {
        
        var dateFormat = ""
        
        if year {
            dateFormat = dateFormat + "yyyy"
        }
        if month {
            dateFormat = dateFormat + "MM"
        }
        if day {
            dateFormat = dateFormat + "dd"
        }
        if dayOfWeek {
            dateFormat = dateFormat + "EEEEEE"
        }
        
        if am_pm {
            dateFormat = dateFormat + "a"
        }
        
        if fullTime { // 24시간
            if hour {
                dateFormat = dateFormat + "HH"
            }
        } else { // 12시간
            if hour {
                dateFormat = dateFormat + "hh"
            }
        }
        
        if minute {
            dateFormat = dateFormat + "mm"
        }
        
        if second {
            dateFormat = dateFormat + "ss"
        }
        
        if mSecond {
            for _ in 0 ..< mSDigit {
                dateFormat = dateFormat + "S"
            }
        }
        
        return dateFormat
    }
    
    /// 날짜를 합쳐서 하나의 String으로 반환
    static func combineDate(year: Int, month: Int, day: Int) -> String {
        return "\(year * 10000 + month * 100 + day)"
    }
    
    /// "00000000" 으로 들어온 값을 "["0000","00","00"]" 으로 변환
    func separateDate() -> [String] {
        let letter = self.letter()
        return ["\(letter[0])\(letter[1])\(letter[2])\(letter[3])","\(letter[4])\(letter[5])","\(letter[6])\(letter[7])"]
    }
    
    /// "0000" 으로 들어온 값을 ["00","00"] 으로 변환
    func separateTime() -> [String] {
        let letter = self.letter()
        return ["\(letter[0])\(letter[1])","\(letter[2])\(letter[3])"]
    }
    
    func stringToInt() -> Int {
        if let intValue = Int(self) {
            return intValue
        } else {
            return 0
        }
    }
    
}

extension Date {
    /// 연도 표시
    ///
    /// 변환에 실패시 현재 날짜의 년 표시
    var year: Int {
        let dateFormatter = self.setDateFormatter("yyyy")
        if let year = Int(dateFormatter.string(from: self)){
            return year
        } else {
            return Calendar.current.component(.year, from: self)
        }
    }
    
    /// 월 표시
    ///
    /// 변환 실패시 현재 날짜의 월 표시
    var month: Int {
        let dateFormatter = self.setDateFormatter("MM")
        if let month = Int(dateFormatter.string(from: self)) {
            return month
        } else {
            return Calendar.current.component(.month, from: self)
        }
    }
    
    /// 일 표시
    ///
    /// 변환 실패시 현재 날짜의 월 표시
    var day: Int {
        let dateFormatter = self.setDateFormatter("dd")
        if let day = Int(dateFormatter.string(from: self)) {
            return day
        } else {
            return Calendar.current.component(.day, from: self)
        }
    }
    
    /// 요일 표시
    ///
    /// 일요일 부터 시작해 0~6까지 반환
    ///
    /// -1 반환시 오류 발생
    var dayOfWeek: Int {
        let dateFormatter = self.setDateFormatter("EEEEEE")
        let convert = dateFormatter.string(from: self)
        switch convert {
        case "일":
            return 0
        case "월":
            return 1
        case "화":
            return 2
        case "수":
            return 3
        case "목":
            return 4
        case "금":
            return 5
        case "토":
            return 6
        default:
            return -1
        }
    }
    
    /// 시간 표시
    ///
    /// 24시간제로 표기
    var hour: Int {
        return self.setDateFormatter("HH").string(from: self).stringToInt()
    }
    
    /// 분 표시
    var minute: Int {
        return self.setDateFormatter("mm").string(from: self).stringToInt()
    }
    
    func setDateFormatter(_ dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = Locale(identifier: "ko_kr")
        return dateFormatter
    }
    
    /// String 값으로 변환
    func convertString(_ dateFormat: String = "yyyyMMdd") -> String {
        let dateFormatter = self.setDateFormatter(dateFormat)
        return dateFormatter.string(from: self)
    }
    
    
    /// 해당 년도가 윤년인지 확인
    ///
    /// 값이 정확하지 않으면 현재 날짜로 파악
    func checkLeapMonth() -> Bool {
        if self.year % 4 == 0 {
            if self.year % 100 == 0 {
                if self.year % 400 == 0 {
                    return true
                }
            } else {
                return true
            }
        }
        return false
    }
    
    /// 해당 월의 날짜 수 확인
    ///
    /// 값이 정확하지 않으면 현재 날짜로 파악
    func getLastDayOfMonth() -> Int {
        switch self.month {
        case 1,3,5,7,8,10,12 :
            return 31
        case 2:
            if self.checkLeapMonth() {
                return 29
            } else {
                return 28
            }
        case 4,6,9,11:
            return 30
        default:
            return -1
        }
    }
    
    ///10분단위 올림
    func setTenMinDate() -> Date {
        var intSet = (self.hour, self.minute)
        var strSet = ("","")
        if intSet.1 % 10 != 0 {
//            let upMin = ((intSet.1 / 10) + 1) * 10
            if ((intSet.1 / 10) + 1) * 10 >= 60 {
                intSet.0 += 1
                intSet.1 = 0
            }
            else { intSet.1 = ((intSet.1 / 10) + 1) * 10 }
        }
        
        if intSet.0 < 10 { strSet.0 = "0\(intSet.0)" } else { strSet.0 = "\(intSet.0)" }
        if intSet.1 < 10 { strSet.1 = "0\(intSet.1)" } else { strSet.1 = "\(intSet.1)" }
        
        return "\(strSet.0)\(strSet.1)".convertDate("HHmm").1
        
    }
}



// MARK: - ANNOTATION

/// 사용방법
/// @UserDefault (key: "keyName", defaultValue: "default") var 변수
/// print(변수)
///  - 위에처럼 하게 되면 UserDefaults에 저장된 key 값을 갖고있는걸 보여주든가 기본 값 보여줌
/// 변수 = 변경값
///  - 위에처럼 하게되면 UserDefaults에 해당 key 값에 변경값을 저장하고 들고 있음
@propertyWrapper
struct UserDefault<T> {
    private let ud: UserDefaults = .standard
    private let key: String
    private var defaultValue: T
    
    var wrappedValue: T {
        set { ud.set(newValue, forKey: key) }
        get { ud.object(forKey: key) as? T ?? defaultValue }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    ///사용법: _변수.removeData()
    /// - 중요사항 변수 앞에 _ 무조건 붙여야 함
    func removeData() {
        ud.removeObject(forKey: key)
    }
}


