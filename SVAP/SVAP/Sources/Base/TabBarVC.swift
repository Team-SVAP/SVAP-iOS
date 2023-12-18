import UIKit
import SnapKit
import Then

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.navigationItem.hidesBackButton = true
        self.selectedIndex = 1
    }
    
    func setup() {
        tabBar.tintColor = UIColor(named: "main-1")
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = UIColor(named: "gray-600")
        tabBar.backgroundColor = .white

        let mainViewController = MainViewController()
        let createPetitionViewController = UINavigationController(rootViewController: PetitionCreateViewController())
//        let createPetitionViewController = PetitionCreateViewController()
        let petitionViewController = PetitionViewController()
        let myPageViewController = MyPageViewController()

        let tabItem1 = UITabBarItem(
            title: "홈",
            image: UIImage(named: "mainMenu")!,
            selectedImage: nil
        )
        let tabItem2 = UITabBarItem(
            title: "청원 작성",
            image: UIImage(named: "editIcon")!,
            selectedImage: nil
        )
        let tabItem3 = UITabBarItem(
            title: "청원 보기",
            image: UIImage(named: "peopleIcon")!,
            selectedImage: nil
        )
        let tabItem4 = UITabBarItem(
            title: "마이페이지",
            image: UIImage(named: "personIcon")!,
            selectedImage: nil
        )

        mainViewController.tabBarItem = tabItem1
        createPetitionViewController.tabBarItem = tabItem2
        petitionViewController.tabBarItem = tabItem3
        myPageViewController.tabBarItem = tabItem4

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
    
}
