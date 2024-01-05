import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Moya

class DetailPetitionAlert: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = DetailPetitionAlertViewModel()
    private var clickToPop: () -> Void = {}
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let moreViewLabel = UILabel().then {
        $0.text = "더보기"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 20)
    }
    private let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "closeIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-800")
    }
    private let deleteButton = DetailPetitionlButton(type: .system, title: "삭제하기", titleColor: UIColor(named: "gray-700")!, backgroundColor: .white)

    init(popCompletion: @escaping () -> Void = {}) {
        self.clickToPop = popCompletion
        super.init(nibName: nil, bundle: nil)
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
            moreViewLabel,
            closeButton,
            deleteButton
        ].forEach({ backgroundView.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(142)
        }
        moreViewLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(20)
        }
        closeButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        deleteButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
    }
    override func bind() {
        super.bind()
        
        let input = DetailPetitionAlertViewModel.Input(
            petitionId: PetitionIdModel.shared.id,
            deleteTap: deleteButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input)
        
        output.deleteResult.subscribe(onNext: { [weak self] bool in
            if bool {
                self?.dismiss(animated: true, completion: {
                    self?.clickToPop()
                })
            } else {
                print("Fail")
            }
        }).disposed(by: disposeBag)
    }
    override func subscribe() {
        super.subscribe()
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)

        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)

    }
    
}
