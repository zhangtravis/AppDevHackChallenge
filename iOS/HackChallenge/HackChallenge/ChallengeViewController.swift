//
//  ChallengeViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/1/21.
//

import UIKit

class ChallengeViewController: UIViewController, UITextViewDelegate {

    //Views
    private var titleFiller = UIView()
    private var titleView = UIView()
    private var titleLabel = UILabel()
    
    private var challengeTitleTextField = UITextField()
    private var challengeTitleLabel = UILabel()
    private var challengeInfoTitleLabel = UILabel()
    
    private var descriptionTextView = UITextView()
    private var descriptionTitleLabel = UILabel()
    private var descriptionInfoTitleLabel = UILabel()
    
    private var groupTextField = UITextField()
    private var groupTitleLabel = UILabel()
    private var groupInfoTitleLabel = UILabel()
    
    private var submitButton = UIButton()
    
    
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)
    
    private let placeholderColor = UIColor(red: 196/255, green: 196/255, blue: 198/255, alpha: 1)
    let confrmationAlert = UIAlertController(
           title: "Uploaded Challenge", message: "Your challenge has been successfully uploaded!", preferredStyle: .alert)
    let closeAction = UIAlertAction(
           title: "Close Alert", style: .default, handler: nil)
    
//    private var player = PlayerData()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        player = (self.tabBarController as! TabBarController).player
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundGrey
        confrmationAlert.addAction(closeAction)
        
        titleFiller.backgroundColor = challengeBlue
        titleFiller.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFiller)
        
        titleView.backgroundColor = challengeBlue
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        
        titleLabel.text = "Upload Challenges"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        setupTextFieldView(textField: challengeTitleTextField,fillerText: "Enter Challenge Title ...")
        challengeTitleTextField.addTarget(self, action: #selector(changeChallengeTextField), for: .editingChanged)
        
        descriptionTextView.backgroundColor = .white
        descriptionTextView.layer.cornerRadius = 4
        descriptionTextView.text = "Enter Challenge Description ..."
        descriptionTextView.font = UIFont.systemFont(ofSize: 12)
        descriptionTextView.textColor = placeholderColor
        descriptionTextView.layer.shadowOpacity = 1
        descriptionTextView.layer.shadowRadius = 3.0
        descriptionTextView.layer.shadowOffset = CGSize(width: 2, height: 2)
        descriptionTextView.layer.shadowColor = CGColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        descriptionTextView.textContainer.lineFragmentPadding = 15
        descriptionTextView.textContainer.maximumNumberOfLines = 3
        descriptionTextView.textContainer.lineBreakMode = .byWordWrapping
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
//        descriptionTextView.addTarget(self, action: #selector(changeDescriptionTextView), for: .editingChanged)
        descriptionTextView.delegate = self
        view.addSubview(descriptionTextView)
        
        setupTextFieldView(textField: groupTextField, fillerText: "Enter Group...")
        
        groupTextField.addTarget(self, action: #selector(changeGroupTextField), for: .editingChanged)
        
        setupLabelView(titleLabel: challengeTitleLabel, infoLabel: challengeInfoTitleLabel, titleText: "TITLE", infoText: "Give your challenge a title.")
        setupLabelView(titleLabel: descriptionTitleLabel, infoLabel: descriptionInfoTitleLabel, titleText: "DESCRIPTION", infoText: "Write a description of your challenge. Max 3 Lines (delete if past that amount).")
        setupLabelView(titleLabel: groupTitleLabel, infoLabel: groupInfoTitleLabel, titleText: "GROUP", infoText: "Propose your challenge to a group or globally")
        
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        submitButton.backgroundColor = challengeBlue
        submitButton.layer.cornerRadius = 10
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(createChallenge), for: .touchUpInside)
        view.addSubview(submitButton)
        
        setupConstraints()
    }
    func setupLabelView(titleLabel: UILabel, infoLabel: UILabel,titleText: String, infoText: String) {
        titleLabel.text = titleText
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel.text = infoText
        infoLabel.numberOfLines = 0
        infoLabel.textColor = UIColor(red: 101/255, green: 99/255, blue: 99/255, alpha: 1)
        infoLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
    }
    
    func setupTextFieldView(textField: UITextField, fillerText: String) {
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.backgroundColor = .white
        textField.placeholder = "Enter Challenge Title ..."
        textField.textColor = placeholderColor
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
    
    func setupLabelConstraints(titleLabel: UILabel, infoLabel:UILabel, textField: UITextField) {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            titleLabel.topAnchor.constraint(equalTo: textField.topAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 107)
        ])
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            infoLabel.widthAnchor.constraint(equalToConstant: 107)
        ])
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
            challengeTitleTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 48),
            challengeTitleTextField.heightAnchor.constraint(equalToConstant: 35),
            challengeTitleTextField.widthAnchor.constraint(equalToConstant: 211),
            challengeTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21)
        ])
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: challengeTitleTextField.bottomAnchor, constant: 62),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 137),
            descriptionTextView.widthAnchor.constraint(equalToConstant: 211),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21)
        ])
        NSLayoutConstraint.activate([
            groupTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 62),
            groupTextField.heightAnchor.constraint(equalToConstant: 35),
            groupTextField.widthAnchor.constraint(equalToConstant: 211),
            groupTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21)
        ])
        
        setupLabelConstraints(titleLabel: challengeTitleLabel, infoLabel: challengeInfoTitleLabel, textField: challengeTitleTextField)
        NSLayoutConstraint.activate([
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            descriptionTitleLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            descriptionTitleLabel.widthAnchor.constraint(equalToConstant: 107)
        ])
        NSLayoutConstraint.activate([
            descriptionInfoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            descriptionInfoTitleLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionInfoTitleLabel.widthAnchor.constraint(equalToConstant: 107)
        ])
        setupLabelConstraints(titleLabel: groupTitleLabel, infoLabel: groupInfoTitleLabel, textField: groupTextField)
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -62),
            submitButton.heightAnchor.constraint(equalToConstant: 32),
            submitButton.widthAnchor.constraint(equalToConstant: 178), submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    @objc func changeChallengeTextField() {
        if challengeTitleTextField.textColor != .black {
            challengeTitleTextField.textColor = .black
        }
    }
    
    @objc func changeGroupTextField() {
        if groupTextField.textColor != .black {
            groupTextField.textColor = .black
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != .black {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Challenge Description ..."
            textView.textColor = placeholderColor
        }
    }
    @objc func createChallenge() {
        let player = (self.tabBarController as! TabBarController).player
        NetworkManager.createChallenge(title: challengeTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), description: descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines), author_id: player.id, username: player.username, group_id: groupTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { (newChallenge) in
            //MARK: QUESTION: Make groupText get group id for group name and read author_id from somewhere?? (note doesn't use newchallenge)
            
            self.present(self.confrmationAlert, animated: true, completion: nil)
            //reset view
            self.challengeTitleTextField.text = nil
            self.challengeTitleTextField.textColor = self.placeholderColor
            self.groupTextField.text = nil
            self.groupTextField.textColor = self.placeholderColor
            self.descriptionTextView.text = nil
            self.textViewDidEndEditing(self.descriptionTextView)
            
            print("created challenge")
        }
    }

}

