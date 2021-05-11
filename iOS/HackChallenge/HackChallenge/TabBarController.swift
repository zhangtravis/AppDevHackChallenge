//
//  TabBarController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/1/21.
//


import UIKit

class PlayerData {
    var id = -1
    var username = ""
    var password = ""
    var login = false
    var image = UIImage(named: "player.png")
}

class TabBarController: UITabBarController {
    var player = PlayerData()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 4
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewControllers = [homeTabBar, searchTabBar, challengeTabBar, leaderboardTabBar, profileTabBar]
    }
    
    lazy public var homeTabBar: ViewController = {
        
        let homeTabBar = ViewController()
        
        let title = "Home"
        
        let defaultImage = UIImage(named: "home.png")!
        
        let selectedImage = UIImage(named: "home.png")!
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)

        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        homeTabBar.tabBarItem = tabBarItem

        return homeTabBar
    }()
    
    lazy public var searchTabBar: SearchViewController = {
        
        let searchTabBar = SearchViewController()
        
        let title = "Search"
        
        let defaultImage = UIImage(named: "search.png")!
        
        let selectedImage = UIImage(named: "search.png")!
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)

        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        searchTabBar.tabBarItem = tabBarItem

        return searchTabBar
    }()
    
    lazy public var challengeTabBar: ChallengeViewController = {
        
        let challengeTabBar = ChallengeViewController()
        
        let title = "Challenge"
        
        let defaultImage = UIImage(named: "challenge.png")!
        
        let selectedImage = UIImage(named: "challenge.png")!
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)

        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        challengeTabBar.tabBarItem = tabBarItem

        return challengeTabBar
    }()
    
    lazy public var leaderboardTabBar: LeaderboardViewController = {
        
        let leaderboardTabBar = LeaderboardViewController()
        
        let title = "Leaderboard"
        
        let defaultImage = UIImage(named: "leaderboard.png")!
        
        let selectedImage = UIImage(named: "leaderboard.png")!
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)

        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        leaderboardTabBar.tabBarItem = tabBarItem

        return leaderboardTabBar
    }()
    
    lazy public var profileTabBar: ProfileViewController = {
        
        let profileTabBar = ProfileViewController()
        
        let title = "Profile"
        
        let defaultImage = UIImage(named: "profile.png")
        
        let selectedImage = UIImage(named: "profile.png")
        
        let tabBarItems = (title: title, image: defaultImage, selectedImage: selectedImage)

        let tabBarItem = UITabBarItem(title: tabBarItems.title, image: tabBarItems.image, selectedImage: tabBarItems.selectedImage)
        
        profileTabBar.tabBarItem = tabBarItem
        
        return profileTabBar
    }()

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    
}

//extension TabBarController: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected \(viewController.title!)")
//    }
//
//}
