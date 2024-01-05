import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxGesture

class PetitionMenu: UIViewController {
    
    private let disposeBag = DisposeBag()
    var closure: (String) -> Void
    
    let menuView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "main-6")?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = false
    }
    let slashButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "miniDownArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    let viewRecentPetitonButton = LabelButton(type: .system, title: "최신순으로 보기", titleColor: UIColor(named: "gray-800")!)
    let viewVotePetitonButton = LabelButton(type: .system, title: "투표순으로 보기", titleColor: UIColor(named: "gray-800")!)
    let viewAccessPetitionButton = LabelButton(type: .system, title: "승인된 청원 보기", titleColor: UIColor(named: "gray-800")!)
    let viewWaitPetitionButton = LabelButton(type: .system, title: "검토중인 청원 보기", titleColor: UIColor(named: "gray-800")!)
    
    init(closure: @escaping (String) -> Void) {
        self.closure = closure
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        subscribe()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
        setupConstraints()
    }
    
    func configureUI() {
        view.addSubview(menuView)
        [
            slashButton,
            viewRecentPetitonButton,
            viewVotePetitonButton,
            viewAccessPetitionButton,
            viewWaitPetitionButton
        ].forEach({ menuView.addSubview($0) })
    }
    func setupConstraints() {
        menuView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(145)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(120)
            $0.height.equalTo(132)
        }
        slashButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(12)
        }
        viewRecentPetitonButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(8)
        }
        viewVotePetitonButton.snp.makeConstraints {
            $0.top.equalTo(viewRecentPetitonButton.snp.bottom)
            $0.left.equalToSuperview().inset(8)
        }
        viewAccessPetitionButton.snp.makeConstraints {
            $0.top.equalTo(viewVotePetitonButton.snp.bottom)
            $0.left.equalToSuperview().inset(8)
        }
        viewWaitPetitionButton.snp.makeConstraints {
            $0.top.equalTo(viewAccessPetitionButton.snp.bottom)
            $0.left.equalToSuperview().inset(8)
        }
    }
    func subscribe() {
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in 
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        slashButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        viewRecentPetitonButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.closure("최신순으로 보기")
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        viewAccessPetitionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.closure("승인된 청원 보기")
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        viewVotePetitonButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.closure("투표순으로 보기")
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        viewWaitPetitionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.closure("검토중인 청원 보기")
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
}
