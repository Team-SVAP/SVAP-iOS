import UIKit


class CustomMenu: BaseVC {
    
    let schoolPetitionButton = UIButton(type: .system).then {
        $0.setTitle("학교 청원", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    let dormitoryPetitionButton = UIButton(type: .system).then {
        $0.setTitle("학교 청원", for: .normal)
        $0.setTitleColor(UIColor(named: "gray-700"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureUI() {
        super.configureUI()
        [
            schoolPetitionButton,
            dormitoryPetitionButton
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        schoolPetitionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.left.equalToSuperview().inset(12)
        }
        dormitoryPetitionButton.snp.makeConstraints {
            $0.top.equalTo(schoolPetitionButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(12)
        }
    }

}
