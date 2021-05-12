//
//  ProfileViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/1/21.
//

import UIKit

class ProfileViewController: UIViewController {

    //Views
    private var titleFiller = UIView()
    private var titleView = UIView()
    private var titleLabel = UILabel()
    
    private var profileBackgroundCircle = UIView()
    private var profileView = UIImageView()
    private var profileImage : String = ""
    private var profileButton = UIButton()
    
    private var usernameLabel = UILabel()
    private var usernameTextField = UITextField()
    private var passwordLabel = UILabel()
    private var passwordTextField = UITextField()
    private var groupLabel = UILabel()
    private var reminderGroups = UILabel()
    
    
    private var joinGroupButton = UIButton()
    private var addGroupButton = UIButton()
    private var signOutButton = UIButton()
    
    private var groupsCollectionView: UICollectionView!
    private var groupInfo: [Group] = []
    private var signedIn : Bool = false
//    private var player = PlayerData()
//
    private let groupsInfoCellReuseIdentifier = "groupsInfoCellReuseIdentifier"
//
//    private var username = "Person12345"
//    private var password = "12345"
    let createGroupAlert = UIAlertController(
           title: "Create Group", message: "Fill in the information below to create a group", preferredStyle: .alert)
    let joinGroupAlert = UIAlertController(
              title: "Join Group", message: "Fill in the name of the group you are joining", preferredStyle: .alert)
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)
    private let challengeRed = UIColor(red: 237/255, green: 72/255, blue: 72/255, alpha: 1)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let player = (self.tabBarController as! TabBarController).player
        profileView.image = player.image
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let player = (self.tabBarController as! TabBarController).player
        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundGrey
        groupInfo = player.groups
        
        titleFiller.backgroundColor = challengeBlue
        titleFiller.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFiller)
        
        titleView.backgroundColor = challengeBlue
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        
        titleLabel.text = "Profile"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        reminderGroups.text = ""
        reminderGroups.textColor = .black
        reminderGroups.numberOfLines = 0
        reminderGroups.lineBreakMode = .byWordWrapping
        reminderGroups.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        reminderGroups.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reminderGroups)
        
        //profileBackgroundCircle
        profileBackgroundCircle.backgroundColor = challengeBlue
        profileBackgroundCircle.translatesAutoresizingMaskIntoConstraints = false
        profileBackgroundCircle.layer.cornerRadius = 183.0 / 2.0
        view.addSubview(profileBackgroundCircle)
        
        //profileView
        profileView.layer.borderWidth = 5
        profileView.layer.borderColor = CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
//        profileView.image = UIImage(named: "profile.png")
        profileView.image = player.image
        profileView.layer.cornerRadius = 165.0 / 2.0
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.clipsToBounds = true
        view.addSubview(profileView)
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.addTarget(self, action: #selector(changeProfilePressed), for: .touchUpInside)
        profileButton.layer.cornerRadius = 165.0 / 2.0
        view.addSubview(profileButton)
        
        setupLabelView(titleLabel: usernameLabel, textField: usernameTextField, titleText: "USERNAME", textFieldText: player.username)
        setupLabelView(titleLabel: passwordLabel, textField: passwordTextField, titleText: "PASSWORD", textFieldText: player.password)
        
        groupLabel.text = "GROUPS"
        groupLabel.textColor = .black
        groupLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(groupLabel)
        
        joinGroupButton.setTitle("JOIN GROUP", for: .normal)
        joinGroupButton.setTitleColor(.white, for: .normal)
        joinGroupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        joinGroupButton.backgroundColor = challengeBlue
        joinGroupButton.layer.cornerRadius = 8
        joinGroupButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        joinGroupButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(joinGroupButton)
        
        addGroupButton.setTitle("ADD GROUP", for: .normal)
        addGroupButton.setTitleColor(.white, for: .normal)
        addGroupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addGroupButton.backgroundColor = challengeBlue
        addGroupButton.layer.cornerRadius = 8
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        addGroupButton.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        view.addSubview(addGroupButton)
        
        signOutButton.setTitle("SIGN OUT", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        signOutButton.backgroundColor = challengeRed
        signOutButton.layer.cornerRadius = 8
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        view.addSubview(signOutButton)
        
        let groupLayout = UICollectionViewFlowLayout()
        groupLayout.scrollDirection = .vertical
        groupLayout.minimumInteritemSpacing = 0
        groupLayout.minimumLineSpacing = 20

        
        groupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: groupLayout)
        groupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        groupsCollectionView.showsVerticalScrollIndicator = false
        groupsCollectionView.backgroundColor = .clear
        groupsCollectionView.register(GroupsCollectionViewCell.self, forCellWithReuseIdentifier: groupsInfoCellReuseIdentifier)
        
        groupsCollectionView.dataSource = self
        groupsCollectionView.delegate = self
        view.addSubview(groupsCollectionView)
        
        createGroupAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        createGroupAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the group name here..."
        })
        createGroupAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            if let textFields = self.createGroupAlert.textFields,
               let input = textFields[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               input != "" {
                NetworkManager.createGroup(name: input) { (newGroup) in
                    NetworkManager.addPlayerToGroup(player_id: player.id, group_id: newGroup.id) { (group) in
                        
                    }
                    self.groupInfo.append(newGroup)
                    self.groupsCollectionView.reloadData()
                }
            }
            
        }))
        //MARK: Make button and test
        joinGroupAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        joinGroupAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the group name here..."
        })
        joinGroupAlert.addAction(UIAlertAction(title: "Join", style: .default, handler: { action in
            if let textFields = self.createGroupAlert.textFields,
               let input = textFields[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
               input != "" {
                
                NetworkManager.getGroup(name: input) { (selectedGroup) in
                    NetworkManager.addPlayerToGroup(player_id: player.id, group_id: selectedGroup.id) { (addedgroup) in
                        self.groupInfo.append(addedgroup)
                        self.groupsCollectionView.reloadData()
                    }
                }
                
            }
            
        }))
        setupConstraints()
       
    }

    func setupLabelView(titleLabel: UILabel, textField: UITextField,titleText: String, textFieldText: String) {
        titleLabel.text = titleText
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        textField.font = UIFont.systemFont(ofSize: 12)
        textField.backgroundColor = .white
        textField.text = textFieldText
        textField.textColor = .black
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOffset = CGSize(width: 2, height: 2)
        textField.layer.shadowColor = CGColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
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
        //profileView
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: titleView.safeAreaLayoutGuide.bottomAnchor, constant: 48),
            profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 163),
            profileView.widthAnchor.constraint(equalToConstant: 163)
            
        ])
        
        //profileBackgroundCircle
        NSLayoutConstraint.activate([
            profileBackgroundCircle.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profileBackgroundCircle.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profileBackgroundCircle.heightAnchor.constraint(equalToConstant: 183),
            profileBackgroundCircle.widthAnchor.constraint(equalToConstant: 183)
        ])
        
        NSLayoutConstraint.activate([
            profileButton.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            profileButton.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profileButton.heightAnchor.constraint(equalToConstant: 183),
            profileButton.widthAnchor.constraint(equalToConstant: 183)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            usernameLabel.topAnchor.constraint(equalTo: profileBackgroundCircle.bottomAnchor, constant: 52),
            usernameLabel.trailingAnchor.constraint(equalTo: usernameTextField.leadingAnchor, constant: 49)
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            usernameTextField.widthAnchor.constraint(equalToConstant: 220),
            usernameTextField.heightAnchor.constraint(equalToConstant: 35),
            usernameTextField.topAnchor.constraint(equalTo: profileBackgroundCircle.bottomAnchor, constant: 41)
        ])
        
        NSLayoutConstraint.activate([
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 41),
            passwordLabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 49)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            passwordTextField.widthAnchor.constraint(equalToConstant: 220),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            groupLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            groupLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 41)
        ])

        NSLayoutConstraint.activate([
            groupsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            groupsCollectionView.widthAnchor.constraint(equalToConstant: 220),
            groupsCollectionView.heightAnchor.constraint(equalToConstant: 140),
            groupsCollectionView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            reminderGroups.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            reminderGroups.widthAnchor.constraint(equalToConstant: 220),
            reminderGroups.topAnchor.constraint(equalTo: groupLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addGroupButton.widthAnchor.constraint(equalToConstant: 110),
            addGroupButton.heightAnchor.constraint(equalToConstant: 35),
            addGroupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            addGroupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17)
        ])
        NSLayoutConstraint.activate([
            joinGroupButton.widthAnchor.constraint(equalToConstant: 127),
            joinGroupButton.heightAnchor.constraint(equalToConstant: 35),
            joinGroupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            joinGroupButton.leadingAnchor.constraint(equalTo: addGroupButton.trailingAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            signOutButton.widthAnchor.constraint(equalToConstant: 101),
            signOutButton.heightAnchor.constraint(equalToConstant: 35),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            signOutButton.leadingAnchor.constraint(equalTo: joinGroupButton.trailingAnchor, constant: 10)
        ])

    }
    @objc func changeProfilePressed() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    @objc func signUp() {
        
        let player = (self.tabBarController as! TabBarController).player
        player.username = usernameTextField.text ?? ""
        player.password = usernameTextField.text ?? ""
        print("SIGN UP")
        NetworkManager.createPlayer(username: player.username, password: player.password, image_data: profileImage) { (playerInfo) in
            player.id = playerInfo.id
            print("SIGN UP player id : \(player.id)")
        }
//        print("updated player info")
    }
    @objc func logIn() {
        let player = (self.tabBarController as! TabBarController).player
        player.username = usernameTextField.text ?? ""
        player.password = usernameTextField.text ?? ""
        NetworkManager.logInPlayer(username: player.username, password: player.password) { (loggedPlayer) in
            //MARK: ADD URL DOWNLOAD ONCE LINK FIXED
//            self.profileView.downloaded(from: loggedPlayer.image.url)
            let url = URL(string: loggedPlayer.image.url)
            let data = try? Data(contentsOf: url!)
            self.profileView.image = UIImage(data: data!)
            player.id = loggedPlayer.id
            self.groupInfo = loggedPlayer.groups
            self.groupsCollectionView.reloadData()
            print("LOG IN player id : \(player.id)")
        }
    }
    @objc func createGroup() {
        self.present(self.createGroupAlert, animated: true, completion: nil)
    }
}



extension ProfileViewController: UICollectionViewDataSource {
    // Specify number of items in section (required).
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if groupInfo.count == 0 {
            reminderGroups.text = "You are in no groups right now"
        }
        else {
            reminderGroups.text = ""
        }
        return groupInfo.count

        
    }
    // Specify cell to return (required).
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: groupsInfoCellReuseIdentifier, for: indexPath) as! GroupsCollectionViewCell
        cell.configure(for: groupInfo[indexPath.item])
        return cell
        

    }

    
    
}

extension ProfileViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    // Override default flow (optional, has default flow).
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 35)
        
    }
    
    // Provide selection functionality.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            groupInfo[indexPath.item].selected = !groupInfo[indexPath.item].selected
            
//            let selectedTitle = groupFilters[indexPath.item].title
//            if groupFilters[indexPath.item].selected

            collectionView.reloadData()
        
    }


    
}
extension ProfileViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizedPickedImage = pickedImage.resize(toSize: CGSize(width: 100, height: 100))
            profileView.contentMode = .scaleAspectFit
            profileView.image = resizedPickedImage
            if let profileImageBase64 = profileView.image?.pngData()?.base64EncodedString() {
//                print("data:image/png;base64," + profileImageBase64)
                profileImage = "data:image/png;base64," + profileImageBase64
            }
        }

        dismiss(animated: true, completion: nil)
    }
}
