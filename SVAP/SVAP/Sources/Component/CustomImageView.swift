import UIKit

class CustomImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = UIColor(named: "gray-100")
        self.layer.cornerRadius = 8
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
}
