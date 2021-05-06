//
//  SearchViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/3/21.
//
import UIKit

class SearchViewController: UIViewController {
    
    //Views
    private var titleFiller = UIView()
    private var titleView = UIView()
    private var titleLabel = UILabel()
    private var findChallengesLabel = UILabel()
    private var searchTextField = UITextField()
    
    private let unclaimedChallengesTableView = UITableView()
    private var groupFilterCollectionView: UICollectionView!
    private var groupFilters: [GroupFilter] = []
    private let unclaimedChallengesReuseIdentifier = "unclaimedChallengesReuseIdentifier"
    private let groupFilterCellReuseIdentifier = "filterCellReuseIdentifier"
    private let groupFilterCellPadding: CGFloat = 10
    
    private var challengeData: [UnclaimedChallenge] = []
    private var selectedchallengeIndex : Int?
    private var selectedCell : UnclaimedChallengeTableViewCell?
    
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
        
        titleLabel.text = "Find Challenges"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        findChallengesLabel.text = "FIND CHALLENGES"
        findChallengesLabel.textColor = .black
        findChallengesLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        findChallengesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(findChallengesLabel)
        
        
        searchTextField.font = UIFont.systemFont(ofSize: 12)
        searchTextField.backgroundColor = .white
        searchTextField.text = "Search by ..."
        searchTextField.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        searchTextField.layer.cornerRadius = 5
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: searchTextField.frame.height))
        searchTextField.leftViewMode = .always
        searchTextField.layer.shadowOpacity = 1
        searchTextField.layer.shadowRadius = 3.0
        searchTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchTextField.layer.shadowColor = CGColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        searchTextField.textAlignment = .left
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        
        
        unclaimedChallengesTableView.translatesAutoresizingMaskIntoConstraints = false
        unclaimedChallengesTableView.backgroundColor = .clear
        unclaimedChallengesTableView.delegate = self
        unclaimedChallengesTableView.dataSource = self
        unclaimedChallengesTableView.register(UnclaimedChallengeTableViewCell.self, forCellReuseIdentifier: unclaimedChallengesReuseIdentifier)
        view.addSubview(unclaimedChallengesTableView)
        
        // Setup flow layout
        let groupFilterLayout = UICollectionViewFlowLayout()
        groupFilterLayout.scrollDirection = .horizontal
        groupFilterLayout.minimumInteritemSpacing = groupFilterCellPadding
        groupFilterLayout.minimumLineSpacing = groupFilterCellPadding
        
        // Instantiate collectionView
        groupFilterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: groupFilterLayout)
        groupFilterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        groupFilterCollectionView.showsHorizontalScrollIndicator = false
        groupFilterCollectionView.backgroundColor = .clear

        groupFilterCollectionView.register(GroupFilterCollectionViewCell.self, forCellWithReuseIdentifier: groupFilterCellReuseIdentifier)
        
        groupFilterCollectionView.dataSource = self
        groupFilterCollectionView.delegate = self
        view.addSubview(groupFilterCollectionView)
        
        
        setupConstraints()
        createDummyData()
    }
    func createDummyData() {
        groupFilters = [
            GroupFilter(title: "123Cornell"), GroupFilter(title: "123Cornell"), GroupFilter(title: "123Cornell"), GroupFilter(title: "123Cornell")
        ]
        challengeData = [
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
             UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),
            UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0),UnclaimedChallenge(title: "Draw a cat", description: "This is gonna be a super long message. Gotta test the spacing. aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.s", sender: "Tabby Cat", upvotes: 1, downvotes: 0)
        ]
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
            findChallengesLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            findChallengesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])


        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: findChallengesLabel.bottomAnchor, constant: 15),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: 356),
            searchTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
        NSLayoutConstraint.activate([
            groupFilterCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            groupFilterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            groupFilterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            groupFilterCollectionView.heightAnchor.constraint(equalToConstant: 21)
        ])
        NSLayoutConstraint.activate([
            unclaimedChallengesTableView.topAnchor.constraint(equalTo: groupFilterCollectionView.bottomAnchor, constant: 20),
            unclaimedChallengesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            unclaimedChallengesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            unclaimedChallengesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: unclaimedChallengesReuseIdentifier, for: indexPath) as! UnclaimedChallengeTableViewCell
        let challenge = challengeData[indexPath.row]
        cell.configure(with: challenge)
        return cell
    }
//    private func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
//        return true
//    }
//
//    private func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: IndexPath) {
//        if (editingStyle == UITableViewCell.EditingStyle.delete) {
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath],  with: UITableView.RowAnimation.automatic)
//            challengeData.remove(at: indexPath.row)
//
//            tableView.endUpdates()
//
//        }
//    }
}

extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UnclaimedChallengeTableViewCell
        print("selected")
//        let songObject = songData[indexPath.row]
//        selectedSongIndex = indexPath.row
//        selectedCell = cell
//        let editSongController = EditSongController(cell: cell, songObject: songObject)
//        self.present(editSongController, animated: true, completion: nil)
//        editSongController.delegate = self
    }
}



extension SearchViewController: UICollectionViewDataSource {
    // Specify number of items in section (required).
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupFilters.count

        
    }
    // Specify cell to return (required).
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: groupFilterCellReuseIdentifier, for: indexPath) as! GroupFilterCollectionViewCell
        cell.configure(for: groupFilters[indexPath.item])
        return cell
        

    }
    
    
}

extension SearchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // Override default flow (optional, has default flow).
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 111, height: 21)
        
    }
    
    // Provide selection functionality.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == groupFilterCollectionView {
            groupFilters[indexPath.item].selected = !groupFilters[indexPath.item].selected
            
//            let selectedTitle = groupFilters[indexPath.item].title
//            if groupFilters[indexPath.item].selected

            collectionView.reloadData()
            unclaimedChallengesTableView.reloadData()
        }
    }
    
    
}
