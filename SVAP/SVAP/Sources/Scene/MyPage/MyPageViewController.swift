import UIKit
import RxSwift
import RxCocoa

class MyPageViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MyPageViewModel()
    private let viewAppear = PublishRelay<Void>()
    private let membershipCancelSiganl = PublishRelay<Void>()
    
    private let topPaddingView = UIView().then {
        $0.backgroundColor = .white
    }
    private let navigationTitleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let userNameLabel = UILabel().then {
        $0.text = "님,\n안녕하세요!"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 24)
        $0.numberOfLines = 2
    }
    private let line1 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let viewUserPetitionButton = LabelButton(type: .system, title: "내가 쓴 청원 보기", titleColor: UIColor(named: "gray-800")!)
    private let line2 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let modifyUserInfo = LabelButton(type: .system, title: "내 정보 수정", titleColor: UIColor(named: "gray-800")!)
    private let line3 = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let buttonStackView = UIStackView().then {
        $0.spacing = 24
        $0.axis = .horizontal
        $0.backgroundColor = .clear
    }
    private let logoutButton = LabelButton(type: .system, title: "로그아웃", titleColor: UIColor(named: "gray-800")!)
    private let membershipCancelButton = LabelButton(type: .system, title: "회원 탈퇴", titleColor: UIColor(named: "gray-800")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        viewAppear.accept(())
    }
    override func configureUI() {
        
        [
            topPaddingView,
            userNameLabel,
            line1,
            viewUserPetitionButton,
            line2,
            modifyUserInfo,
            line3,
            buttonStackView
        ].forEach({ view.addSubview($0) })
        [logoutButton, membershipCancelButton].forEach({ buttonStackView.addArrangedSubview($0) })
        topPaddingView.addSubview(navigationTitleLabel)
        
    }
    override func setupConstraints() {
        
        topPaddingView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        navigationTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(59)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(115)
            $0.left.equalToSuperview().inset(20)
        }
        line1.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        viewUserPetitionButton.snp.makeConstraints {
            $0.top.equalTo(line1.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(20)
        }
        line2.snp.makeConstraints {
            $0.top.equalTo(viewUserPetitionButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        modifyUserInfo.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(20)
        }
        line3.snp.makeConstraints {
            $0.top.equalTo(modifyUserInfo.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(line3.snp.bottom).offset(20)
        }
        
    }
    
    override func bind() {
        let input = MyPageViewModel.Input(
            viewAppear: viewAppear.asSignal(onErrorJustReturn: ()),
            deleteTap: membershipCancelSiganl.asSignal(onErrorJustReturn: ())
        )
        let output = viewModel.transform(input)
        
        output.userName.asObservable()
            .subscribe(onNext: { data in
                self.userNameLabel.text = "\(data.userName ?? "User not found")님,\n안녕하세요!"
            })
            .disposed(by: disposeBag)
        
        output.deleteResult.asObservable()
            .subscribe(onNext: { bool in
                if bool {
                    print("Success")
                } else {
                    print("Fail")
                }
            }).disposed(by: disposeBag)
    }
    
    override func subscribe() {
        super.subscribe()
        
        viewUserPetitionButton.rx.tap
            .subscribe(onNext: {
                let vc = UserPetitionViewController()
                vc.hidesBottomBarWhenPushed = true
                self.pushViewController(vc)
            }).disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                let modal = MyPageAlert(
                    questionLabelText: "로그아웃 하시겠습니까?",
                    explainLabelText: "다시 로그인 해야 합니다.",
                    completion: {
                        Token.removeToken()
                        let vc = LoginViewController()
                        vc.hidesBottomBarWhenPushed = true
                        self.pushViewController(vc)
                    })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self.present(modal, animated: true)
            }).disposed(by: disposeBag)
        membershipCancelButton.rx.tap
            .subscribe(onNext: {
                let modal = MyPageAlert(
                    questionLabelText: "회원탈퇴 하시겠습니까?",
                    explainLabelText: "계정이 삭제됩니다.",
                    completion: {
                        self.membershipCancelSiganl.accept(())
                        let vc = OnboardingViewController()
                        vc.hidesBottomBarWhenPushed = true
                        self.pushViewController(vc)
                    })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self.present(modal, animated: true)
            }).disposed(by: disposeBag)
        
    }
    
    private func labelSetting(_ label: UILabel) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        
        attributedString.addAttribute(.font, value: UIFont(name: "IBMPlexSansKR-Regular", size: 14)!, range: (label.text! as NSString).range(of: "*"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (label.text! as NSString).range(of:"*"))
        label.attributedText = attributedString
    }
    
}
