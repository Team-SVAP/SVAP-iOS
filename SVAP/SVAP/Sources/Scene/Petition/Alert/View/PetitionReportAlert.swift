import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Moya

class PetitionReportAlert: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = PetitionReportAlertViewModel()
    
    var petitionId = 0
    
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
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 20)
    }
    private let explainLabel = UILabel().then {
        $0.text = "부적절한 신고는 불이익을 얻을 수 있습니다."
        $0.textColor = UIColor(named: "gray-600")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let cancelButton = PetitionReportButton(type: .system, title: "취소", titleColor: UIColor(named: "gray-700"), backgroundColor: .white, borderColor: UIColor(named: "main-2")!, borderWidth: 1)
    private let reportButton = PetitionReportButton(type: .system, title: "신고", titleColor: UIColor(named: "gray-000"), backgroundColor: UIColor(named: "main-2"), borderColor: .clear, borderWidth: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .placeholderText
        bind()
        subscribe()
        print(petitionId)
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
            cancelButton,
            reportButton
        ].forEach({ backgroundView.addSubview($0) })
    }
    func setupConstraints() {
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(165)
        }
        reportPetitionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25)
        }
        explainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(reportPetitionLabel.snp.bottom).offset(7)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        reportButton.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(15)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        
    }
    func bind() {
        
        let input = PetitionReportAlertViewModel.Input(
            petitionId: petitionId,
            reportTap: reportButton.rx.tap.asSignal())
        
        let output = viewModel.transform(input)
        
        output.result.subscribe(onNext: { bool in
            if bool {
                self.dismiss(animated: true)
            } else {
                print("Fail")
            }
        }).disposed(by: disposeBag)
        
    }
    func subscribe() {
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
    
    
}
