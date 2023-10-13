import Foundation
import UIKit

extension UIViewController {
    
    func pushViewController(_ viewController: UIViewController) {
        let vc = viewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
