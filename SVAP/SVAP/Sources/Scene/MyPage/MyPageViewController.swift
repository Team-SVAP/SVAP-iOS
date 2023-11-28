import UIKit
import RxSwift
import RxCocoa
import Moya

class MyPageViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MyPageViewModel()
    private let viewAppear = PublishRelay<Void>()
    
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
    private let bottomPaddingView = UIView().then {
        $0.backgroundColor = .white
    }

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
            bottomPaddingView
        ].forEach({ view.addSubview($0) })
        
        topPaddingView.addSubview(navigationTitleLabel)
        
    }
    override func setupConstraints() {
        
        topPaddingView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        navigationTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(67)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(115)
            $0.left.equalToSuperview().inset(20)
        }
        bottomPaddingView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(82)
            $0.height.equalTo(90)
        }
        
    }
    
    override func bind() {
        let input = MyPageViewModel.Input(
            viewAppear: viewAppear.asSignal(onErrorJustReturn: ())
        )
        let output = viewModel.transform(input)
        
        output.userName.asObservable()
            .subscribe(onNext: { data in
                if data.userName != "" {
                    self.userNameLabel.text = "\(data.userName ?? "")님,\n안녕하세요!"
                } else {
                    self.userNameLabel.text = "User not found"
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func subscribe() {
        
    }
    
    private func labelSetting(_ label: UILabel) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        
        attributedString.addAttribute(.font, value: UIFont(name: "IBMPlexSansKR-Regular", size: 14)!, range: (label.text! as NSString).range(of: "*"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (label.text! as NSString).range(of:"*"))
        label.attributedText = attributedString
    }
    
}
