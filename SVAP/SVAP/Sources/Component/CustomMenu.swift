import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CustomMenu: UIViewController {
    
    private let disposeBag = DisposeBag()
    var closure: (String) -> Void
    
    let menuView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "main-1")?.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = false
    }
    let slashButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "downArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    let schoolPetitionButton = UIButton(type: .system).then {
        $0.setTitle("학교 청원", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    let dormitoryPetitionButton = UIButton(type: .system).then {
        $0.setTitle("기숙사 청원", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
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
            schoolPetitionButton,
            dormitoryPetitionButton
        ].forEach({ menuView.addSubview($0) })
    }
    func setupConstraints() {
        menuView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(226)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(165)
            $0.height.equalTo(120)
        }
        slashButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(12)
        }
        schoolPetitionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.left.equalToSuperview().inset(12)
        }
        dormitoryPetitionButton.snp.makeConstraints {
            $0.top.equalTo(schoolPetitionButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(12)
        }
    }
    func subscribe() {
        schoolPetitionButton.rx.tap
            .subscribe(onNext: {
                self.closure("학교 청원")
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        dormitoryPetitionButton.rx.tap
            .subscribe(onNext: {
                self.closure("기숙사 청원")
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        slashButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
}
