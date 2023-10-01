import UIKit
import SnapKit
import Then

class PetitionCell: UITableViewCell {
    
    static let cellId = "CellID"
    let petitionTitleLabel = UILabel().then {
        $0.text = "새롬홀 의자 너무 딱딱해요ㅜㅜㅜ"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        
    }
    let dateLabel = UILabel().then {
        $0.text = "2023-09-17"
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 10)
    }
    let placeLabel = UILabel().then {
        $0.text = "#학교_새롬홀"
        $0.textColor = UIColor(named: "main-4")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    let contentLabel = UILabel().then {
        $0.text = "현재 우리나라는 김대중 전 대통령 때부터 사형 집행이 중지되었습니다.. 그러다 보니 사형이라고 재판에서 판결을 내려도 피해자 및 뉴스를 보는 국민들 입장.."
        $0.textColor = UIColor(named: "gray-600")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 8)
        $0.numberOfLines = 2
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        self.layer.borderColor = UIColor(named: "main-4")?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        configureUI()
        setupConstraints()
    }
    
    func configureUI() {
        [
            petitionTitleLabel,
            dateLabel,
            placeLabel,
            contentLabel
        ].forEach({ contentView.addSubview($0) })
    }
    func setupConstraints() {
        
        petitionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(13)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(12)
        }
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(petitionTitleLabel.snp.bottom).offset(2)
            $0.left.equalToSuperview().inset(13)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(2)
            $0.left.right.equalToSuperview().inset(13)
        }
    }
}
