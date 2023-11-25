import UIKit
import RxSwift
import RxCocoa
import Moya
import Kingfisher

class DetailPetitionViewController: BaseVC {
    
    
    private let disposeBag = DisposeBag()
    private let viewModel = DetailPetitionViewModel()
    private let viewAppear = PublishRelay<Void>()
    
    var isClick = false
    var imageArray = BehaviorRelay<[String]>(value: [])
    var image: [String] = []
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView = UIView()
    
    private let navigationBarTitle = UILabel().then {
        $0.text = "상세보기"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }

    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let tagLabel = UILabel().then {
        $0.textColor = UIColor(named: "main-1")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let menuButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "detailPetitionMenu"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let dateLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 12)
    }
    private let topLineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let bottomLineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 8
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCellId")
        return collectionView
    }()
    private let voteLabel = UILabel().then {
        $0.text = "청원 투표하기"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let petitionQuestionLabel = UILabel().then {
        $0.text = "이 청원과 같은 생각이라면 찬성 버튼을 눌러주세요."
        $0.textColor = UIColor(named: "gray-600")
        $0.font = UIFont(name: "IBMPlexSansKR-Regular", size: 8)
    }
    let voteButton = CustomButton(type: .custom, title: "찬성", titleColor: UIColor(named: "gray-000")!, backgroundColor: UIColor(named: "main-2")!).then {
        $0.isEnabled = true
    }
    private let buttonBottomLineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let viewCountLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 12)
    }
    let reportPetitionButton = UIButton(type: .system).then {
        $0.setTitle("이 청원 신고하기", for: .normal)
        $0.setTitleColor(UIColor(named: "main-1"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 12)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        navigationBarSetting()
        viewAppear.accept(())
        collectionView.delegate = self
//        collectionView.dataSource = self
    }
    override func configureUI() {
        super.configureUI()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)
      
        [
            tagLabel,
            menuButton,
            titleLabel,
            dateLabel,
            topLineView,
            contentLabel,
            bottomLineView,
            collectionView,
            voteLabel,
            petitionQuestionLabel,
            voteButton,
            buttonBottomLineView,
            viewCountLabel,
            reportPetitionButton
        ].forEach({ mainView.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(view.frame.height + 30)
        }
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(20)
        }
        menuButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(24)
            $0.right.equalToSuperview().inset(20)
        }
        topLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
        }
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.bottom).offset(13)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(250)
        }
        voteLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(20)
        }
        petitionQuestionLabel.snp.makeConstraints {
            $0.top.equalTo(voteLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
        }
        voteButton.snp.makeConstraints {
            $0.top.equalTo(petitionQuestionLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        buttonBottomLineView.snp.makeConstraints {
            $0.top.equalTo(voteButton.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        viewCountLabel.snp.makeConstraints {
            $0.top.equalTo(buttonBottomLineView.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
        reportPetitionButton.snp.makeConstraints {
            $0.top.equalTo(buttonBottomLineView.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(20)
        }
    }
    override func bind() {
        let input = DetailPetitionViewModel.Input(
            id: PetitionIdModel.shared.id,
            viewAppear: viewAppear.asSignal(onErrorJustReturn: ()),
            voteButtonTap: voteButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input)
        
        output.voteResult.asObservable()
            .subscribe(onNext: { bool in
            if bool {
                print("투표하였습니다")
            } else {
                print("취소되었습니다.")//수정하기
            }
        }).disposed(by: disposeBag)
        
        output.detailPetitionResult.asObservable()
            .subscribe(onNext: { data in
                self.tagLabel.text = "#\(data.types)_\(data.location)"
                self.titleLabel.text = data.title
                self.dateLabel.text = data.dateTime
                self.contentLabel.text = data.content
                self.viewCountLabel.text = String(data.viewCounts)
                if data.voted == true {
                    self.voteButton.backgroundColor = .systemBlue
                }
                self.imageArray = BehaviorRelay(value: data.imgUrl ?? [])
//                print(self.imageArray.value.count)
//                print(self.imageArray.value)
            }).disposed(by: disposeBag)

//        imageArray.bind(to: collectionView.rx.items(cellIdentifier: "ImageCellId", cellType: ImageCell.self)) { row, item, cell in
//            cell.cellImageView.kf.setImage(with: URL(string: item))
//        }.disposed(by: disposeBag)
        imageArray.bind(to: collectionView.rx.items(cellIdentifier: "ImageCellId", cellType: ImageCell.self)) { row, item, cell in
            cell.cellImageView.kf.setImage(with: URL(string: item))
        }.disposed(by: disposeBag)
        
    }
    override func subscribe() {
        super.subscribe()
        
        voteButton.rx.tap
            .subscribe(onNext: {
                self.isClick.toggle()
                if self.isClick {
                    self.voteButton.backgroundColor = .systemBlue
                } else {
                    self.voteButton.backgroundColor = UIColor(named: "main-2")
                }
            }).disposed(by: disposeBag)
        
        leftbutton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
        menuButton.rx.tap
            .subscribe(onNext: {
                let modal = UINavigationController(rootViewController: DetailPetitionAlert())
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self.present(modal, animated: true)
            }).disposed(by: disposeBag)
        
        reportPetitionButton.rx.tap
            .subscribe(onNext: {
                let modal = UINavigationController(rootViewController: PetitionReportAlert())
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self.present(modal, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func navigationBarSetting() {
        navigationItem.titleView = navigationBarTitle
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
    }
    
}

extension DetailPetitionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
