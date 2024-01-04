//
//  NotificationViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/18/23.
//

import UIKit

class NotificationViewController: BaseVC {
    private var notiCount = 5
    private var cellIdentifier = ""
    private var notiPermission = true
    
    
    private let NotificationTableViewCellNib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
    private let emptyTableViewCellNib = UINib(nibName: "EmptyTableViewCell", bundle: nil)
    
    

    @IBOutlet weak var separateView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notiPermissionBtn: UICustomButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.separateView.layer.cornerRadius = 2.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        self.tableView.register(self.NotificationTableViewCellNib,
                                forCellReuseIdentifier: "NotificationTableViewCell")
        self.tableView.register(self.emptyTableViewCellNib,
                                forCellReuseIdentifier: "EmptyTableViewCell")
        
        self.updateTableViewSetting()
    }


    @IBAction func tapNotiPermissionBtn(_ sender: UICustomButton) {
        
    }
    
    @IBAction func tapCloseBtn(_ sender: UICustomButton) {
        self.dismiss(animated: true)
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(self.cellIdentifier)",
                                                 for: indexPath)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.notiCount == 0 {
            return 1
        }
        else {
            return self.notiCount
        }
    }
    
    func checkTableCell() -> String {
        if self.notiCount == 0 { return "EmptyTableViewCell" }
        else { return "NotificationTableViewCell" }
    }
    
    func updateTableViewSetting() {
        // 줄 지우기
        self.tableView.separatorStyle = .none
        self.cellIdentifier = self.checkTableCell()
        if self.notiCount == 0 {
            self.tableView.isScrollEnabled = false
        }
        else {
            self.tableView.isScrollEnabled = true
        }
    }
    
}

extension NotificationViewController: DatabaseDelegate {
    
}


//@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
//#Preview(traits: .portrait, body: {
//    NotificationViewController()
//})
