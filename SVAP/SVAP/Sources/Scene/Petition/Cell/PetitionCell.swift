import UIKit
import SnapKit
import Then

class PetitionCell: UITableViewCell {
    
    static let cellId = "PetitionCell"
    var id: Int = 0
    let titleLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    let dateLabel = UILabel().then {
        $0.textColor = UIColor(named: "gray-800")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 10)
    }
    let placeLabel = UILabel().then {
        $0.textColor = UIColor(named: "main-4")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 12)
    }
    let contentLabel = UILabel().then {
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
        contentViewSetting()
        configureUI()
        setupConstraints()
    }
    
    func contentViewSetting() {
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 12, right: 20))
    }
    func configureUI() {
        [
            titleLabel,
            dateLabel,
            placeLabel,
            contentLabel
        ].forEach({ contentView.addSubview($0) })
    }
    func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(13)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(12)
        }
        placeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.left.equalToSuperview().inset(13)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(2)
            $0.left.right.equalToSuperview().inset(13)
        }
    }
}
