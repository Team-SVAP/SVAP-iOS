import UIKit

class SideMenu: BaseVC {
    
    private let sideMenuView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.clipsToBounds = true
    }
    private let settingButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "settingIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let closeViewButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "closeIcon"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
        $0.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .separator
        
    }
    override func configureUI() {
        super.configureUI()
        view.addSubview(sideMenuView)
        [
            settingButton,
            closeViewButton
        ].forEach({ sideMenuView.addSubview($0) })
    }
    override func setupConstraints() {
        sideMenuView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(190)
            $0.right.equalToSuperview()
        }
        closeViewButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(34)
        }
        settingButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
            $0.width.height.equalTo(30)
        }
    }
    
    @objc func clickCloseButton() {
        self.dismiss(animated: true)
    }
}
