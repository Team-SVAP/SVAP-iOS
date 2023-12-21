import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailPetitionViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = DetailPetitionViewModel()
    private let viewAppear = PublishRelay<Void>()

    var isClick = false

    var imageArray: [String] = []
    var dataImageArray = BehaviorRelay<[String]>(value: [])

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView = UIView()

    private let topPaddingView = UIView().then {
        $0.backgroundColor = .white
    }
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
    private lazy var collctionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: view.frame.width - 40, height: 250)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collctionViewLayout).then {
        $0.backgroundColor = .white
        $0.isPagingEnabled = true
        $0.layer.cornerRadius = 8
        $0.showsHorizontalScrollIndicator = false
        $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.id)
    }
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
        viewAppear.accept(())
        navigationBarSetting()
    }
    override func configureUI() {
        super.configureUI()
        
        [
            scrollView
        ].forEach({ view.addSubview($0) })
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
            $0.edges.equalToSuperview()
            $0.height.equalTo(view.frame.height)
        }
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        menuButton.snp.makeConstraints {
            $0.top.equalToSuperview()
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
                print("Success")
            } else {
                print("Fail")
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
                    self.voteButton.setTitle("찬성 취소", for: .normal)
                    self.isClick = true
                }
                if data.accountId == UserDefaults.standard.string(forKey: "userID") {
                    self.menuButton.isHidden = false
                } else {
                    self.menuButton.isHidden = true
                }
                self.imageArray = data.imgUrl ?? []
                self.dataImageArray.accept(self.imageArray)
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        dataImageArray.bind(to: collectionView.rx.items(cellIdentifier: ImageCell.id, cellType: ImageCell.self)) { row, item, cell in
            cell.cellImageView.kf.setImage(with: URL(string: self.imageArray[row]))
            cell.imageDeleteButton.isHidden = true
        }.disposed(by: disposeBag)

    }
    override func subscribe() {
        super.subscribe()

        voteButton.rx.tap
            .subscribe(onNext: {
                self.isClick.toggle()
                if self.isClick {
                    self.voteButton.backgroundColor = .systemBlue
                    self.voteButton.setTitle("찬성 취소", for: .normal)
                } else {
                    self.voteButton.backgroundColor = UIColor(named: "main-2")
                    self.voteButton.setTitle("찬성", for: .normal)
                }
            }).disposed(by: disposeBag)
        
        leftbutton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
        menuButton.rx.tap
            .subscribe(onNext: {
                let modal = DetailPetitionAlert(popCompletion: {
                    self.popViewController()
                })
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self.present(modal, animated: true)
            }).disposed(by: disposeBag)
        
        reportPetitionButton.rx.tap
            .subscribe(onNext: {
                let modal = PetitionReportAlert()
                modal.modalPresentationStyle = .overFullScreen
                modal.modalTransitionStyle = .crossDissolve
                self.present(modal, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func navigationBarSetting() {
        navigationItem.titleView = navigationBarTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
        navigationController?.isNavigationBarHidden = false
    }
    
}
