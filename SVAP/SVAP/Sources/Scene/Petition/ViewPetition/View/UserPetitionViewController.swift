import UIKit
import RxSwift
import RxCocoa

class UserPetitionViewController: BaseVC {
    
    private let disposeBag = DisposeBag()
    private let viewModel = UserPetitionViewModel()
    private let viewAppear = PublishRelay<Void>()
    
    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let tableView =  UITableView().then {
        $0.backgroundColor = .white
        $0.register(PetitionCell.self, forCellReuseIdentifier: "PetitionCell")
        $0.rowHeight = 92
        $0.separatorStyle = .none
    }
    private let scrollButton = ScrollButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        navigationBarSetting()
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
    override func bind() {
        super.bind()
        
        let input = UserPetitionViewModel.Input(viewAppear: viewAppear.asSignal(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        output.userPetition.bind(to: tableView.rx.items(cellIdentifier: "PetitionCell", cellType: PetitionCell.self)) { _, data, cell in
            cell.id = data.id
            cell.titleLabel.text = data.title
            cell.dateLabel.text = data.dateTime
            cell.placeLabel.text = "#\(data.types)_\(data.location)"
            cell.contentLabel.text = data.content
        }.disposed(by: disposeBag)
        
    }
    override func subscribe() {
        super.subscribe()
        
        leftbutton.rx.tap
            .subscribe(onNext: {
                self.popViewController()
            }).disposed(by: disposeBag)
        
        scrollButton.rx.tap
            .subscribe(onNext: {
                self.tableView.setContentOffset(CGPoint(x: 0, y: -65), animated: true)
            }).disposed(by: disposeBag)
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
    
}

extension UserPetitionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PetitionCell
        let vc = DetailPetitionViewController()
        
        cell.selectionStyle = .none
        PetitionIdModel.shared.id = cell.id
        self.pushViewController(vc)
    }
    
}
