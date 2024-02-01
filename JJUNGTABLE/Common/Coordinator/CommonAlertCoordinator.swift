//
//  CommonAlertCoordinator.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 2/1/24.
//

import UIKit

class CommonAlertCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    lazy var contentView: UIView = UIView()
    lazy var animate: Bool = T
    lazy var type: AlertType = .center
    lazy var layout: LayoutStruct? = nil
    lazy var isKeyBoard: Bool = T
    
    init(parentCoordinator: MainCoordinator?, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = CommonAlertViewController()
        vc.coordinator = self
        vc.setUpAlertVC(self.contentView, animate: self.animate, type: self.type,layout: self.layout ,isKeyBoard: self.isKeyBoard)
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func choiceVC(_ nextVC: VCType, isPop: Bool) {
        self.parentCoordinator?.choiceVC(nextVC, isPop: isPop)
    }
    
    func popVC() {
        self.parentCoordinator?.removeChildCoordinator(self)
    }
}
