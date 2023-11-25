import UIKit
import RxSwift
import RxCocoa
import SideMenu
import Moya

class MainViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    private let viewAppear = PublishRelay<Void>()
    
    let sideMenu = SideMenuNavigationController(rootViewController: SideMenuViewController())
    var isClick = false
    var data = [MainCell.self, ApprovedCell.self]
    var nowPage: Int = 0
    
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let menuButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "mainMenu"), for: .normal)
        $0.tintColor = UIColor(named: "gray-500")
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "main-8")
        collectionView.layer.cornerRadius = 12
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: "MainCell")
        collectionView.register(ApprovedCell.self, forCellWithReuseIdentifier: "ApprovedCell")
        return collectionView
    }()
    private let searchTextField = SearchTextField(placeholder: "청원을 검색해보세요.")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-600")
        $0.isEnabled = false
    }
    private let viewPetitionButton = PetitionButton(type: .system, title: "청원보기", image: UIImage(named: "peopleIcon")!)
    private let createPetitionButton = PetitionButton(type: .system, title: "청원하기", image: UIImage(named: "editIcon")!)
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
        $0.numberOfLines = 3
        $0.textAlignment = .justified
    }
    private let viewContentButton = LabelButton(type: .system, title: "더보기", titleColor: UIColor(named: "gray-700")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationBarSetting()
        sideMenuSetting()
        bannerTimer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewAppear.accept(())
    }
    override func configureUI() {
        [
            logoImage,
            collectionView,
            searchTextField,
            viewPetitionButton,
            createPetitionButton,
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
            $0.height.equalTo(25)
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
        viewPetitionButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(20)
            $0.width.equalTo(170)
            $0.height.equalTo(100)
        }
        createPetitionButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(170)
            $0.height.equalTo(100)
        }
        famousPetitionLabel.snp.makeConstraints {
            $0.top.equalTo(viewPetitionButton.snp.bottom).offset(32)
            $0.left.equalToSuperview().inset(20)
        }
        viewMoreButton.snp.makeConstraints {
            $0.top.equalTo(viewPetitionButton.snp.bottom).offset(32)
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
            viewAppear: viewAppear.asSignal(onErrorJustReturn: ())
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
        
        menuButton.rx.tap
            .subscribe(onNext: {
                self.sideMenuSetting()
                self.present(self.sideMenu, animated: true)
            }).disposed(by: disposeBag)
        
        searchButton.rx.tap
            .subscribe(onNext: {
                let vc = PetitionViewController()
                vc.searchTextField.text = self.searchTextField.text
                self.pushViewController(vc)
            }).disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .subscribe(onNext: {
                if $0.isEmpty {
                    self.searchButton.isEnabled = false
                } else {
                    self.searchButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
        
        viewPetitionButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(PetitionViewController())
            }).disposed(by: disposeBag)
        
        viewMoreButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(PetitionViewController())
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
        
        createPetitionButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(PetitionCreateViewController())
            }).disposed(by: disposeBag)
    }
    
    private func navigationBarSetting() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    private func sideMenuSetting() {
        sideMenu.leftSide = true
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        sideMenu.presentationStyle = .menuSlideIn
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApprovedCell", for: indexPath) as! ApprovedCell
            cell.moveButton.rx.tap
                .subscribe(onNext: {
                    self.pushViewController(PetitionViewController())
                }).disposed(by: disposeBag)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
            self.bannerMove()
        }
    }
    func bannerMove() {
        if nowPage == data.count-1 {
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
