import UIKit
import RxSwift
import RxCocoa
import Moya

class PetitionViewController: BaseVC {
    
    private let viewModel = PetitionViewModel()
    private let disposeBag = DisposeBag()
    private let searchPetition = PublishRelay<Void>()
    private let allRecentPetition = PublishRelay<Void>()
    private let schoolRecentPetiton = PublishRelay<Void>()
    private let dormRecentPetition = PublishRelay<Void>()
    private let allVotePetition = PublishRelay<Void>()
    private let schoolVotePetition = PublishRelay<Void>()
    private let dormVotePetition = PublishRelay<Void>()
    private let allAccessPetition = PublishRelay<Void>()
    private let schoolAccessPetition = PublishRelay<Void>()
    private let dormAccessPetition = PublishRelay<Void>()
    private let allWaitPetition = PublishRelay<Void>()
    private let schoolWaitPetition = PublishRelay<Void>()
    private let dormWaitPetition = PublishRelay<Void>()
    private let selectedButtonSubject = PublishSubject<UIButton>()
    
    private let topPaddingView = UIView().then {
        $0.backgroundColor = .white
    }
    private let navigationTitleLabel = UILabel().then {
        $0.text = "청원 보기"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let searchTextField = SearchTextField(placeholder: "청원을 검색해보세요.").then {
        $0.layer.cornerRadius = 8
    }
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
        $0.isEnabled = false
    }
    private let menuButton = UIButton(type: .system).then {
        $0.setTitle("최신순", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-800"), for: .normal)
        $0.setImage(UIImage(named: "dropDownSlash"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        $0.tintColor = UIColor(named: "gray-800")
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Regular", size: 12)
    }
    private let petitionButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.backgroundColor = .clear
    }
    private let allPetitionButton = PetitionTypeButton(type: .custom, title: "전체 청원").then {
        $0.backgroundColor = .white
        $0.isSelected = true
    }
    private let schoolPetitionButton = PetitionTypeButton(type: .custom, title: "학교 청원")
    private let dormitoryPetitionButton = PetitionTypeButton(type: .custom, title: "기숙사 청원")
    private let line = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private var tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PetitionCell.self, forCellReuseIdentifier: "PetitionCell")
        $0.rowHeight = 92
        $0.separatorStyle = .none
    }
    private let scrollButton = ScrollButton(type: .system)
    private let bottomPaddingView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var buttonArray = [allPetitionButton, schoolPetitionButton, dormitoryPetitionButton]
    
    public func setter(
        petitionTitle: String
    ) {
        searchTextField.text = petitionTitle
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    static let sharedText = BehaviorRelay<String>(value: "")
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        PetitionViewController.sharedText
            .bind(to: searchTextField.rx.text)
            .disposed(by: disposeBag)
        if searchTextField.text!.isEmpty == true {
            self.allRecentPetition.accept(())
        } else {
            self.searchPetition.accept(())
        }
    }
    override func configureUI() {
        super.configureUI()
        [
            navigationTitleLabel,
            searchTextField,
            menuButton,
            petitionButtonStackView,
            line,
            tableView,
            scrollButton,
            bottomPaddingView
        ].forEach({ view.addSubview($0) })
        searchTextField.addSubview(searchButton)
        [ allPetitionButton, schoolPetitionButton, dormitoryPetitionButton].forEach({
            petitionButtonStackView.addArrangedSubview($0)
        })

    }
    override func setupConstraints() {
        super.setupConstraints()

        navigationTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(59)
        }
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(97)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        menuButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(20)
        }
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
        petitionButtonStackView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
            $0.height.equalTo(14)
        }
        line.snp.makeConstraints {
            $0.top.equalTo(petitionButtonStackView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(24.25)
            $0.left.right.bottom.equalToSuperview()
        }
        scrollButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(30)
            $0.width.height.equalTo(60)
        }
        bottomPaddingView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(82)
            $0.height.equalTo(90)
        }

    }
    override func bind() {
        super.bind()
        
        let input = PetitionViewModel.Input(
            petitonTitle: searchTextField.rx.text.orEmpty.asDriver(),
            searchPetition: searchPetition.asSignal(),
            allRecentPetition: allRecentPetition.asSignal(),
            schoolRecentPetiton: schoolRecentPetiton.asSignal(),
            dormRecentPetition: dormRecentPetition.asSignal(),
            allVotePetition: allVotePetition.asSignal(),
            schoolVotePetition: schoolVotePetition.asSignal(),
            dormVotePetition: dormVotePetition.asSignal(),
            allAccessPetition: allAccessPetition.asSignal(),
            schoolAccessPetition: schoolAccessPetition.asSignal(),
            dormAccessPetition: dormAccessPetition.asSignal(),
            allWaitPetition: allWaitPetition.asSignal(),
            schoolWaitPetition: schoolWaitPetition.asSignal(),
            dormWaitPetition: dormWaitPetition.asSignal()
        )
        
        let output = viewModel.transform(input)
        
        output.petition.bind(to: tableView.rx.items(cellIdentifier: "PetitionCell", cellType: PetitionCell.self)) { _, item, cell in
            cell.id = item.id
            cell.titleLabel.text = item.title
            cell.dateLabel.text = item.dateTime
            cell.placeLabel.text = "#\(item.types)_\(item.location)"
            cell.contentLabel.text = item.content
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)

    }
    override func subscribe() {
        super.subscribe()
        
        searchButton.rx.tap
            .subscribe(onNext: {
                self.searchPetition.accept(())
            }).disposed(by: disposeBag)
        
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

        for button in buttonArray {
            button.rx.tap
                .map { button }
                .bind(to: selectedButtonSubject)
                .disposed(by: disposeBag)
        }
        
        selectedButtonSubject
            .subscribe(onNext: { selectedButton in
                for button in self.buttonArray {
                    button.isSelected = (button == selectedButton)
                }
            })
            .disposed(by: disposeBag)

        allPetitionButton.rx.tap
            .subscribe(onNext: { [self] in
                selectedMenu(recent: allRecentPetition,
                             vote: allVotePetition,
                             access: allAccessPetition,
                             wait: allWaitPetition)
            }).disposed(by: disposeBag)
        
        schoolPetitionButton.rx.tap
            .subscribe(onNext: { [self] in
                selectedMenu(recent: schoolRecentPetiton,
                             vote: schoolVotePetition,
                             access: schoolAccessPetition,
                             wait: schoolWaitPetition)
            }).disposed(by: disposeBag)

        dormitoryPetitionButton.rx.tap
            .subscribe(onNext: { [self] in
                selectedMenu(recent: dormRecentPetition,
                             vote: dormVotePetition,
                             access: dormAccessPetition,
                             wait: dormWaitPetition)
            }).disposed(by: disposeBag)

        scrollButton.rx.tap
            .subscribe(onNext: {
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }).disposed(by: disposeBag)
        
        let menu = UIMenu(title: "청원 정렬",
                          children: items)
        
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }

    var items: [UIAction] {
        
        let recent = UIAction(
            title: "최신순",
            handler: { [unowned self] _ in
                selectedButton(all: allRecentPetition, school: schoolRecentPetiton, dorm: dormRecentPetition)
                self.menuButton.setTitle("최신순", for: .normal)
            })
        
        let vote = UIAction(
            title: "투표순",
            handler: { [unowned self] _ in
                selectedButton(all: allVotePetition, school: schoolVotePetition, dorm: dormVotePetition)
                self.menuButton.setTitle("투표순", for: .normal)
            })
        
        let access = UIAction(
            title: "승인된 청원",
            handler: { [unowned self] _ in
                selectedButton(all: allAccessPetition, school: schoolAccessPetition, dorm: dormAccessPetition)
                self.menuButton.setTitle("승인된 청원", for: .normal)
            })
        
        let wait = UIAction(
            title: "검토중인 청원",
            handler: { [unowned self] _ in
                selectedButton(all: allWaitPetition, school: schoolWaitPetition, dorm: dormWaitPetition)
                self.menuButton.setTitle("검토중인 청원", for: .normal)
            })
        
        let Items = [recent, vote, access, wait]
        
        return Items
    }
    
    func selectedMenu(
        recent: PublishRelay<Void>,
        vote: PublishRelay<Void>,
        access: PublishRelay<Void>,
        wait: PublishRelay<Void>
    ) {
        if menuButton.title(for: .normal) == "최신순" {
            recent.accept(())
        } else if menuButton.title(for: .normal) == "투표순" {
            vote.accept(())
        } else if menuButton.title(for: .normal) == "승인된 청원" {
            access.accept(())
        } else {
            wait.accept(())
        }
    }
    func selectedButton(
        all: PublishRelay<Void>,
        school: PublishRelay<Void>,
        dorm: PublishRelay<Void>
    ) {
        if allPetitionButton.isSelected == true {
            all.accept(())
        } else if schoolPetitionButton.isSelected == true {
            school.accept(())
        } else {
            dorm.accept(())
        }
    }
    
}

extension PetitionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PetitionCell
        let vc = DetailPetitionViewController()
        vc.hidesBottomBarWhenPushed = true
        PetitionIdModel.shared.id = cell.id
        self.pushViewController(vc)
    }
    
}
