import UIKit

class PetitionViewController: BaseVC {
    
    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let searchTextField = SearchTextField(placeholder: "청원을 검색해보세요.")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "searchIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-600")
    }
    private let line = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .gray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
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
    @objc private func clickLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    override func configureUI() {
        super.configureUI()
        [
            searchTextField,
            line,
            tableView,
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
            $0.top.equalToSuperview().inset(175)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
