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
    
    private var usernameLabel = UILabel()
    private var usernameTextField = UITextField()
    private var passwordLabel = UILabel()
    private var passwordTextField = UITextField()
    private var groupLabel = UILabel()
    
    private var submitButton = UIButton()
    private var addGroupButton = UIButton()
    private var logOutButton = UIButton()
    
    private var groupsCollectionView: UICollectionView!
    private var groupInfo: [GroupInfo] = []
    
    private let groupsInfoCellReuseIdentifier = "groupsInfoCellReuseIdentifier"
    
    private var username = "Person12345"
    private var password = "12345"
    
    
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)
    private let challengeRed = UIColor(red: 237/255, green: 72/255, blue: 72/255, alpha: 1)
    
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
        
        titleLabel.text = "Profile"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        //profileBackgroundCircle
        profileBackgroundCircle.backgroundColor = challengeBlue
        profileBackgroundCircle.translatesAutoresizingMaskIntoConstraints = false
        profileBackgroundCircle.layer.cornerRadius = 183.0 / 2.0
        view.addSubview(profileBackgroundCircle)
        
        //profileView
        profileView.layer.borderWidth = 5
        profileView.layer.borderColor = CGColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        profileView.image = UIImage(named: "profile.png")
        profileView.layer.cornerRadius = 165.0 / 2.0
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)
        
        setupLabelView(titleLabel: usernameLabel, textField: usernameTextField, titleText: "USERNAME", textFieldText: username)
        setupLabelView(titleLabel: passwordLabel, textField: passwordTextField, titleText: "PASSWORD", textFieldText: password)
        
        groupLabel.text = "GROUPS"
        groupLabel.textColor = .black
        groupLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(groupLabel)
        
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        submitButton.backgroundColor = challengeBlue
        submitButton.layer.cornerRadius = 8
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        addGroupButton.setTitle("ADD GROUP", for: .normal)
        addGroupButton.setTitleColor(.white, for: .normal)
        addGroupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addGroupButton.backgroundColor = challengeBlue
        addGroupButton.layer.cornerRadius = 8
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addGroupButton)
        
        logOutButton.setTitle("LOG OUT", for: .normal)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        logOutButton.backgroundColor = challengeRed
        logOutButton.layer.cornerRadius = 8
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
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
        
        setupConstraints()
        groupInfo = [
            GroupInfo(title: "CORNELL123"),
            GroupInfo(title: "123BEARS"),
            GroupInfo(title: "CUBS123")
        ]
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
            submitButton.widthAnchor.constraint(equalToConstant: 94),
            submitButton.heightAnchor.constraint(equalToConstant: 35),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17)
        ])
        NSLayoutConstraint.activate([
            addGroupButton.widthAnchor.constraint(equalToConstant: 127),
            addGroupButton.heightAnchor.constraint(equalToConstant: 35),
            addGroupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            addGroupButton.leadingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            logOutButton.widthAnchor.constraint(equalToConstant: 101),
            logOutButton.heightAnchor.constraint(equalToConstant: 35),
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            logOutButton.leadingAnchor.constraint(equalTo: addGroupButton.trailingAnchor, constant: 10)
        ])

    }
}



extension ProfileViewController: UICollectionViewDataSource {
    // Specify number of items in section (required).
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            groupInfo[indexPath.item].selected = !groupInfo[indexPath.item].selected
            
//            let selectedTitle = groupFilters[indexPath.item].title
//            if groupFilters[indexPath.item].selected

            collectionView.reloadData()
        
    }
    
    
}
