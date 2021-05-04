//
//  ViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/1/21.
//

import UIKit

class ViewController: UIViewController {
    // Views
    private var currentCollectionView: UICollectionView!
    private var pastCollectionView: UICollectionView!
    private var titleFiller = UIView()
    private var titleView = UIView()
    private var titleLabel = UILabel()
    private var currentTitleLabel = UILabel()
    private var pastTitleLabel = UILabel()

    
    // Data
    private var currentChallenges: [CurrentChallenge] = []
    private var pastChallenges: [PastChallenge] = []
    private var sections: [String] = []

    // Constants
    private let currentChallengeCellReuseIdentifier = "currentChallengeCellReuseIdentifier"
    private let pastChallengesCellReuseIdentifier = "pastChallengesCellReuseIdentifier"
    private let homeHeaderReuseIdentifier = "homeHeaderReuseIdentifier"
    private let cellPadding: CGFloat = 20
    private let sectionPadding: CGFloat = 4
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundGrey
        
        titleFiller.backgroundColor = challengeBlue
        titleFiller.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFiller)
        
        titleView.backgroundColor = challengeBlue
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        
        titleLabel.text = "Challenge With Friends"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        currentTitleLabel.text = "CURRENT CHALLENGES"
        currentTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        currentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentTitleLabel)
        
        pastTitleLabel.text = "PAST CHALLENGES"
        pastTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        pastTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pastTitleLabel)
        
        sections = ["CURRENT CHALLENGES", "PAST CHALLENGES"]
        currentChallenges = [
            CurrentChallenge(title: "Make An App", description: "Make any app and share it with your friends", sender: "John Doe"),
            CurrentChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "John Doe")
        ]
        pastChallenges = [
            PastChallenge(title: "Climb Mount Everast", image: Image(withImage: UIImage(named: "mountain.png")!), description: "This is gonna be a super long message. Gotta test the spacing.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "A Person", upvotes: 0, downvotes: 0),
            PastChallenge(title: "Climb Mount Everast", image: Image(withImage: UIImage(named: "mountain.png")!), description: "This is gonna be a super long message. Gotta test the spacing.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "A Person", upvotes: 1, downvotes: 0)
        ]
        
        // Setup flow layout
        let currentLayout = UICollectionViewFlowLayout()
        currentLayout.scrollDirection = .horizontal
        currentLayout.minimumInteritemSpacing = cellPadding
        currentLayout.minimumLineSpacing = cellPadding
        currentLayout.sectionInset = UIEdgeInsets(top: sectionPadding, left: 0, bottom: sectionPadding, right: 0)
        
        let pastLayout = UICollectionViewFlowLayout()
        pastLayout.scrollDirection = .vertical
        pastLayout.minimumInteritemSpacing = cellPadding
        pastLayout.minimumLineSpacing = cellPadding
        pastLayout.sectionInset = UIEdgeInsets(top: sectionPadding, left: 0, bottom: sectionPadding, right: 0)
        
        // Instantiate collectionView
        currentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: currentLayout)
        currentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        currentCollectionView.showsHorizontalScrollIndicator = false
        currentCollectionView.backgroundColor = .clear
        
        pastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: pastLayout)
        pastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pastCollectionView.showsVerticalScrollIndicator = false
        pastCollectionView.backgroundColor = .clear
        
        // Create collection view cell and register it here.
        // Add content to collection view cell.
        // Create function to configure collection view cell.
        currentCollectionView.register(CurrentChallengeCollectionViewCell.self, forCellWithReuseIdentifier: currentChallengeCellReuseIdentifier)
        pastCollectionView.register(PastChallengesCollectionViewCell.self, forCellWithReuseIdentifier: pastChallengesCellReuseIdentifier)
        
        
        // Extend collection view data source.
        currentCollectionView.dataSource = self
        pastCollectionView.dataSource = self

        // Extend collection view delegate.
        currentCollectionView.delegate = self
        pastCollectionView.delegate = self
        
        
        view.addSubview(currentCollectionView)
        view.addSubview(pastCollectionView)
        setupConstraints()
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
            currentTitleLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            currentTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])

        let collectionViewPadding: CGFloat = 16
        NSLayoutConstraint.activate([
            currentCollectionView.topAnchor.constraint(equalTo: currentTitleLabel.bottomAnchor, constant: 20),
            currentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            currentCollectionView.heightAnchor.constraint(equalToConstant: 135),
            currentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])
        NSLayoutConstraint.activate([
            pastTitleLabel.topAnchor.constraint(equalTo: currentCollectionView.bottomAnchor, constant: 20),
            pastTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            pastCollectionView.topAnchor.constraint(equalTo: pastTitleLabel.bottomAnchor, constant: 20),
            pastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            pastCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -collectionViewPadding),
            pastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])

    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == currentCollectionView {
            return currentChallenges.count
        }
        else {
            return pastChallenges.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == currentCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentChallengeCellReuseIdentifier, for: indexPath) as! CurrentChallengeCollectionViewCell
            cell.configure(for: currentChallenges[indexPath.item])
            cell.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pastChallengesCellReuseIdentifier, for: indexPath) as! PastChallengesCollectionViewCell
            cell.configure(for: pastChallenges[indexPath.item])
            cell.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            return cell
        }


    }
    
}
extension ViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // TODO 5a: override default flow (optional, has default flow).
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == currentCollectionView {
            return CGSize(width: collectionView.frame.width, height: 125)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: 280)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == currentCollectionView {
//            currentChallenges[indexPath.item].selected = !currentChallenges[indexPath.item].selected
//            collectionView.reloadData()
            
            print("selected a current challenge")
            
        }
        else {
            print("selected a past challenge")
//            pastChallenges[indexPath.item].selected = !pastChallenges[indexPath.item].selected
//            collectionView.reloadData()
        }
    }
}
