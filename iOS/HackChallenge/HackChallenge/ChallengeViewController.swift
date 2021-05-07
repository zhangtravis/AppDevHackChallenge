//
//  ChallengeViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/1/21.
//

import UIKit

class ChallengeViewController: UIViewController {

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
        
        titleLabel.text = "Upload Challenges"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        setupTextFieldView(textField: challengeTitleTextField,fillerText: "Enter Challenge Title ...")
        
        descriptionTextView.backgroundColor = .white
        descriptionTextView.layer.cornerRadius = 4
        descriptionTextView.text = "Enter Challenge Description ..."
        descriptionTextView.font = UIFont.systemFont(ofSize: 12)
        descriptionTextView.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
        descriptionTextView.layer.shadowOpacity = 1
        descriptionTextView.layer.shadowRadius = 3.0
        descriptionTextView.layer.shadowOffset = CGSize(width: 2, height: 2)
        descriptionTextView.layer.shadowColor = CGColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        descriptionTextView.textContainer.lineFragmentPadding = 15
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextView)
        
        setupTextFieldView(textField: groupTextField, fillerText: "Enter Group...")
        
        setupLabelView(titleLabel: challengeTitleLabel, infoLabel: challengeInfoTitleLabel, titleText: "TITLE", infoText: "Give your challenge a title.")
        setupLabelView(titleLabel: descriptionTitleLabel, infoLabel: descriptionInfoTitleLabel, titleText: "DESCRIPTION", infoText: "Write a description of your challenge. Max ___ Characters")
        setupLabelView(titleLabel: groupTitleLabel, infoLabel: groupInfoTitleLabel, titleText: "GROUP", infoText: "Propose your challenge to a group or globally")
        
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
        textField.text = "Enter Challenge Title ..."
        textField.textColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1)
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
    }

}
