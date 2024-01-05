//
//  MainViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/26/23.
//

import UIKit


class MainViewController: BaseVC {
//    private let dbManager: DatabaseManager = DatabaseManager()
    
    var userData: UserData = .init(id: "", name: "", birth: "", isSwitch: "",pushToken: "", tableId: "")
    
    private var dataCheckCount = (0, 0)
    private var listDateArray = [String]()
    private var getFriendList = [String]()
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate 설정
        self.scrollView.delegate = self
        self.topView.delegate    = self
        self.bottomView.delegate = self
        self.reservationListView.delegate = self
        
        // Top에 뜨는 뷰 설정
        self.topView.changeBtnHidden(isTitleHidden: F, is1stHidden: F, is2ndHidden: F, is3rdHidden: F)
        self.topView.toggleCircleHidden()
        
        self.startCheckData()
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
    
    private func startCheckData() {
        self.dataCheckCount = (0, 5)
        // 유저 정보 읽어오기 -> 비동기 처리
        self.checkUserData()
        
        // 오늘의 일정 데이터 읽어오기 -> 비동기 처리
        self.checkTodayPlan()
        
        // 예약 리스트 데이터 읽어오기 -> 비동기 처리
        self.checkReservationList()
        
        // 친구 목록 읽어오기 -> 비동기 처리
        self.checkFriendsList()
        
        // 나를 추가한 친구 목록 읽어오기 -> 비동기 처리
        self.checkGetFriend()
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
                self.dataCheckCount.1 -= 1
            }
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
                self.dataCheckCount.1 -= 1
            }
            self.addLoadCount()
        }
    }
    
    // TodayPlanView 에서 데이터 받아가는 부분
    private func checkTodayPlan() {
        ConnectData().connectReserveList { data in
            if !data.isEmpty {
                if data[0] == DB_EMPTY_ARRAY_KEY {
                    self.todayPlanView.setData(0)
                }
                else {
                    self.todayPlanView.setData(data.count,data: data)
                }
            }
            else {
                self.dataCheckCount.1 -= 1
            }
            self.addLoadCount()
        }
    }
    
    private func checkReservationList() {
        ConnectData().connectReserveGet { data in
            if !data.isEmpty {
                if data[0] == DB_EMPTY_ARRAY_KEY {
                    self.reservationListView.setData(0)
                }
                else {
                    self.reservationListView.setData(data.count, data: data)
                }
            }
            else {
                self.dataCheckCount.1 -= 1
            }
            self.addLoadCount()
        }
    }
    
    private func checkFriendsList() {
        var friendList = [String]()
        var friendCount = 0
        
        ConnectData().connectFriends { friendsData in
            if !friendsData.isEmpty {
                if friendsData[0] == DB_EMPTY_ARRAY_KEY {
                    self.friendsListView.setData(0)
                    self.addLoadCount()
                }
                else {
                    friendCount = friendsData.count
                    for i in 0 ..< friendCount {
                        ConnectData().connectTableId(key: friendsData[i]) { tableData in
                            // 없다? 탈퇴 한거임 그럼 friends에서 삭제를 해야겠네.
                            if tableData == "" {
                                DatabaseManager().deleteDataBase(.friends, key: friendsData[i]) { dataBase in
                                    if let db = dataBase as? DB_SUCCESS {
                                        // 삭제 된거임 > 정상 작동 시키면 됨
                                        friendCount -= 1
                                    }
                                    else if let db = dataBase as? DB_FAILURE {
                                        // 이거도 안된다고????? 그럼 문제가 있는거지...
                                        self.dataCheckCount.1 -= 1
                                    }

                                }
                            }
                            else {
                                friendList.append(tableData)
                                if friendList.count == friendCount {
                                    var cellDataList = [FriendData]()
                                    // 이 반복문에서는 아무 이상없이 에러 처리를 다 해줬음
                                    for i in 0 ..< friendList.count{
                                        ConnectData().connectUser(key: friendList[i]) { data in
                                            // 오류기 친구로 등록되있고 데이터도 있는데 값을 못받아오면 에러 > -= 1
                                            if data.name == "", data.birth == "", data.isSwitch == "", data.pushToken == "", data.tableId == "" {
                                                // faiure 부분
                                                self.dataCheckCount.1 -= 1
                                            }
                                            // 정상적으로 cell 데이터를 모으는 작업 > 다 모아지면 setData 해주고 addLoadCount() 해줌
                                            else {
                                                let friendData: FriendData = .init(id: friendList[i],
                                                                                   name: data.name,
                                                                                   isSwitch: data.isSwitch,
                                                                                   tableId: data.tableId,
                                                                                   state: data.state)
                                                cellDataList.append(friendData)
                                                if friendList.count == cellDataList.count {
                                                    self.friendsListView.setData(cellDataList.count,friendData: cellDataList)
                                                    self.addLoadCount()
                                                }
                                            }
                                        }
                                    }
                                    // 만약 이 반복문을 안 타게 되면? count가 0 인데 이리 들어올 일은 없음
                                }
                            }
                        }
                    }
                    // 다시 말하지만 count가 0인 경우에는 이 분기 안으로 들어 올 수 없음
                }
            }
            else {
                self.dataCheckCount.1 -= 1
                self.addLoadCount()
            }
            
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
        self.dataCheckCount.0 += 1
        
        if self.dataCheckCount.0 == 5 {
            if self.dataCheckCount.1 == 5 {
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
        
        // Test 코드
//        printLog("\(self.userData)")
        printLog(Date().setTenMinDate())
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
        self.checkGetFriend()
        self.checkFriendsList()
        self.checkReservationList()
        self.checkTodayPlan()
    }
}

extension MainViewController: UIScrollViewDelegate {}
