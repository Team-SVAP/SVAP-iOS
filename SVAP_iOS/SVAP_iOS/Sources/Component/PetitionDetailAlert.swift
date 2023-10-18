import UIKit
import RxSwift
import RxCocoa

class PetitionDetailAlert: BaseVC {
    
    private let disposeBag = DisposeBag()
    
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
    private let deleteButton = PetitionDetailButton(type: .system, title: "삭제하기", titleColor: UIColor(named: "gray-700")!, backgroundColor: .white)
    private let modifyButton = PetitionDetailButton(type: .system, title: "수정하기", titleColor: UIColor(named: "gray-000")!, backgroundColor: UIColor(named: "main-2")!)
    
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
            deleteButton,
            modifyButton
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
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
        modifyButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
    }
    override func subscribe() {
        super.subscribe()
        
        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
    }
}
