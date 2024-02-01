//
//  MainCoordinator.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/26/24.
//

import UIKit

class MainCoordinator: Coordinator {
    weak var parentCoordinator: AppCordinator?
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(parentCoordinator: AppCordinator?, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func choiceVC(_ nextVC: VCType, isPop: Bool) {
        self.parentCoordinator?.choiceVC(nextVC, isPop: isPop)
    }
    
    func popVC() {
        self.parentCoordinator?.removeChildCoordinator(self)
    }
    
    func startAlertChild(_ contentView: UIView, animate: Bool, type: AlertType,  layout: LayoutStruct? = nil, isKeyBoard: Bool = true) {
        let commonAlertCoordinator = CommonAlertCoordinator(parentCoordinator: self,
                                                            navigationController: self.navigationController)
        commonAlertCoordinator.contentView = contentView
        commonAlertCoordinator.animate = animate
        commonAlertCoordinator.type = type
        commonAlertCoordinator.layout = layout
        commonAlertCoordinator.isKeyBoard = isKeyBoard
        
        self.childCoordinator.append(commonAlertCoordinator)
        commonAlertCoordinator.start()
    }
}
