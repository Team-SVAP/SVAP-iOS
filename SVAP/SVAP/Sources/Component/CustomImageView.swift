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
        self.layer.border(UIColor(named: "gray-400")!, 0.5)
        self.layer.cornerRadius = 8
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
}
