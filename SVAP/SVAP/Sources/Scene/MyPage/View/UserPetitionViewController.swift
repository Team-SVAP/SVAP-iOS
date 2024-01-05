import UIKit
import RxSwift
import RxCocoa

class UserPetitionViewController: BaseVC {
    
    private let disposeBag = DisposeBag()

    private let viewModel = UserPetitionViewModel()
    private let viewAppear = PublishRelay<Void>()

    private let navigationTitleLabel = UILabel().then {
        $0.text = "내가 쓴 청원"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let tableView =  UITableView().then {
        $0.backgroundColor = .white
        $0.register(PetitionCell.self, forCellReuseIdentifier: PetitionCell.cellId)
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
            $0.top.equalToSuperview().inset(100)
            $0.left.right.bottom.equalToSuperview()
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
        
        output.userPetition.bind(to: tableView.rx.items(cellIdentifier: PetitionCell.cellId, cellType: PetitionCell.self)) { _, data, cell in
            cell.id = data.id
            cell.titleLabel.text = data.title
            cell.dateLabel.text = data.dateTime
            cell.placeLabel.text = "#\(data.types)_\(data.location)"
            cell.contentLabel.text = data.content
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PetitionModel.self)
            .subscribe(onNext: { [weak self] data in
                let vc = DetailPetitionViewController()
                PetitionIdModel.shared.id = data.id
                self?.pushViewController(vc)
            }).disposed(by: disposeBag)
        
    }
    override func subscribe() {
        super.subscribe()
        
        leftbutton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.popViewController()
            }).disposed(by: disposeBag)
        
        scrollButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.tableView.setContentOffset(CGPoint(x: 0, y: -65), animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func navigationBarSetting() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.titleView = navigationTitleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftbutton)
    }
    
}
