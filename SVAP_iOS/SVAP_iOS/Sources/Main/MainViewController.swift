import UIKit

class MainViewController: BaseVC {
    //사이드 메뉴 라이브러리 사용하기https://gonslab.tistory.com/10
    var isExpanded = false
    var data = [MainCell.self, ApprovedCell.self]
    private let logoImage = UIImageView(image: UIImage(named: "shadowLogo"))
    private let menuButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "menu"), for: .normal)
        $0.tintColor = UIColor(named: "gray-500")
        $0.addTarget(self, action: #selector(clickMenuButton), for: .touchUpInside)
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "main-8")
        collectionView.layer.cornerRadius = 12
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: "Cell1")
        collectionView.register(ApprovedCell.self, forCellWithReuseIdentifier: "Cell2")
        return collectionView
    }()
    private let searchTextField = UITextField().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor(named: "main-3")?.cgColor
        $0.layer.borderWidth = 1
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.backgroundColor = .white
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Regular", size: 16)
        let leftSpacerView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        let rightSpacerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        $0.leftView = leftSpacerView
        $0.rightView = rightSpacerView
        $0.leftViewMode = .always
        $0.rightViewMode = .always
    }
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-600")
    }
    private let viewPetitionButton = PetitionButton(type: .system, title: "청원보기", image: UIImage(named: "peopleIcon")!)
    private let writePetitionButton = PetitionButton(type: .system, title: "청원하기", image: UIImage(named: "editIcon")!)
    private let famousPetitionLabel = UILabel().then {
        $0.text = "인기 청원"
        $0.textColor = UIColor(named: "gray-600")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let viewMoreButton = LabelButton(type: .system, title: "더보기", titleColor: UIColor(named: "gray-600")!)
    private let famousPetitionTitleLabel = UILabel().then {
        $0.text = "촉법 소년법 폐지 & 개정"
        //서버통신하고 지우기
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 18)
    }
    private let famousPetitionContentLabel = UILabel().then {
        $0.text = "요즘들어 나이 믿고 까불고 사고치고 사건 사고가 많은 나이 만 14이하 촉법소년들 이거 문제 심각합니다. 빨리 법개정안하면 진짜 누구하나 죽을꺼임 이미 학폭으로 14세 미만 어린 피해자들이 많이 나오고도 있는 상황인대 무슨 근거와 깡으로 촉법소년 유지를 하고 있는건지 이유를 모르겠네요. 14세 미만 아이들이 모여서 또래 친구들 폭행. 폭언. 성희롱. 성추행등으로 사망하는 피해자가 있고, 온갖 중범죄란 죄는 다저질르는대 촉법이란 이유로 형사처벌 면하고. 촉법이 아니더라도 어리다.교화가 먼저고 교육이 먼저라는 이유로 형을 너무 낮게 한다던가.뭐 이딴 개같은 법이 어딨고 뭐 있단 개같은 경우가 다있습니까? 마냑 피해자가 당신들 아들.딸이"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
        $0.numberOfLines = 7
        $0.textAlignment = .justified
    }
    private let viewContentButton = LabelButton(type: .system, title: "더보기", titleColor: UIColor(named: "gray-700")!).then {
        $0.addTarget(self, action: #selector(clickViewContentButton), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        textFieldSetting()
        self.navigationItem.hidesBackButton = true
    }
    override func configureUI() {
        [
            logoImage,
            menuButton,
            collectionView,
            searchTextField,
            viewPetitionButton,
            writePetitionButton,
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
        menuButton.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(100)
            $0.top.equalToSuperview().inset(71)
//            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalToSuperview().inset(20)
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
        writePetitionButton.snp.makeConstraints {
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
    func textFieldSetting() {
                searchTextField.attributedPlaceholder = NSAttributedString(
                    string: "청원을 검색해보세요.",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor(named: "gray-300")!,
                        NSAttributedString.Key.font: UIFont(name: "IBMPlexSansKR-Regular", size: 12)!
                    ]
                )
    }
    @objc func clickMenuButton() {
        print("fdsjlk")
    }
    @objc func clickViewContentButton() {
        isExpanded.toggle()
        if isExpanded {
            famousPetitionContentLabel.numberOfLines = 0
        } else {
            famousPetitionContentLabel.numberOfLines = 7
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! MainCell
                  // "cell1"에 대한 데이터 설정
                  return cell
              } else {
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! ApprovedCell
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
