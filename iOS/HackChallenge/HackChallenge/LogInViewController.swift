//
//  LogInViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/11/21.
//

import UIKit

class LogInViewController: UIViewController {
    weak var delegate : LogInDelegate?
    
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)
    
    private var titleFiller = UIView()
    private var titleView = UIView()
    private var titleLabel = UILabel()
    
    private var retryLabel = UILabel()
    
    private var profileBackgroundCircle = UIView()
    private var profileView = UIImageView()
    private var profileButton = UIButton()
    private var profileImage : String = ""
    
    private var usernameLabel = UILabel()
    private var usernameTextField = UITextField()
    private var passwordLabel = UILabel()
    private var passwordTextField = UITextField()
  
    
    private var logInButton = UIButton()
    private var signUpButton = UIButton()
    
    private let player: PlayerData
    
    init(player : PlayerData) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundGrey
        
        
        titleFiller.backgroundColor = challengeBlue
        titleFiller.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFiller)
        
        titleView.backgroundColor = challengeBlue
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        
        titleLabel.text = "Challenge with Friends"
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
        profileView.clipsToBounds = true
        view.addSubview(profileView)
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.addTarget(self, action: #selector(changeProfilePressed), for: .touchUpInside)
        profileButton.layer.cornerRadius = 165.0 / 2.0
        view.addSubview(profileButton)
        
        setupLabelView(titleLabel: usernameLabel, textField: usernameTextField, titleText: "USERNAME", textFieldText: "")
        setupLabelView(titleLabel: passwordLabel, textField: passwordTextField, titleText: "PASSWORD", textFieldText: "")
        
        retryLabel.text = ""
        retryLabel.textColor = .black
        retryLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        retryLabel.translatesAutoresizingMaskIntoConstraints = false
        retryLabel.numberOfLines = 0
        retryLabel.textAlignment = .center
        retryLabel.lineBreakMode = .byWordWrapping
        view.addSubview(retryLabel)
   
        logInButton.setTitle("LOG IN", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        logInButton.backgroundColor = challengeBlue
        logInButton.layer.cornerRadius = 8
        logInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logInButton)

        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        signUpButton.backgroundColor = challengeBlue
        signUpButton.layer.cornerRadius = 8
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        view.addSubview(signUpButton)
        
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
            retryLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            retryLabel.widthAnchor.constraint(equalToConstant: 300),
            retryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logInButton.widthAnchor.constraint(equalToConstant: 150),
            logInButton.heightAnchor.constraint(equalToConstant: 35),
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            signUpButton.widthAnchor.constraint(equalToConstant: 150),
            signUpButton.heightAnchor.constraint(equalToConstant: 35),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    @objc func changeProfilePressed() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    @objc func signUp() {
        if passwordTextField.text != "" || usernameTextField.text != "" {
            if let pass = passwordTextField.text as? String {
                player.password = pass
            }
            else {
                player.password = String(passwordTextField.text!)
            }
            if let user = usernameTextField.text as? String {
                player.username = user
            }
            else {
                player.username = String(usernameTextField.text!)
            }
        player.username = usernameTextField.text ?? ""
        player.password = passwordTextField.text ?? ""
        print("SIGN UP")
        NetworkManager.createPlayer(username: player.username, password: player.password, image_data: profileImage) { (playerInfo) in
            self.player.id = playerInfo.id
            let url = URL(string: playerInfo.image.url)
            let data = try? Data(contentsOf: url!)
            self.player.image =  UIImage(data: data!)
            self.player.groups = playerInfo.groups
            print("SIGN UP player id : \(self.player.id)")
        }
            let seconds = 5.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                print(self.player.id)
                if self.player.id != -1 {
                    self.player.login = true
                    self.delegate?.logInPlayer(player: self.player)
                    print("player username : \(self.player.username)")
                    print("player password : \(self.player.password)")
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.retryLabel.text = "Invalid Username or Password or Missing Profile Image"
                }
            }


        }
        else {
            retryLabel.text = "Please fill in a username and a password"
        }

//        print("updated player info")
    }
    @objc func logIn() {

        if passwordTextField.text != "" || usernameTextField.text != "" {
            if let pass = passwordTextField.text as? String {
                player.password = pass
            }
            else {
                player.password = String(passwordTextField.text!)
            }
            if let user = usernameTextField.text as? String {
                player.username = user
            }
            else {
                player.username = String(usernameTextField.text!)
            }
           NetworkManager.logInPlayer(username: player.username, password: player.password) { (loggedPlayer) in
                    self.player.id = loggedPlayer.id
                    let url = URL(string: loggedPlayer.image.url)
                    let data = try? Data(contentsOf: url!)
                    self.player.image =  UIImage(data: data!)
                    self.player.groups = loggedPlayer.groups
                    print("LOG IN player id : \(self.player.id)")
   
            }
            let seconds = 5.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                print(self.player.id)
                if self.player.id != -1 {
                    self.player.login = true
                    self.delegate?.logInPlayer(player: self.player)
                    print("player username : \(self.player.username)")
                    print("player password : \(self.player.password)")
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.retryLabel.text = "Invalid Username or Password"
                }
            }

        }
        else {
            retryLabel.text = "Please fill in a username and a password"
        }

    }
}
extension LogInViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
        self.player.image = self.profileView.image
        dismiss(animated: true, completion: nil)
    }
}
