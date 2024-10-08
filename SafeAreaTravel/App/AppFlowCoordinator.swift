//
//  AppFlowCoordinator.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let locationDIContainer = appDIContainer.makeSafeAreaDIContainer()
        let flow = locationDIContainer.makeStartFlowCoordinator(navigationController: navigationController)

        flow.start()
    }
}
