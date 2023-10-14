import UIKit

class DetailPetitionViewController: BaseVC {
    
    private let leftbutton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
        $0.tintColor = UIColor(named: "gray-700")
    }
    private let tagLabel = UILabel().then {
        $0.text = "# 기숙사_화장실"
        $0.textColor = UIColor(named: "main-1")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let titleLabel = UILabel().then {
        $0.text = "사형 제도 부활을 건의합니다."
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
    }
    private let dateLabel = UILabel().then {
        $0.text = "2023-09-16"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 12)
    }
    private let topLineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let contentLabel = UILabel().then {
        $0.text = "현재 우리나라는 김대중 전 대통령 때부터 사형 집행이 중지되었습니다.. 그러다 보니 사형이라고 재판에서 판결을 내려도 피해자 및 뉴스를 보는 국민들 입장에서는 무늬만 사형이지 가석방 없는 무기징역하고 뭐가 다르냐 라는 생각을 가질 수 밖에 없습니다.. 또한 사형이 집행되지 않다보니 요즘 흉악한 범죄를 저지르는 범죄자들이 많이 양산되고 있는 것이 현실입니다... 물론 국민이라면 인권 존중되어야 합니다. 그러나 이렇게 극악무도한 범죄를 저지른 자에 한해서는 가중처벌이 형성되야 합니다. 여기서 말하는 가중처벌이란 사형 집행일 것입니다.. 개인적으로 사형 제도가 부활하면 극악무도한 범죄자들이 줄어들 것이라 봅니다. 아니 줄어들던 그대로 똑같던 이것이 중요한 것이 아니라 조금이나마 피해자의 마음을 어루만져주기 위해서는 사형 집행이 실현 되어야 합니다. 이렇게 되는 것이 정의구현"
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let bottomLineView = UIView().then {
        $0.backgroundColor = UIColor(named: "gray-200")
    }
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "testImage")
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        navigationBarSetting()
    }
    override func configureUI() {
        super.configureUI()
        
        [
            tagLabel,
            titleLabel,
            dateLabel,
            topLineView,
            contentLabel,
            bottomLineView,
            imageView
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(99)
            $0.left.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(tagLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview().inset(20)
        }
        topLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
        }
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.bottom).offset(13)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(250)
        }
    }
    private func navigationBarSetting() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "상세보기"
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
