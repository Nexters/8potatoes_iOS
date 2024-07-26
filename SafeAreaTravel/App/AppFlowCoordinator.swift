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
        let safeAreaDIContainer = appDIContainer.makeSafeAreaDIContainer()
        let flow = safeAreaDIContainer.makeMainMapFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
