//
//  SearchLocationModel.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/29/24.
//

import Foundation

struct SearchLocationModel: Equatable {
    let frontLat: Double
    let frontLon: Double
    let name: String
    let fullAddressRoad: String
    let fullAddressNum: String
}
 
extension SearchLocationModel {
    /// 문자열에서 "-" 뒤에 "0"을 제거하는 메서드
    func cleanAddress(_ address: String) -> String {
        guard let range = address.range(of: "-0") else {
            return address
        }
        var cleanedAddress = address
        cleanedAddress.removeSubrange(range)
        return cleanedAddress
    }
    
    /// 처리된 문자열을 반환하는 메서드
    var cleanedFullAddressRoad: String {
        return cleanAddress(fullAddressRoad)
    }

    var cleanedFullAddressNum: String {
        return cleanAddress(fullAddressNum)
    }
    
    /// 변환된 모델 반환
    func cleaned() -> SearchLocationModel {
        return SearchLocationModel(frontLat: frontLat, frontLon: frontLon, name: name, fullAddressRoad: cleanedFullAddressRoad, fullAddressNum: cleanedFullAddressNum)
    }
    
    /// 주소 문자열에서 마지막 주소만 반환하는 함수
    func extractLastAddress(from address: String) -> String {
        let addressComponents = address.split(separator: ",").map { String($0) }
        return addressComponents.last ?? address
    }
    
    /// 마지막 주소만 반환하는 계산 프로퍼티
    var lastAddressRoad: String {
        return extractLastAddress(from: fullAddressRoad)
    }
    
    var lastAddressNum: String {
        return extractLastAddress(from: fullAddressNum)
    }
}
