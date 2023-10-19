import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Moya

class ReportPetitionAlert: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-000")
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor(named: "gray-100")?.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    private let reportPetitionLabel = UILabel().then {
        $0.text = "청원 신고하기"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let explainLabel = UILabel().then {
        $0.text = "부적절한 신고는 불이익을 얻을 수 있습니다."
        $0.textColor = UIColor(named: "gray-600")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 10)
    }
    private let questionLabel = UILabel().then {
        $0.text = "이 청원을 신고하는 이유가 무엇인가요?"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 14)
    }
    private let textView = ReportPetitionTextView().then {
        $0.text = "신고하려는 이유를 써주세요."
    }
    private let reportButton = CustomButton(type: .system, title: "신고하기", titleColor: .white, backgroundColor: UIColor(named: "main-2")!).then {
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .placeholderText
        subscribe()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
        setupConstraints()
    }
    func configureUI() {
        view.addSubview(backgroundView)
        [
            reportPetitionLabel,
            explainLabel,
            questionLabel,
            textView,
            reportButton
        ].forEach({ backgroundView.addSubview($0) })
    }
    func setupConstraints() {
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(330)
        }
        reportPetitionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(20)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(reportPetitionLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
        }
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(20)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(310)
            $0.height.equalTo(150)
        }
        reportButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
    }
    func subscribe() {
        
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        reportButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        textView.rx.didChange
            .subscribe(onNext: {
                if self.textView.textColor == UIColor(named: "gray-500") {
                    self.textView.text = nil
                    self.textView.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
                    self.textView.textColor = UIColor(named: "gray-700")
                    self.reportButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext: {
                if self.textView.text.isEmpty {
                    self.textView.text = "신고하려는 이유를 써주세요."
                    self.textView.textColor = UIColor(named: "gray-500")
                    self.textView.font = UIFont(name: "IBMPlexSansKR-Regular", size: 8)
                    self.reportButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
    }
    
    
}
