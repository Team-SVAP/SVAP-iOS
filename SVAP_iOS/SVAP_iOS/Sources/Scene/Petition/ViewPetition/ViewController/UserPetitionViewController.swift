import UIKit
import SnapKit
import Then
import Moya

class UserPetitionViewController: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        navigationBarSetting()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPetition()
    }
    override func configureUI() {
        super.configureUI()
        
        [
            tableView
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
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
        
        leftbutton.addTarget(self, action: #selector(clickLeftBarButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
    }
    
    @objc private func clickLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func loadPetition() {
        let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggerPlugin()])
        
        provider.request(.loadUserPetition) { res in
            switch res {
                case .success(let result):
                    switch result.statusCode {
                        case 200:
                            if let data = try? JSONDecoder().decode(PetitonResponse.self, from: result.data) {
                                DispatchQueue.main.async {
                                    self.petitionList = data.map {
                                        .init(
                                            id: $0.id,
                                            title: $0.title,
                                            content: $0.content,
                                            date: $0.dateTime,
                                            location: $0.location
                                        )
                                    }
                                    self.petitionList.sort(by: { $0.id > $1.id })
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
    @objc private func pullToRefresh() {
        loadPetition()
    }
}

extension UserPetitionViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! PetitionCell
        cell.cellSetter(
            id: petitionList[indexPath.row].id,
            title: petitionList[indexPath.row].title,
            content: petitionList[indexPath.row].content,
            dateTime: petitionList[indexPath.row].date,
            location: petitionList[indexPath.row].location
        )
        cell.selectionStyle = .none
        return cell
    }
    
}
