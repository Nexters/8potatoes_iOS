//
//  CurrentLocationViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 8/6/24.
//

import UIKit
import CoreLocation

import NMapsMap
import ReactorKit

final class CurrentLocationViewController: BaseViewController {

    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let mapView = NMFMapView()
    private let marker = NMFMarker()
    
    // MARK: - UI
    private let bottomView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    private let locationNameLabel = UILabel().then {
        $0.text = "내 위치"
        $0.textColor = .bik100
        $0.font = .suit(.Bold, size: 18)
        $0.sizeToFit()
    }
    private let reloadLoctionBtn = UIButton().then {
        $0.setImage(UIImage(named: "reloadLocationBtn"), for: .normal)
        $0.backgroundColor = .clear
    }
    private let setLocationBtn = UIButton().then {
        $0.setTitle("이 위치로 설정하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .suit(.Bold, size: 16)
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .main100
    }
    
    // MARK: - LifeCycle
    init() {
        super.init(nibName: nil, bundle: nil)
        setupLocationManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    override func configure() {
        navigationItem.title = "지도에서 위치 설정"
        navigationItem.backButtonTitle = ""
        bindUI()
    }
    
    override func addView() {
        self.view.addSubview(mapView)
        [setLocationBtn, locationNameLabel].forEach {
            bottomView.addSubview($0)
        }
        [reloadLoctionBtn, bottomView].forEach {
            mapView.addSubview($0)
        }
    }
    
    override func layout() {
        mapView.pin
            .top(self.view.pin.safeArea.top)
            .horizontally()
            .bottom()
        
        bottomView.pin
            .bottom()
            .horizontally()
            .height(165)
        
        reloadLoctionBtn.pin
            .above(of: bottomView)
            .marginBottom(20)
            .width(48)
            .height(48)
            .right(20)
        
        locationNameLabel.pin
            .sizeToFit()
            .top(40)
            .left(20)
        
        setLocationBtn.pin
            .height(56)
            .horizontally(20)
            .bottom(28)
    }
    
    private func bindUI() {
        reloadLoctionBtn.rx.tap
            .bind { [weak self] in
                self?.requestCurrentLocation()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func requestCurrentLocation() {
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        
        // 마커 설정
        marker.position = coordinate
        marker.mapView = mapView
        
        // 지도 중심을 현재 위치로 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
        mapView.moveCamera(cameraUpdate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져오지 못했습니다: \(error.localizedDescription)")
    }
}