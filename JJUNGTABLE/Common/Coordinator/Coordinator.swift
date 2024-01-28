//
//  Coordinator.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 1/25/24.
//

import UIKit

protocol Coordinator: AnyObject {
    
    
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
    func choiceVC(_ nextVC: VCType, isPop: Bool)
    func removeChildCoordinator(_ child: Coordinator)
}
extension Coordinator {
//    func choiceVC(_ nextVC: VCType, isPop: Bool) { }
    
    func removeChildCoordinator(_ child: Coordinator){
        for (index, coordinator) in self.childCoordinator.enumerated() {
            if coordinator === child {
                self.childCoordinator.remove(at: index)
                break
            }
        }
    }
}

class AppCordinator: Coordinator {
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.choiceVC(.intro, isPop: F)
    }
    
    func choiceVC(_ nextVC: VCType, isPop: Bool) {
        if isPop {
            self.navigationController.popViewController(animated: false)
            self.childCoordinator.removeLast()
        }
        
        switch nextVC {
        case .intro:
            let introCoordinator = IntroCoordniator(parentCoordinator: self,
                                                    navigationController: self.navigationController)
            self.startChildCoordinator(introCoordinator)
        case .login:
            let loginCoordinator = LoginCoordinator(parentCoordinator: self,
                                                    navigationController: self.navigationController)
            self.startChildCoordinator(loginCoordinator)
        case .main:
            let mainCoordinator = MainCoordinator(parentCoordinator: self,
                                                  navigationController: self.navigationController)
            self.startChildCoordinator(mainCoordinator)
        case .popUp:
            break
        }
        
    }
    
    
    private func startChildCoordinator(_ child: Coordinator) {
        self.childCoordinator.append(child)
        child.start()
    }
    
//    private func pushIntroVC() {
//        let introCoordinator = IntroCoordniator(parentCoordinator: self,
//                                                navigationController: self.navigationController)
////        introCoordinator.delegate = self
//        self.startChildCoordinator(introCoordinator)
////        childCoordinator.append(introCoordinator)
////        introCoordinator.start()
//    }
//    
//    func end() {
//        self.navigationController.popViewController(animated: false)
//        self.childCoordinator.removeLast()
//    }
    
    private func pushLoginVC() {
        let loginCoordinator = LoginCoordinator(parentCoordinator: self, navigationController: self.navigationController)
        self.startChildCoordinator(loginCoordinator)
    }
    
    private func pushMainVC() {
        
    }
}

