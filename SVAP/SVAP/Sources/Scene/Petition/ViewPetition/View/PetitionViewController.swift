import UIKit
import RxSwift
import RxCocoa
import Moya

class PetitionViewController: BaseVC {
    
    let viewModel = PetitionViewModel()
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
    private let allPetitionButton = PetitionTypeButton(type: .system, title: "전체 청원").then {
        $0.setTitleColor(UIColor(named: "main-1"), for: .normal)
    }
    private let schoolPetitionButton = PetitionTypeButton(type: .system, title: "학교 청원")
    private let dormitoryPetitionButton = PetitionTypeButton(type: .system, title: "기숙사 청원")
    private let line = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private var tableView = UITableView().then {
        $0.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .white
        $0.register(PetitionCell.self, forCellReuseIdentifier: "PetitionCell")
        $0.rowHeight = 92
        $0.separatorStyle = .none
    }
    private let scrollButton = ScrollButton(type: .system)
    private let bottomPaddingView = UIView().then {
        $0.backgroundColor = .white
    }
    
    public func setter(
        petitionTitle: String,
        searchAccept: Void
    ) {
        searchTextField.text = petitionTitle
        searchPetition.accept(searchAccept)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        allRecentPetition.accept(())
    }
    override func configureUI() {
        super.configureUI()
        [
            topPaddingView,
            searchTextField,
            menuButton,
            petitionButtonStackView,
            line,
            tableView,
            scrollButton,
            bottomPaddingView
        ].forEach({ view.addSubview($0) })
        topPaddingView.addSubview(navigationTitleLabel)
        searchTextField.addSubview(searchButton)
        [ allPetitionButton, schoolPetitionButton, dormitoryPetitionButton].forEach({
            petitionButtonStackView.addArrangedSubview($0)
        })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
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
            doneTap: searchButton.rx.tap.asSignal(),
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
                    self.searchButton.isEnabled = false
                } else {
                    self.searchButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
        
        //MARK: 텍스트가 아닌 PublishRelay를 보내주는 방식으로 바꾸기?
        menuButton.rx.tap
            .subscribe(onNext: {
                let petitionClosure = UINavigationController(rootViewController: PetitionMenu(closure: {
                    self.menuButton.setTitle($0, for: .normal)
                }))
                petitionClosure.modalPresentationStyle = .overFullScreen
                petitionClosure.modalTransitionStyle = .crossDissolve
                self.present(petitionClosure, animated: true)
            }).disposed(by: disposeBag)
        
        allPetitionButton.rx.tap
            .subscribe(onNext: {
                if self.menuButton.titleLabel?.text == "투표순으로 보기" {
                    self.allVotePetition.accept(())
                } else if self.menuButton.titleLabel?.text == "승원된 청원 보기" {
                    self.allAccessPetition.accept(())
                } else if self.menuButton.titleLabel?.text == "검토중인 청원 보기" {
                    self.allWaitPetition.accept(())
                } else {
                    self.allRecentPetition.accept(())
                }
                self.buttonColor(all: UIColor(named: "main-1"), school: UIColor(named: "gray-400"), dormitory: UIColor(named: "gray-400"))
            }).disposed(by: disposeBag)
        
        schoolPetitionButton.rx.tap
            .subscribe(onNext: {
                if self.menuButton.titleLabel?.text == "투표순으로 보기" {
                    self.schoolVotePetition.accept(())
                } else if self.menuButton.titleLabel?.text == "승원된 청원 보기" {
                    self.schoolAccessPetition.accept(())
                } else if self.menuButton.titleLabel?.text == "검토중인 청원 보기" {
                    self.schoolWaitPetition.accept(())
                } else {
                    self.schoolRecentPetiton.accept(())
                }
                self.buttonColor(all: UIColor(named: "gray-400"), school: UIColor(named: "main-1"), dormitory: UIColor(named: "gray-400"))
            }).disposed(by: disposeBag)
        
        dormitoryPetitionButton.rx.tap
            .subscribe(onNext: {
                if self.menuButton.titleLabel?.text == "투표순으로 보기" {
                    self.dormVotePetition.accept(())
                } else if self.menuButton.titleLabel?.text == "승원된 청원 보기" {
                    self.dormAccessPetition.accept(())
                } else if self.menuButton.titleLabel?.text == "검토중인 청원 보기" {
                    self.dormWaitPetition.accept(())
                } else {
                    self.dormRecentPetition.accept(())
                }
                self.buttonColor(all: UIColor(named: "gray-400"), school: UIColor(named: "gray-400"), dormitory: UIColor(named: "main-1"))
            }).disposed(by: disposeBag)
        
        scrollButton.rx.tap
            .subscribe(onNext: {
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }).disposed(by: disposeBag)
    }
    func buttonColor(all: UIColor!, school: UIColor!, dormitory: UIColor!) {
        allPetitionButton.setTitleColor(all, for: .normal)
        schoolPetitionButton.setTitleColor(school, for: .normal)
        dormitoryPetitionButton.setTitleColor(dormitory, for: .normal)
    }
    
}

extension PetitionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PetitionCell
        let vc = DetailPetitionViewController()
        vc.hidesBottomBarWhenPushed = true
        cell.selectionStyle = .none
        PetitionIdModel.shared.id = cell.id
        self.pushViewController(vc)
    }

}
