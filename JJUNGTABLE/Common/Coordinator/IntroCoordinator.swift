//
//  IntroCoordinator.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/25/24.
//

import UIKit

class IntroCoordniator: Coordinator {
    weak var parentCoordinator: AppCordinator?
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(parentCoordinator: AppCordinator?, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = IntroViewController()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: false)
    }

    func popVC() {
        self.parentCoordinator?.removeChildCoordinator(self)
//        self.delegate?.end()
    }
    
    func choiceVC(_ nextVC: VCType, isPop: Bool) {
        self.parentCoordinator?.choiceVC(nextVC, isPop: isPop)
    }

}
