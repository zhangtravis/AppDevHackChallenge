//
//  SubmitChallengeViewController.swift
//  HackChallenge
//
//  Created by Samantha Zhang on 5/8/21.
//

import UIKit

class SubmitChallengeViewController: UIViewController{
    weak var delegate : SubmitChallengeDelegate?
    private let challengeBlue = UIColor(red: 46/255, green: 116/255, blue: 181/255, alpha: 1)
    private let backgroundGrey = UIColor(red: 212/255, green: 221/255, blue: 234/255, alpha: 1)

    
    private var imageView = UIImageView()
    private var submitButton = UIButton()
    private var selectionButton = UIButton()
    
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
        
        selectionButton.setTitle("SELECT", for: .normal)
        selectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        selectionButton.backgroundColor = challengeBlue
        selectionButton.setTitleColor(.white, for: .normal)
        selectionButton.layer.cornerRadius = 10
        selectionButton.addTarget(self, action: #selector(selectButtonPressed), for: .touchUpInside)
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectionButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        setupConstraints()
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            submitButton.widthAnchor.constraint(equalToConstant: 161),
            submitButton.heightAnchor.constraint(equalToConstant: 35),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            selectionButton.widthAnchor.constraint(equalToConstant: 161),
            selectionButton.heightAnchor.constraint(equalToConstant: 35),
            selectionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            selectionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20)
        ])
    }
    
    @objc func submitButtonPressed() {
//        delegate?.submitChallenge(image: selectedImage)
        if let profileImageBase64 = imageView.image?.pngData()?.base64EncodedString() {
//            print(profileImageBase64)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectButtonPressed() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}
extension SubmitChallengeViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizedPickedImage = pickedImage.resize(toSize: CGSize(width: 100, height: 100))
            imageView.contentMode = .scaleAspectFit
            imageView.image = resizedPickedImage
        }

        dismiss(animated: true, completion: nil)
    }
}
