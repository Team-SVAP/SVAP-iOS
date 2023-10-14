import UIKit
import SnapKit
import Then
import Moya

class PetitionMenu: UIViewController {
    
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
        $0.addTarget(self, action: #selector(clickSlashButton), for: .touchUpInside)
    }
    let viewRecentPetitonButton = LabelButton(type: .system, title: "최신순으로 보기", titleColor: UIColor(named: "gray-800")!).then {
        $0.addTarget(self, action: #selector(recentPetitonButton), for: .touchUpInside)
    }
    let viewVotePetitonButton = LabelButton(type: .system, title: "투표순으로 보기", titleColor: UIColor(named: "gray-800")!).then {
        $0.addTarget(self, action: #selector(votePetitonButton), for: .touchUpInside)
    }
    let viewAccessPetitionButton = LabelButton(type: .system, title: "승인된 청원 보기", titleColor: UIColor(named: "gray-800")!).then {
        $0.addTarget(self, action: #selector(accessPetitionButton), for: .touchUpInside)
    }
    let viewWaitPetitionButton = LabelButton(type: .system, title: "검토중인 청원 보기", titleColor: UIColor(named: "gray-800")!).then {
        $0.addTarget(self, action: #selector(waitPetitionButton), for: .touchUpInside)
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
//    private func loadPetition() {
//        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
//        
//        provider.request(.loadAllRecentPetitoin) { res in
//            switch res {
//                case .success(let result):
//                    switch result.statusCode {
//                        case 200:
//                            if let data = try? JSONDecoder().decode(PetitonResponse.self, from: result.data) {
//                                DispatchQueue.main.async {
//                                    self.petitionList = data.map {
//                                        .init(
//                                            id: $0.id,
//                                            title: $0.title,
//                                            content: $0.content,
//                                            date: $0.dateTime,
//                                            location: $0.location
//                                        )
//                                    }
//                                    self.petitionList.sort(by: { $0.id > $1.id })
//                                }
//                            } else {
//                                print("Response load fail")
//                            }
//                        default:
//                            print("Fail: \(result.statusCode)")
//                    }
//                case .failure(let err):
//                    print("Request Error: \(err.localizedDescription)")
//            }
//        }
//    }
    @objc func recentPetitonButton() {
        closure("최신순으로 보기")
        self.dismiss(animated: true)
    }
    @objc func votePetitonButton() {
        closure("투표순으로 보기")
        self.dismiss(animated: true)
    }
    @objc func accessPetitionButton() {
        closure("승인된 청원 보기")
        self.dismiss(animated: true)
    }
    @objc func waitPetitionButton() {
        closure("검토중인 청원 보기")
        self.dismiss(animated: true)
    }
    @objc func clickSlashButton() {
        self.dismiss(animated: true)
    }
}
