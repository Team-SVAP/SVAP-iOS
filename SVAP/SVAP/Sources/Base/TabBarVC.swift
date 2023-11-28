import UIKit
import SnapKit
import Then

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.navigationItem.hidesBackButton = true
        self.selectedIndex = 3
    }
    
    func setup() {
        tabBar.tintColor = UIColor(named: "main-1")
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = UIColor(named: "gray-600")
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        
        let mainViewController = createNavigationController(title: "홈", image: UIImage(named: "mainMenu")!, viewController: MainViewController())
        let createPetitionViewController = createNavigationController(title: "청원 작성", image: UIImage(named: "editIcon")!, viewController: PetitionCreateViewController())
        let petitionViewController = createNavigationController(title: "청원 보기", image: UIImage(named: "peopleIcon")!, viewController: PetitionViewController())
        let myPageViewController = createNavigationController(title: "마이페이지", image: UIImage(named: "peopleIcon")!, viewController: MyPageViewController())
        
        func insets(viewcontrollers: [UIViewController]) {
            viewcontrollers.forEach({ $0.tabBarItem.imageInsets = UIEdgeInsets(top: -17, left: 0, bottom: 0, right: 0) })
        }
        
        insets(viewcontrollers: [
            mainViewController,
            createPetitionViewController,
            petitionViewController,
            myPageViewController
        ])
        
        self.setViewControllers([
            mainViewController,
            createPetitionViewController,
            petitionViewController,
            myPageViewController
        ], animated: true)
        
    }
    
    func createNavigationController(title: String, image: UIImage, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
    
}
