import UIKit
import Moya

class PetitionViewController: BaseVC {
    
    private var petitionList: [PetitionModel] = [] {
        didSet {
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    private let refreshControl = UIRefreshControl()
    //계속 로딩이 됨
    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let searchTextField = SearchTextField(placeholder: "청원을 검색해보세요.").then {
        $0.layer.cornerRadius = 8
    }
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-600")
    }
    private let line = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PetitionCell.self, forCellReuseIdentifier: "CellID")
        $0.rowHeight = 92
        $0.separatorStyle = .none
    }
    private let scrollButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "upArrow"), for: .normal)
        $0.backgroundColor = UIColor(named: "main-3")
        $0.tintColor = .white
        $0.layer.cornerRadius = 30
        $0.addTarget(self, action: #selector(clickScrollButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        self.navigationItem.hidesBackButton = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        loadPetition()
    }
    private func navigationBarSetting() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "청원 보기"
        title.textColor = UIColor(named: "gray-800")
        title.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        title.textAlignment = .center
        navigationItem.titleView = title
        navigationItem.hidesBackButton = true
        
        leftbutton.addTarget(self, action: #selector(clickLeftBarButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
    }
    override func configureUI() {
        super.configureUI()
        [
            searchTextField,
            line,
            tableView,
            scrollButton
        ].forEach({ view.addSubview($0) })
        searchTextField.addSubview(searchButton)
    }
    override func setupConstraints() {
        super.setupConstraints()
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(97)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
        line.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(37.75)
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
    private func loadPetition() {
        let provider = MoyaProvider<PetitionAPI>(plugins: [MoyaLoggerPlugin()])
        
        provider.request(.loadAllRecentPetitoin) { res in
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
    
    @objc private func clickLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func pullToRefresh() {
        loadPetition()
    }
    @objc private func clickScrollButton() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension PetitionViewController: UITableViewDelegate, UITableViewDataSource {
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
        //MARK: -클릭 이벤트 추후에 수정하기
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailPetitionViewController(), animated: true)
    }
}
