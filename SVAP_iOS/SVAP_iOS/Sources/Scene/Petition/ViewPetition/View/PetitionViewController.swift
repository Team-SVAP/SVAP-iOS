import UIKit
import RxSwift
import RxCocoa
import Moya

class PetitionViewController: BaseVC {
    
//    let viewModel = PetitionViewModel()
    private let disposeBag = DisposeBag()
    private let viewAppear = PublishRelay<Void>()
    
    
    private var petitionList: [PetitionModel] = [] {
        didSet {
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    private let refreshControl = UIRefreshControl()
    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let searchTextField = SearchTextField(placeholder: "청원을 검색해보세요.").then {
        $0.layer.cornerRadius = 8
    }
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let menuButton = UIButton(type: .system).then {
        $0.setTitle("최신순으로 보기", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-800"), for: .normal)
        $0.setImage(UIImage(named: "miniLeftArrow"), for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.imageEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        $0.tintColor = UIColor(named: "gray-800")
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    private let petitionButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.backgroundColor = .clear
    }
    private let allPetitionButton = PetitionTypeButton(type: .system, title: "전체 청원")
    private let schoolPetitionButton = PetitionTypeButton(type: .system, title: "학교 청원")
    private let dormitoryPetitionButton = PetitionTypeButton(type: .system, title: "기숙사 청원")
    private let line = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PetitionCell.self, forCellReuseIdentifier: "PetitionCell")
        $0.rowHeight = 92
        $0.separatorStyle = .none
    }
    private let scrollButton = ScrollButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        self.navigationItem.hidesBackButton = false
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }
    override func viewWillAppear(_ animated: Bool) {
//        loadPetition()
        viewAppear.accept(())
        tableView.reloadData()
    }
    private func navigationBarSetting() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "청원 보기"
        title.textColor = UIColor(named: "gray-800")
        title.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        title.textAlignment = .center
        navigationItem.titleView = title
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
    }
    override func configureUI() {
        super.configureUI()
        [
            searchTextField,
            menuButton,
            petitionButtonStackView,
            line,
            tableView,
            scrollButton
        ].forEach({ view.addSubview($0) })
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
            $0.top.equalTo(searchTextField.snp.bottom).offset(6)
            $0.left.equalToSuperview().inset(20)
        }
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
        petitionButtonStackView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(14)
        }
        line.snp.makeConstraints {
            $0.top.equalTo(petitionButtonStackView.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(24.25)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
        scrollButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(30)
            $0.width.height.equalTo(60)
        }
    }
//    override func bind() {
//        super.bind()
//        
//        let input = PetitionViewModel.Input(viewAppear: viewAppear.asSignal(onErrorJustReturn: ()))
//        let output = viewModel.transform(input)
//        
//        output.petition.bind(to: tableView.rx.items(cellIdentifier: "PetitionCell", cellType: PetitionCell.self)) { row, item, cell in
//            cell.id = item.id
//            cell.titleLabel.text = item.title
//            cell.dateLabel.text = item.dateTime
//            cell.placeLabel.text = item.location
//            cell.contentLabel.text = item.content
//        }.disposed(by: disposeBag)
//            
//    }

    override func subscribe() {
        searchButton.rx.tap
            .subscribe(onNext: {
//                self.searchPetition()
            }).disposed(by: disposeBag)
        
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
//                self.loadPetition()
                self.bind()
            }).disposed(by: disposeBag)
        
        schoolPetitionButton.rx.tap
            .subscribe(onNext: {
//                self.loadTypePetition("SCHOOL")
                self.buttonColor(all: UIColor(named: "gray-400"), school: UIColor(named: "main-1"), dormitory: UIColor(named: "gray-400"))
            }).disposed(by: disposeBag)
        
        dormitoryPetitionButton.rx.tap
            .subscribe(onNext: {
//                self.loadTypePetition("DORMITORY")
                self.buttonColor(all: UIColor(named: "gray-400"), school: UIColor(named: "gray-400"), dormitory: UIColor(named: "main-1"))
            }).disposed(by: disposeBag)
        
        leftbutton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
//                self.loadPetition()
                self.bind()
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
//    private func loadPetition() {
//        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
//        self.buttonColor(all: UIColor(named: "main-1"), school: UIColor(named: "gray-400"), dormitory: UIColor(named: "gray-400"))
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
//    private func searchPetition() {
//        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
//        
//        provider.request(.searchPetition(title: searchTextField.text!)) { res in
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
//    private func loadTypePetition(_ type: String) {
//        
//        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
//        
//        provider.request(.loadRecentPetition(type: type)) { res in
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
    
}
//
//extension PetitionViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return petitionList.count
//    }
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "PetitionCell", for: indexPath) as! PetitionCell
////        cell.cellSetter(
////            id: petitionList[indexPath.row].id,
////            title: petitionList[indexPath.row].title,
////            content: petitionList[indexPath.row].content,
////            dateTime: petitionList[indexPath.row].date,
////            location: petitionList[indexPath.row].location
////        )
////        cell.selectionStyle = .none
////        //MARK: -클릭 이벤트 추후에 수정하기
////        return cell
////    }
//    func test() {
//        
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        clickCell()
//        self.navigationController?.pushViewController(DetailPetitionViewController(), animated: true)
//        
//    }
//    
//    func clickCell() {
//        //        self.dismiss(animated: true, completion: { self.userDetailPetition() })
//    }
//}
