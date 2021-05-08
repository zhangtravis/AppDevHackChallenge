//
//  SubmitChallengeViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/8/21.
//

import UIKit

class SubmitChallengeViewController: UIViewController {
    weak var delegate : SubmitChallengeDelegate?
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)

    private var submitButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundGrey
        // Do any additional setup after loading the view.
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        submitButton.backgroundColor = challengeBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        setupConstraints()
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            submitButton.widthAnchor.constraint(equalToConstant: 161),
            submitButton.heightAnchor.constraint(equalToConstant: 35),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func submitButtonPressed() {
        delegate?.submitChallenge(image: "hi there test")
        self.dismiss(animated: true, completion: nil)
    }

}
