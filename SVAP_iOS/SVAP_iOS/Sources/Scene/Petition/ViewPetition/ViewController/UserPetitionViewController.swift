import UIKit
import SnapKit
import Then
import Moya

class UserPetitionViewController: BaseVC {
    
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
        navigationBarSetting()
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
            $0.left.right.bottom.equalToSuperview()
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
}
