import UIKit
import RxSwift
import RxCocoa
import Moya

class DetailPetitionViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    
    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let tagLabel = UILabel().then {
        $0.text = "# 기숙사_화장실"
        $0.textColor = UIColor(named: "main-1")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let titleLabel = UILabel().then {
        $0.text = "사형 제도 부활을 건의합니다."
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let dateLabel = UILabel().then {
        $0.text = "2023-09-16"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 12)
    }
    private let topLineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DetailPetitionCell.self, forCellWithReuseIdentifier: "cellId")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationBarSetting()
    }
    override func configureUI() {
        super.configureUI()
        
        [
            tagLabel,
            titleLabel,
            dateLabel,
            topLineView,
            collectionView
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(99)
            $0.left.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview().inset(20)
        }
        topLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    private func navigationBarSetting() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "상세보기"
        title.textColor = UIColor(named: "gray-800")
        title.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        title.textAlignment = .center
        navigationItem.titleView = title
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
    }
    
    func loadDetailPetition() {
        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
        
        provider.request(.loadDetailPetition(petitionId: 1)) { res in
            switch res {
                case .success(let result):
                    switch result.statusCode {
                        case 200:
                            break
                        default:
                            print("Fail: \(result.statusCode)")
                    }
                case .failure(let err):
                    print("Request Fail: \(err.localizedDescription)")
            }
        }
//        PetitionViewController(userDetailPetition: { text in
//            self.titleLabel.text = 
//        })
    }
    
    override func subscribe() {
        super.subscribe()
        
        leftbutton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
    }
}

extension DetailPetitionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 1000)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! DetailPetitionCell
        cell.reportPetitionButton.rx.tap
            .subscribe(onNext: {
                let modal = UINavigationController(rootViewController: ReportPetitionAlert())
                modal.modalPresentationStyle = .overFullScreen
                self.present(modal, animated: true)
            }).disposed(by: disposeBag)
        return cell
    }
    
    

}
