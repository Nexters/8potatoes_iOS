//
//  StartViewController.swift
//  SafeAreaTravel
//
//  Created by 최지철 on 7/20/24.
//

import UIKit

import Then
import RxSwift
import ReactorKit

final class StartViewController: BaseViewController, View {
    
    // MARK: - Properties

    private let reactor: StartReactor
    var disposeBag: DisposeBag = .init()

    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let welecomeLabel = UILabel().then {
        $0.text = "여행길에 딱 맞는\n휴게소를 찾아보세요."
        $0.font = .suit(.Bold, size: 24)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    private let welecomeImg = UIImageView().then {
        $0.image = UIImage(named: "dayTimeStartBackgroundImg")
        $0.contentMode = .scaleAspectFill
    }
    private let startInputDesLabel = UILabel().then {
        $0.text = "출발지 입력*"
        $0.font = .suit(.Medium, size: 14)
        $0.sizeToFit()
        $0.textColor = .bik30
        $0.setColorForText(textForAttribute: "*", withColor: .red)
    }
    private let goalInputDesLabel = UILabel().then {
        $0.text = "도착지 입력*"
        $0.font = .suit(.Medium, size: 14)
        $0.sizeToFit()
        $0.textColor = .bik30
        $0.setColorForText(textForAttribute: "*", withColor: .red)
    }
    private let startLocateBtn = UIButton().then {
        $0.setTitle("어디서 출발하세요?", for: .normal)
        $0.titleLabel?.font = .suit(.Medium, size: 18)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.bik30, for: .normal)
    }
    private let divideLine = DivideLine(type: .line)
    private let goalLocateBtn = UIButton().then {
        $0.setTitle("어디까지 가세요?", for: .normal)
        $0.titleLabel?.font = .suit(.Medium, size: 18)
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(.bik30, for: .normal)
    }
    private let sideImge = UIImageView().then {
        $0.image = UIImage(named: "sideLocateImg")
    }
    private let chagneLocateBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "swap"), for: .normal)
    }
    private let searchBtn = UIButton().then {
        $0.setTitle("휴게소 찾기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .suit(.Bold, size: 16)
        $0.backgroundColor = .bik20
        $0.layer.cornerRadius = 16
        $0.isEnabled = true
    }
    private let locateVerticalFlexContainer = UIView()
    private let locateHorizontalFlexContainer = UIView()
    private let rootFlexContainer = UIView()

    // MARK: - Init & LifeCycle
    
    init(reactor: StartReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
        bind(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUpUI
    
    override func configure() {
        navigationController?.navigationBar.isHidden = true
        searchBtn.isEnabled = false
        reactor.action.onNext(.viewDidLoad)
    }
    
    override func addView() {
        self.view.addSubview(scrollView)
         scrollView.addSubview(rootFlexContainer)
    }
    
    override func layout() {
        locateVerticalFlexContainer.flex
            .direction(.column)
            .alignItems(.stretch)
            .define { flex in
                flex.addItem(startInputDesLabel)
                    .marginLeft(0)
                flex.addItem(startLocateBtn)
                    .marginLeft(0)
                    .height(48)
                flex.addItem(divideLine)
                    .horizontally(0)
                    .height(1)
                flex.addItem(goalInputDesLabel)
                    .marginTop(21.5)
                    .marginLeft(0)
                flex.addItem(goalLocateBtn)
                    .marginLeft(0)
                    .height(48)
            }
        locateHorizontalFlexContainer.flex
            .direction(.row)
            .alignItems(.stretch)
            .define {  flex in
                flex.addItem(sideImge)
                    .marginTop(39)
                    .marginLeft(20)
                    .height(102)
                    .width(24)
                flex.addItem(locateVerticalFlexContainer)
                    .marginTop(32)
                    .marginLeft(20)
                    .marginRight(20)
                    .grow(1)
                flex.addItem(chagneLocateBtn)
                    .alignSelf(.center)
                    .width(24)
                    .height(24)
                    .marginRight(20)
            }
        rootFlexContainer.flex
            .direction(.column)
            .alignItems(.stretch)
            .define {  flex in
                flex.addItem(welecomeImg)
                    .marginLeft(0)
                    .marginRight(0)
                    .height(327)
                flex.addItem(welecomeLabel)
                    .marginTop(60)
                    .marginLeft(20)
                flex.addItem(locateHorizontalFlexContainer)
                    .marginTop(32)
                    .marginLeft(0)
                    .marginRight(0)
                flex.addItem(searchBtn)
                    .marginTop(20)
                    .height(56)
                    .marginLeft(20)
                    .marginRight(20)
            }
        scrollView.pin.all()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        
        scrollView.contentSize = rootFlexContainer.frame.size
    }
    
    // MARK: - Bind
    
    func bind(reactor: StartReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindState(reactor: StartReactor) {
        reactor.state
            .map{ $0.startLocation}
            .distinctUntilChanged()
            .bind(onNext: {  [weak self] location in
                self?.startLocateBtn.setTitle(location.name == "" ? location.fullAddressRoad : location.name, for: .normal)
                self?.startLocateBtn.setTitleColor(.bik100, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map{ $0.goalLocation}
            .distinctUntilChanged()
            .bind(onNext: {  [weak self] location in
                self?.goalLocateBtn.setTitle(location.name == "" ? location.fullAddressRoad : location.name, for: .normal)
                self?.goalLocateBtn.setTitleColor(.bik100, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.completeSetLocation }
            .bind(onNext: { [weak self] isCompleted in
                if isCompleted {
                    self?.searchBtn.isEnabled = true
                    self?.searchBtn.backgroundColor = .main100
                    self?.chagneLocateBtn.setImage(UIImage(named: "Swap"), for: .normal)
                    self?.divideLine.updateColor(.main100)
                } else {
                    self?.searchBtn.isEnabled = false
                    self?.searchBtn.backgroundColor = .bik20
                    self?.chagneLocateBtn.setImage(UIImage(named: "emptySwap"), for: .normal)
                    self?.divideLine.updateColor(.bik5)
                }
            }
            )
            .disposed(by: disposeBag)
            
        reactor.state
            .asDriver(onErrorJustReturn: reactor.initialState)
            .drive(onNext: {  [weak self]  res in
                self?.welecomeImg.image = res.startImg
                           
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: StartReactor) {
        searchBtn.rx.tap
            .map { StartReactor.Action.searchBtnTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        startLocateBtn.rx.tap
            .map { StartReactor.Action.startLocationTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        goalLocateBtn.rx.tap
            .map { StartReactor.Action.goalLocationTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        chagneLocateBtn.rx.tap
            .map { StartReactor.Action.chageBtnTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
}
