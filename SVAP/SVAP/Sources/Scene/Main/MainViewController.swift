import UIKit
import RxSwift
import RxCocoa
import SideMenu
import Moya

class MainViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    private let viewAppear = PublishRelay<Void>()
    private let refreshToken = PublishRelay<Void>()
    
    let textSubject = PublishSubject<String>()
    
    var isClick = false
    var cellArray = BehaviorRelay(value: [MainCell.self, ApprovedCell.self])
    var nowPage: Int = 0
    
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    
    private lazy var collctionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: view.frame.width - 40, height: 150)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collctionViewLayout).then {
        $0.backgroundColor = UIColor(named: "main-8")
        $0.layer.cornerRadius = 12
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(MainCell.self, forCellWithReuseIdentifier: MainCell.id)
        $0.register(ApprovedCell.self, forCellWithReuseIdentifier: ApprovedCell.id)
    }
    private let searchTextField = SearchTextField(placeholder: "청원을 검색해보세요.")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-600")
        $0.isEnabled = false
    }
    private let famousPetitionLabel = UILabel().then {
        $0.text = "인기 청원"
        $0.textColor = UIColor(named: "gray-600")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let viewMoreButton = LabelButton(type: .system, title: "더보기", titleColor: UIColor(named: "gray-600")!)
    private let famousPetitionTitleLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 18)
    }
    private let famousPetitionContentLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
        $0.numberOfLines = 10
        $0.textAlignment = .justified
    }
    private let viewContentButton = LabelButton(type: .system, title: "더보기", titleColor: UIColor(named: "gray-700")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerTimer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewAppear.accept(())
        refreshToken.accept(())//403 뜰 때만 하고싶은데..
    }
    override func configureUI() {
        [
            logoImage,
            collectionView,
            searchTextField,
            famousPetitionLabel,
            viewMoreButton,
            famousPetitionTitleLabel,
            famousPetitionContentLabel,
            viewContentButton
        ].forEach({ view.addSubview($0) })
        searchTextField.addSubview(searchButton)
    }
    override func setupConstraints() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(69)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(62)
            $0.height.equalTo(26)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(150)
        }
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
        famousPetitionLabel.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(20)
        }
        viewMoreButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(32)
            $0.right.equalToSuperview().inset(20)
        }
        famousPetitionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(famousPetitionLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(20)
        }
        famousPetitionContentLabel.snp.makeConstraints {
            $0.top.equalTo(famousPetitionTitleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
        }
        viewContentButton.snp.makeConstraints {
            $0.top.equalTo(famousPetitionContentLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().inset(20)
        }

    }
    
    override func bind() {
        super.bind()
        
        let input = MainViewModel.Input(
            viewAppear: viewAppear.asSignal(onErrorJustReturn: ()),
            refreshToken: viewAppear.asSignal()
        )
        let output = viewModel.transform(input)
        
        output.popularPetition.asObservable()
            .subscribe(onNext: { data in
                if data.title != "" && data.content != ""  {
                    self.famousPetitionTitleLabel.text = data.title
                    self.famousPetitionContentLabel.text = data.content
                } else {
                    self.famousPetitionTitleLabel.text = "Petition not found"
                }
            }).disposed(by: disposeBag)
    }

    override func subscribe() {
        super.subscribe()
        
        cellArray.bind(to: collectionView.rx.items){ (cv, row, item) in
            
            if row == 0 {
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: IndexPath.init(row: row, section: 0)) as! MainCell
                return cell
            } else {
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ApprovedCell", for: IndexPath.init(row: row, section: 0)) as! ApprovedCell
                cell.moveButton.rx.tap
                    .subscribe(onNext: {
                        self.tabBarController?.selectedIndex = 2
                    }).disposed(by: self.disposeBag)
                return cell
            }
        }.disposed(by: disposeBag)
       
        
        searchTextField.rx.text
            .orEmpty
            .bind(to: textSubject)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .withLatestFrom(textSubject)
            .bind(to: PetitionViewController.sharedText)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.tabBarController?.selectedIndex = 2
            })
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.searchTextField.layer.borderColor = UIColor(named: "gray-300")?.cgColor
                    self.searchButton.isEnabled = false
                } else {
                    self.searchTextField.layer.borderColor = UIColor(named: "main-3")?.cgColor
                    self.searchButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
        
        viewMoreButton.rx.tap
            .subscribe(onNext: {
                self.tabBarController?.selectedIndex = 2
            }).disposed(by: disposeBag)
        viewContentButton.rx.tap
            .subscribe(onNext: {
                self.isClick.toggle()
                if self.isClick {
                    self.famousPetitionContentLabel.numberOfLines = 0
                } else {
                    self.famousPetitionContentLabel.numberOfLines = 3
                }
            }).disposed(by: disposeBag)
        
    }
    
}

extension MainViewController {

    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
            self.bannerMove()
        }
    }
    func bannerMove() {
        if nowPage == cellArray.value.count-1 {
            collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
            return
        }
        nowPage += 1
        collectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

}
