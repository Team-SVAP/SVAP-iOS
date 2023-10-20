import UIKit
import RxSwift
import RxCocoa
import SideMenu
import Moya

class MainViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    
    let sideMenu = SideMenuNavigationController(rootViewController: SideMenuContentViewController())
    var isExpanded = false
    var data = [MainCell.self, ApprovedCell.self]
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
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: "MainCell")
        collectionView.register(ApprovedCell.self, forCellWithReuseIdentifier: "ApprovedCell")
        return collectionView
    }()
    private let searchTextField = SearchTextField(placeholder: "청원을 검색해보세요.")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-600")
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
        $0.numberOfLines = 7
        $0.textAlignment = .justified
    }
    private let viewContentButton = LabelButton(type: .system, title: "더보기", titleColor: UIColor(named: "gray-700")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        pageControlSetting()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationBarSetting()
        sideMenuSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPopularPetition()
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
    private func navigationBarSetting() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    override func subscribe() {
        super.subscribe()
        
        menuButton.rx.tap
            .subscribe(onNext: {
                self.sideMenuSetting()
                self.present(self.sideMenu, animated: true)
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
                self.isExpanded.toggle()
                if self.isExpanded {
                    self.famousPetitionContentLabel.numberOfLines = 0
                } else {
                    self.famousPetitionContentLabel.numberOfLines = 7
                }
            }).disposed(by: disposeBag)
        
        createPetitionButton.rx.tap
            .subscribe(onNext: {
                self.pushViewController(CreatePetitionViewController())
            }).disposed(by: disposeBag)
    }
    override func bind() {
        super.bind()
        
        
    }
    private func loadPopularPetition() {
        
        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
        
        provider.request(.loadPopularPetition) { res in
            switch res {
                case .success(let result):
                    switch result.statusCode {
                        case 200:
                            if let data = try? JSONDecoder().decode(PetitonResponseElement.self, from: result.data) {
                                DispatchQueue.main.async {
                                    self.famousPetitionTitleLabel.text = data.title
                                    self.famousPetitionContentLabel.text = data.content
                                }
                            } else {
                                print("Response load fail")
                            }
                        default:
                            print("Fail: \(result.statusCode)")
                    }
                case .failure(let err):
                    print("Request Error: \(err.localizedDescription)")
            }
        }
    }
//    private let pageControl = UIPageControl()
//    func pageControlSetting() {
//        view.addSubview(pageControl)
//        pageControl.hidesForSinglePage = true
//        pageControl.numberOfPages = 5
//        pageControl.pageIndicatorTintColor = .darkGray
//        
//        
//        pageControl.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().inset(270)
//        }
//    }
//    let transition = CATransition()
//    func transitionSetting() {
//        transition.duration = 5
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//    }
    private func sideMenuSetting() {
        sideMenu.leftSide = true
        SideMenuManager.default.rightMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        sideMenu.presentationStyle = .menuSlideIn
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
                  // "cell1"에 대한 데이터 설정
                  return cell
              } else {
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApprovedCell", for: indexPath) as! ApprovedCell
                  // "cell2"에 대한 데이터 설정
                  return cell
              }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return data.count
        return 2
    }
}
