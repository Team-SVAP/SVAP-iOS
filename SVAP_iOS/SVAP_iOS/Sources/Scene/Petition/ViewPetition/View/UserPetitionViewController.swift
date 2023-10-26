import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Moya

class UserPetitionViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = UserPetitionViewModel()
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
    private let tableView =  UITableView().then {
        $0.backgroundColor = .white
        $0.register(PetitionCell.self, forCellReuseIdentifier: "CellID")
        $0.rowHeight = 92
        $0.separatorStyle = .none
    }
    private let scrollButton = ScrollButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        navigationBarSetting()

        tableView.refreshControl = refreshControl
    }
    override func viewWillAppear(_ animated: Bool) {
        viewAppear.accept(())
    }
    override func configureUI() {
        super.configureUI()
        
        [
            tableView,
            scrollButton
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
        scrollButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().inset(30)
            $0.width.height.equalTo(60)
        }
    }
    
    private func navigationBarSetting() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "내가 쓴 청원"
        title.textColor = UIColor(named: "gray-800")
        title.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        title.textAlignment = .center
        navigationItem.titleView = title
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
    }
    
//    private func loadPetition() {
//        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
//        
//        provider.request(.loadUserPetition) { res in
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
//        
//    }
    override func bind() {
        super.bind()
        
        let input = UserPetitionViewModel.Input(viewAppear: viewAppear.asSignal(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        output.userPetition.bind(to: tableView.rx.items(cellIdentifier: "PetitionCell", cellType: PetitionCell.self)) { row, data, cell in
            cell.id = data.id!
            cell.titleLabel.text = data.title
            cell.dateLabel.text = data.dateTime
            cell.placeLabel.text = data.location
            cell.contentLabel.text = data.content
            self.tableView.delegate = nil
        }.disposed(by: disposeBag)
    }
    override func subscribe() {
        super.subscribe()
        
        leftbutton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.bind()
            }).disposed(by: disposeBag)
        
        scrollButton.rx.tap
            .subscribe(onNext: {
                self.tableView.setContentOffset(CGPoint(x: 0, y: -65), animated: true)
            }).disposed(by: disposeBag)
    }
    
}

extension UserPetitionViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionList.count
    }
    
//    func test() {
//        tableView.rx.cell
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! PetitionCell
//        cell.cellSetter(
//            id: petitionList[indexPath.row].id,
//            title: petitionList[indexPath.row].title,
//            content: petitionList[indexPath.row].content,
//            dateTime: petitionList[indexPath.row].date,
//            location: petitionList[indexPath.row].location
//        )
//        cell.selectionStyle = .none
//        return cell
//    }
    
}
