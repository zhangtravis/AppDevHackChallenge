//
//  LeaderboardViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/1/21.
//

import UIKit

class LeaderboardViewController: UIViewController {

    //Views
    private var titleFiller = UIView()
    private var titleView = UIView()
    private var titleLabel = UILabel()
    private var leaderboardCollectionView: UICollectionView!
    private var leaderboardData: [Leaderboard] = []
    private let leaderboardCellReuseIdentifier = "leaderboardCellReuseIdentifier"
    
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundGrey
        
        titleFiller.backgroundColor = challengeBlue
        titleFiller.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFiller)
        
        titleView.backgroundColor = challengeBlue
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        
        titleLabel.text = "Leaderboard"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let boardLayout = UICollectionViewFlowLayout()
        boardLayout.scrollDirection = .vertical
        boardLayout.minimumInteritemSpacing = 0
        boardLayout.minimumLineSpacing = 20
        leaderboardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: boardLayout)
        leaderboardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        leaderboardCollectionView.showsVerticalScrollIndicator = false
        leaderboardCollectionView.backgroundColor = .clear
        leaderboardCollectionView.register(LeaderboardCollectionViewCell.self, forCellWithReuseIdentifier: leaderboardCellReuseIdentifier)

        leaderboardCollectionView.dataSource = self
        leaderboardCollectionView.delegate = self
        view.addSubview(leaderboardCollectionView)
        
        
        setupConstraints()
        createDummyData()
    }
    func createDummyData() {
//        leaderboardData = [
//            Leaderboard(groupName: "Cornell123", players: ["P1", "P2", "P3", "P4", "P5", "P6"], completed: [10,9,8,7,6,5])
//        ]
        NetworkManager.getGlobalLeaderboard { (rankList) in
            self.leaderboardData.append(Leaderboard(groupName: "Global", rankings: rankList))
        }
        
        leaderboardCollectionView.reloadData()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 53)
        ])
        NSLayoutConstraint.activate([
            titleFiller.topAnchor.constraint(equalTo: view.topAnchor),
            titleFiller.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleFiller.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleFiller.bottomAnchor.constraint(equalTo: titleView.topAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            leaderboardCollectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            leaderboardCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leaderboardCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leaderboardCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension LeaderboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leaderboardData.count
    
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: leaderboardCellReuseIdentifier, for: indexPath) as! LeaderboardCollectionViewCell
            cell.configure(for: leaderboardData[indexPath.item])
            cell.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            
            return cell
      
    }
    
}
extension LeaderboardViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 346, height: 232)

    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
    
}
