//
//  MainViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/26/23.
//

import UIKit
import SnapKit


class MainViewController: BaseVC {
    weak var coordinator: MainCoordinator?
    var userData: UserData = .init(id: "", name: "", birth: "", isSwitch: "",pushToken: "", tableId: "")

    // 정상 체크, 오류 체크
    private var dataCheckCount = (0, 0)

    private var listDateArray = [String]()
    private var getFriendList = [String]()
//    internal lazy var topView 
    

//    internal lazy var scrollView: UIScrollView = {
//        let scroll = UIScrollView()
//
//        return scroll
//    }()
//    
//    internal lazy var myInfoView: MyInfoView = {
//        let view = MyInfoView()
//        return view
//    }()
//    
//    internal lazy var todayPlaView: TodayPlanView = {
//        let view = TodayPlanView()
//        return view
//    }()
//    
//    internal lazy var reserveListView: ReserveListView = {
//        let view = ReserveListView()
//        return view
//    }()
//
//    internal lazy var friendsListView: FriendsListView = {
//        let view = FriendsListView()
//        return view
//    }()
    
    private lazy var firstSeparateView = makeSeparateView()
    private lazy var secondSeparateView = makeSeparateView()
    private lazy var thirdSeparateView = makeSeparateView()
    
    
// MARK: - END CREATE UI
    deinit {
        printFunc()
        self.coordinator?.popVC()
    }
    
    override func moveToVC(type: VCType) {
        if type == .calendar {
            self.coordinator?.choiceVC(.calendar, isPop: T)
        }
        else if type == .map {
            
        }
        else if type == .history {
            
        }
        else if type == .mypage {
            
        }
    }
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        printFunc()
    //        self.setLayout()
    //    }
        
    
    private func setLayout() {
        [
            self.scrollView
        ].forEach { self.view.addSubview($0) }
    }


    
    //MARK: - 아래는 전 꺼..
    
    
    
    @IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var topView: TopView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myInfoView: MyInfoView!
    @IBOutlet weak var todayPlanView: TodayPlanView!
    @IBOutlet weak var reservationListView: ReservationListView!
    @IBOutlet weak var friendsListView: FriendsListView!
    
    @IBOutlet weak var mtSeparateView: UIView!
    @IBOutlet weak var trSeparateView: UIView!
    @IBOutlet weak var rfSeparateView: UIView!
    
    // 이거 BaseView 로 하면 에러 터지니까 이 부분 바꾸지 마세용~
    private lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backColor
        return view
    }()
        ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate 설정
        self.scrollView.delegate = self
        self.topView.delegate    = self
        self.bottomView.delegate = self
        
        self.reservationListView.delegate = self
        self.todayPlanView.delegate = self
        self.friendsListView.delegate = self
        
        // Top에 뜨는 뷰 설정
        self.topView.changeBtnHidden(isTitleHidden: F, is1stHidden: F, is2ndHidden: F, is3rdHidden: F)
        self.topView.toggleCircleHidden()
        
        self.checkUserData()
        // 나를 추가한 친구 목록 읽어오기 -> 비동기 처리
//        self.checkGetFriend()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 유저데이터를 받아오면서 VC 자체에 큰 Indicator show 해줌
        self.toggleIndicator(T)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 동작
        
    }
    
    
    private func setRadiusSeparate() {
        self.mtSeparateView.layer.cornerRadius = 2.0
        self.trSeparateView.layer.cornerRadius = 2.0
        self.rfSeparateView.layer.cornerRadius = 2.0
    }
    
    
    private func toggleIndicator(_ isOn: Bool) {
        if isOn {
            self.view.addSubview(self.blackView)
            self.blackView.snp.updateConstraints {
                $0.edges.equalToSuperview()
            }
            self.blackView.showIndicator()
        }
        else {
            self.blackView.stopIndicator()
            self.blackView.isHidden = true
        }
    }
    
    
    
    
    /// user 를 read 함
    private func checkUserData() {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        @UserDefault(key: "tableId", defaultValue: "") var tableId
        
        DatabaseManager().readDataBase(.user, key: loginId) { dataBase in
            if let db = dataBase as? DB_SUCCESS {
                printLog("여긴가?")
                var userData: UserData = .init(id: "", name: "", birth: "", isSwitch: "", pushToken: "", tableId: "")
                if let data = db.value {
                    userData.id           = optStr(data["id"])
                    userData.name         = optStr(data["name"])
                    userData.birth        = optStr(data["birth"])
                    userData.isSwitch     = optStr(data["switch"])
                    userData.pushToken    = optStr(data["pushToken"])
                    userData.tableId      = optStr(data["tableId"])
                    userData.email        = optStr(data["email"]) != "" ? optStr(data["email"]) : nil
                    userData.state        = optStr(data["state"]) != "" ? optStr(data["state"]) : nil
                    
                    tableId = "\(userData.tableId)"
                    
                    self.userData = userData
                    printLog(self.userData)
                    // 상태 탑 바에서 알람 설정 위치 수정 -> 비동기 처리 아님
                    self.toggleReserveStateBtn(isSwitch: self.userData.isSwitch)
                    self.myInfoView.changeView(self.userData.name, self.userData.state)
                }
                else {
                    let nextVC = CommonAlertViewController(nibName: "CommonAlertViewController", bundle: nil)
                    
                    let contentView: InputUserInfoView = {
                        let view = InputUserInfoView()
//                        view.initData(self.userData.tableId, getFriendLsit: self.getFriendList)
                        return view
                    }()
                    
                    nextVC.setUpAlertVC(contentView, animate: false, type: .center, isKeyBoard: true)
                    self.pushVC(nextVC: nextVC)
    
                    // 여긴 아이디는 있는데 정보가 없는거임 즉 정보를 입력해주는 창을 열어줘야 함
                }

            } else if let db = dataBase as? DB_FAILURE {
                // 비정상
                self.dataCheckCount.0 -= 1
            }
            
            self.dataCheckCount.0 += 1
            self.addLoadCount()
        }
        
    }
    
    // 이거 왜 안해놨지;?????
//    private func checkReservationSend() {
//        @UserDefault(key: "loginId", defaultValue: "") var loginId
//        self.dbManager.readData(.reserveSend, key: "\(loginId)")
//    }
    
    private func checkGetFriend() {
        self.getFriendList = []

        ConnectData().connectGetFriend  { data in
            if !data.isEmpty {
                if data[0] == DB_EMPTY_ARRAY_KEY {
                    self.topView.toggleCircleHidden(is2ndHidden: T)
                }
                else {
                    self.getFriendList = data
                    self.topView.toggleCircleHidden(is2ndHidden: F)
                }
            }
            else {
//                self.dataCheckCount.1 -= 1
            }
            self.addLoadCount()
        }
    }
    
    
    private func toggleReserveStateBtn(isSwitch: String) {
        if isSwitch == "Y" {
            self.topView.secondBtn.setImage(.init(systemName: "circle.inset.filled"), for: .normal)
            self.topView.secondBtn.tintColor = UIColor.greenColor
        }
        else if isSwitch == "N" {
            self.topView.secondBtn.setImage(.init(systemName: "xmark.circle"), for: .normal)
            self.topView.secondBtn.tintColor = .lightGray
        }
    }
    
    // MainViewController에서 데이터 전부다 불러올 경우를 처리하는 부분
    private func addLoadCount() {
        self.dataCheckCount.1 += 1
        if self.dataCheckCount.1 == 4 {
            if self.dataCheckCount.0 == 4 {
                self.toggleIndicator(F)
            }
            else {
                makeAlert(self,
                          title: "안내",
                          message: "오류가 발생하였습니다.\n다시 시도하시겠습니까?",
                          actionTitle: ["다시 시도", "종료"],
                          style: [.default, .destructive],
                          handler: [
                            // 다시 userData부르는 동작
                            {_ in
                                self.checkUserData()
                                return
                            },
                            {_ in exit(1)}
                          ])
            }
        }
        
    }
    
    // MARK: - TAP_TOP VIEW
    
    // TITLE_BTN
    override func tapFirstBtn() {
        
        // 이건 원래 동작하는 기능
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        DatabaseManager().updateDataBase(.test, key: "TEST", data: ["aa":""]) { _ in
//        }
        self.reloadVC()
        // Test 코드
//        printLog("\(self.userData)")
//        printLog(Date().setTenMinDate())
//        let messageId = self.dbManager.makeMessageId("1700", "1900")
//        self.dbManager.createData(.reserveMessage, key: "\(messageId)", data: [
//            "friendId": "23039923",
//            "state": "N",
//            "title": "명동 어때?",
//            "date": "20231227",
//            "startTime": "1700",
//            "endTime": "1900",
//            "alarm" : "Y",
//            "location": "명동역 1번 출구",
//            "etc": ""
//        ])
    }
    
    // CEHCK_RESERVE_STATE
    override func tapSecondBtn() {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        if self.userData.isSwitch == "Y" {
            self.userData.isSwitch = "N"
            DatabaseManager().updateDataBase(.user, key: "\(loginId)/switch", data: "N") { _ in }
        }
        else if self.userData.isSwitch == "N" {
            self.userData.isSwitch = "Y"
            DatabaseManager().updateDataBase(.user, key: "\(loginId)/switch", data: "Y") { _ in }
        }
        
        self.toggleReserveStateBtn(isSwitch: self.userData.isSwitch)
    }
    
    // ADD_FRIEND_BTN
    override internal func tapThirdBtn() {
        let nextVC = CommonAlertViewController(nibName: "CommonAlertViewController", bundle: nil)
        
        let contentView: AddFriendView = {
            let view = AddFriendView()
            view.initData(self.userData.tableId, getFriendLsit: self.getFriendList)
            return view
        }()
        
        contentView.getFriendView.delegate = self
        contentView.delegate = self
        
        nextVC.setUpAlertVC(contentView, animate: false, type: .center, isKeyBoard: true)
        pushVC(nextVC: nextVC)
    }
    
    // CHECK_NOTI_BTN
    override internal func tapForthBtn() {
        let nextVC = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        presentVC(fromVC: self, nextVC: nextVC,
                  modalStyle: .automatic,
                  presentAnimate: true, completion: nil)

    }
    
}

extension MainViewController: BaseVCDelegate {
    func reloadVC() {
        self.todayPlanView.reloadView()
        self.reservationListView.reloadView()
        self.friendsListView.reloadView()
    }
    
    func sendVCData(identifier: String, data: Any) {
        let loadView = { (data: String) in
            if data == "Load" {
                self.dataCheckCount.0 += 1
                self.addLoadCount()
            }
            else if data == "ERROR" {
                self.dataCheckCount.0 -= 1
                self.addLoadCount()
            }
        }
        
        if identifier == TodayPlanView.identifier {
            if let data = data as? String {
                loadView(data)
            }
        }
        else if identifier == ReservationListView.identifier {
            if let data = data as? String {
                loadView(data)
            }
            else if let data = data as? [String: String] {
                printLog(data)
                printLog(data["messageId"])
                printLog(data["date"])
                guard let date = data["date"] else { return }
                guard let messageId = data["messageId"] else { return }
                @UserDefault(key: "loginId", defaultValue: "") var loginId
                makeAlert(self,
                          title: "예약 확인", message: "예약을 받아주시겠습니까?",
                          actionTitle: ["수락", "거절", "취소"],
                          style: [.cancel,.destructive,.default],
                          handler: [
                            {_ in
                                // 수락 한거니까
                                // reserveMessage에서 상태 수락으로 변경
                                // reserveList(예약 확정 정보)에 추가
                                // reserveGet에서 삭제 => list 다시 한 번 초기화 해야 함
                                DatabaseManager().updateDataBase(.reserveMessage, key: "\(messageId)/state", data: "Y") { dataBase in
                                    if dataBase is DB_SUCCESS {}
                                    else if dataBase is DB_FAILURE {}
                                }
                                DatabaseManager().updateDataBase(.reserveList, key: "\(loginId)/\(date)/\(messageId)", data: "") { dataBase in
                                    if dataBase is DB_SUCCESS {}
                                    else if dataBase is DB_FAILURE {}
                                }
                                DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(messageId)") { dataBase in
                                    if dataBase is DB_SUCCESS {
//                                        self.delegate?.doCellSomething()
                                        // list View 초기화를 해야함
                                    }
                                    else if dataBase is DB_FAILURE {
                                        
                                    }
                                }
                            },
                            {_ in
                                // 거절한거임
                                // reserveMessage 의 상태 변경
                                // reserveGet 에서 삭제
                                DatabaseManager().updateDataBase(.reserveMessage, key: "\(messageId)/state", data: "N") { dataBase in
                                    if dataBase is DB_SUCCESS {
                                        
                                    }
                                    else if dataBase is DB_FAILURE {
                                        
                                    }
                                }
                                DatabaseManager().deleteDataBase(.reserveGet, key: "\(loginId)/\(messageId)") { dataBase in
                                    if dataBase is DB_SUCCESS {
//                                        self.delegate?.doCellSomething()
                                        // list View 초기화를 해야함
                                    }
                                    else if dataBase is DB_FAILURE {
                                        
                                    }
                                }
                                // 후에 이 작업을 하게 되면 상대방도 거절한게 떠야 하니까 상대방 로드시에
                            },
                            {_ in}
                          ])
            }
        }
        else if identifier == FriendsListView.identifier {
            if let data = data as? String {
                loadView(data)
            }
            else if let data = data as? FriendPopUpViewController {
                self.presentVC(fromVC: self, nextVC: data, presentAnimate: T)
            }
        }
        
    }
}

extension MainViewController: UIScrollViewDelegate {}

