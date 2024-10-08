//
//  AppDIContainer.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import Foundation

final class AppDIContainer {
    func makeSafeAreaDIContainer() -> SafeAreaDIContainer {
        let dependencies = SafeAreaDIContainer.Dependencies(networking: Networking())
        return SafeAreaDIContainer(dependencies: dependencies)
    }
}
