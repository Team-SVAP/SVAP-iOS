import UIKit
import RxSwift
import RxCocoa
import RxGesture

class MyPageAlert: BaseVC {
    
    private let disposeBag = DisposeBag()
    private var clickToAction: () -> Void = {}
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-000")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let questionLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 18)
    }
    private let explainLabel = UILabel().then {
        $0.textColor = .systemRed
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 10)
    }
    private let cancelButton = DetailPetitionlButton(type: .system, title: "취소", titleColor: UIColor(named: "gray-700")!, backgroundColor: .white)
    private let checkButton = DetailPetitionlButton(type: .system, title: "확인", titleColor: UIColor(named: "gray-000")!, backgroundColor: UIColor(named: "main-2")!)
    
    init(
        questionLabelText: String,
        explainLabelText: String,
        completion: @escaping () -> Void = {}
    ) {
        super.init(nibName: nil, bundle: nil)
        questionLabel.text = questionLabelText
        explainLabel.text = explainLabelText
        self.clickToAction = completion
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .placeholderText
    }
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(backgroundView)
        [
            questionLabel,
            explainLabel,
            cancelButton,
            checkButton
        ].forEach({ backgroundView.addSubview($0) })
        
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(170)
        }
        questionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25)
        }
        explainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(questionLabel.snp.bottom).offset(18)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        checkButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        
    }
    override func subscribe() {
        super.subscribe()
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        checkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.clickToAction()
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
    
}
