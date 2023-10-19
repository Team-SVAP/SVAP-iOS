import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Moya

class SideMenuContentViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SideMenuViewModel()
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        $0.clipsToBounds = true
    }
    private let settingButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "settingIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "closeIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let userNameLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let lineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let myPetitionButton = UIButton(type: .system).then {
        $0.setTitle("내가 쓴 청원보기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Regular", size: 16)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .placeholderText
        navigationController?.navigationBar.isHidden = true
        bind()
        subscribe()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
        setupConstraints()
    }
    
    private func configureUI() {
        
        view.addSubview(backgroundView)
        [
            settingButton,
            closeButton,
            userNameLabel,
            lineView,
            myPetitionButton
        ].forEach({ backgroundView.addSubview($0) })
    }
    private func setupConstraints() {
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.bottom.right.equalToSuperview()
            $0.width.equalTo(200)
        }
        settingButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
        closeButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(68)
            $0.left.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(22)
            $0.right.equalToSuperview().inset(18)
            $0.height.equalTo(1.5)
        }
        myPetitionButton.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(22)
        }
    }
    private let viewAppear = PublishRelay<Void>()
    func bind() {
        let input = SideMenuViewModel.Input(viewAppear: viewAppear.asSignal())
        let output = viewModel.transform(input)
        
        output.userName.subscribe(onNext: { data in
            self.userNameLabel.text = data.userName
        }).disposed(by: disposeBag)
    }
//    private func loadUserInfo() {
//        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
//        
//        provider.request(.loadUserInfo) { res in
//            switch res {
//                case .success(let result):
//                    switch result.statusCode {
//                        case 200:
//                            if let data = try? JSONDecoder().decode(UserInfoResponse.self, from: result.data) {
//                                DispatchQueue.main.async {
//                                    print("Success")
//                                    self.userNameLabel.text = data.userName
//                                }
//                            }
//                        default:
//                            print("Fail: \(result.statusCode)")
//                    }
//                case .failure(let err):
//                    print("Request Error: \(err.localizedDescription)")
//            }
//        }
//    }
    
    func subscribe() {
        
        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        myPetitionButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(UserPetitionViewController())
            }).disposed(by: disposeBag)
    }
    
}
