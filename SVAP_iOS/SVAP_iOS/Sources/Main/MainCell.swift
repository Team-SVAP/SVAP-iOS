import UIKit
import SnapKit
import Then

class MainCell: UICollectionViewCell {
    
    static let id = "Cell1"
    let cellImage = UIImageView(image: UIImage(named: "mainCell"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureUI()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        self.backgroundColor = UIColor(named: "main-8")
    }
    func configureUI() {
        [
            cellImage
        ].forEach({ contentView.addSubview($0) })
        
    }
    func setConstraints() {
        cellImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
