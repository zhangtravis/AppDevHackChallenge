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
    private var searchTitleTextField = UITextField()
    
    private let unclaimedChallengesTableView = UITableView()
    private var groupFilterCollectionView: UICollectionView!
    private var groupFilters: [GroupFilter] = []
    private let unclaimedChallengesReuseIdentifier = "unclaimedChallengesReuseIdentifier"
    private let groupFilterCellReuseIdentifier = "groupFilterCellReuseIdentifier"
    private let groupFilterCellPadding: CGFloat = 10
    
    private var challengeData: [Challenge] = []
    private var shownChallengeData: [Challenge] = []
//    private var selectedchallengeIndex : Int?
    private var selectedCell : UnclaimedChallengeTableViewCell?
    private var currentIndexPathToUpdate: IndexPath?
    
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)
    
    private let refreshControl = UIRefreshControl()
    
//    private var player = PlayerData()
    let claimAlert = UIAlertController(title: "Claim this challenge", message: nil, preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupFilterCollectionView.reloadData()
        refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundGrey
        
        if #available(iOS 10.0, *) {
            unclaimedChallengesTableView.refreshControl = refreshControl
        } else {
            unclaimedChallengesTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        titleFiller.backgroundColor = challengeBlue
        titleFiller.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFiller)
        
        titleView.backgroundColor = challengeBlue
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        
        titleLabel.text = "Search"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        findChallengesLabel.text = "FIND CHALLENGES"
        findChallengesLabel.textColor = .black
        findChallengesLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        findChallengesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(findChallengesLabel)
        
        
        searchTitleTextField.font = UIFont.systemFont(ofSize: 12)
        searchTitleTextField.backgroundColor = .white
        searchTitleTextField.placeholder = "Search by title..."
        searchTitleTextField.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        searchTitleTextField.layer.cornerRadius = 5
        searchTitleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: searchTitleTextField.frame.height))
        searchTitleTextField.leftViewMode = .always
        searchTitleTextField.layer.shadowOpacity = 1
        searchTitleTextField.layer.shadowRadius = 3.0
        searchTitleTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchTitleTextField.layer.shadowColor = CGColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        searchTitleTextField.textAlignment = .left
        searchTitleTextField.addTarget(self, action: #selector(searchChallengesByTitle), for: UIControl.Event.primaryActionTriggered)
        searchTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTitleTextField)
        
        
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
        
        claimAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        claimAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            let player = (self.tabBarController as! TabBarController).player
//            MARK: Claim post NetworkManager
            print("claiming challenge")
            print("\(player.id)")

            if player.id != -1 {
                if let indexPath = self.currentIndexPathToUpdate {
                    NetworkManager.claimChallenge(player_id: player.id, challenge_id: self.challengeData[indexPath.row].id) { (claimedChallenge) in
                        print("using claim info")
                        
                    }
                    self.challengeData.remove(at: indexPath.row)
                    self.sortChallengeData()
                    self.shownChallengeData = self.challengeData
                    self.unclaimedChallengesTableView.reloadData()
                }
            }

            
        }))
        
        setupConstraints()
        createDummyData()
    }
    func sortChallengeData() {
        challengeData.sort { (leftChallenge, rightChallenge) -> Bool in
            return leftChallenge.id > rightChallenge.id
        }
    }
    func createDummyData() {
//        groupFilters = [
//            GroupFilter(title: "123Cornell"), GroupFilter(title: "123Cornell"), GroupFilter(title: "123Cornell"), GroupFilter(title: "123Cornell")
//        ]

       
        NetworkManager.getAllUnclaimedChallenges { (challengesList) in
            self.challengeData = challengesList
            self.sortChallengeData()
            self.shownChallengeData = self.challengeData
            self.unclaimedChallengesTableView.reloadData()
        }
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
            searchTitleTextField.topAnchor.constraint(equalTo: findChallengesLabel.bottomAnchor, constant: 15),
            searchTitleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTitleTextField.widthAnchor.constraint(equalToConstant: 356),
            searchTitleTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            groupFilterCollectionView.topAnchor.constraint(equalTo: searchTitleTextField.bottomAnchor, constant: 15),
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
    @objc func refreshData() {
        // MARK: Use getAllPosts
        /**
         We want to retrieve data from the server here upon refresh. Make sure to
         1) Sort the posts with `sortPostData`
         2) Update `postData` & `shownPostData` and reload `postTableView`
         3) End the refreshing on `refreshControl`
         
         DO NOT USE `DispatchQueue.main.asyncAfter` as currently is - just use `getAllPosts`
         */

        NetworkManager.getAllUnclaimedChallenges(completion: { (challengeList) in
            self.challengeData = challengeList
            self.sortChallengeData()
            self.shownChallengeData = self.challengeData
            self.unclaimedChallengesTableView.reloadData()
            self.refreshControl.endRefreshing()
        })
        let player = (self.tabBarController as! TabBarController).player
        var groupFilterData :[GroupFilter] = []
        for group in player.groups {
            groupFilterData.append(GroupFilter(group: group))
        }
        groupFilters = groupFilterData
    }
    @objc func searchChallengesByTitle() {
        print("searching unclaimed challenges for " + (searchTitleTextField.text ?? "nothing"))
        var newData : [Challenge] = []
        for cell in challengeData {
            if let matchedTitle = cell.title.range(of: searchTitleTextField.text ?? "", options: .caseInsensitive) {
                newData.append(cell)
            } else {
            }
        }
        shownChallengeData = newData
        sortChallengeData()
        unclaimedChallengesTableView.reloadData()
    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownChallengeData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: unclaimedChallengesReuseIdentifier, for: indexPath) as! UnclaimedChallengeTableViewCell
        let challenge = shownChallengeData[indexPath.row]
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
//        let cell = tableView.cellForRow(at: indexPath) as! UnclaimedChallengeTableViewCell
        currentIndexPathToUpdate = indexPath
        present(claimAlert, animated: true)
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
            if groupFilters[indexPath.item].selected {
                print("filtering by " + groupFilters[indexPath.item].group.name)
                print("THISIS IT")
                shownChallengeData = []
                for challenge in challengeData {
//                    if challenge.group_id == groupFilters[indexPath.item].group.id{
//                        shownChallengeData.append(challenge)
//                        collectionView.reloadData()
//                    }

                }
                self.unclaimedChallengesTableView.reloadData()
            }
            else {
                NetworkManager.getAllUnclaimedChallenges(completion: { (unclaimedChallengeData) in
                    print("unselected filter")
                    self.shownChallengeData = unclaimedChallengeData
                    collectionView.reloadData()
                    self.unclaimedChallengesTableView.reloadData()
                })
            }
            
        }
    }
    
    
}
