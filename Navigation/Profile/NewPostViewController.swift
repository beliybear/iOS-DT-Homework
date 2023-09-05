//
//  NewPostViewController.swift
//  Navigation
//
//  Created by Ian Belyakov on 21.08.2023
//


import UIKit
import SnapKit

class NewPostViewController: UIViewController {
    
    var delegate: ProfileDelegate?
    var post: Post?
    var user: User
    var imageCoreData: Data?
    
    init(post: Post? = nil, user: User, imageCoreData: Data? = nil) {
        self.post = post
        self.user = user
        self.imageCoreData = imageCoreData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let textView: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setImageButton = CustomButton(title: NSLocalizedString("setImage-button-profileVC-localizable", comment: ""), titleColor: .white, bgColor: UIColor.createColor(lightMode: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), darkMode: .systemGray4), hidden: true, action: buttonPressed)
    private lazy var changeImageButton = CustomButton(title: NSLocalizedString("changeImage-button-profileVC-localizable", comment: ""), titleColor: .white, bgColor: UIColor.createColor(lightMode: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), darkMode: .systemGray4), hidden: true, action: buttonPressed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupButtons()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func setup() {
        textView.text = post?.text ?? ""
        if let imageData = post?.image {
            imageView.image = UIImage(data: imageData)
        }
        
    }
    
    private func setupButtons() {
        let saveButton = UIBarButtonItem(title: NSLocalizedString("save-button-profileVC-localizable", comment: ""), style: .plain, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        view.addSubview(textView)
        view.addSubview(imageView)
        view.addSubview(setImageButton)
        view.addSubview(changeImageButton)
        setupConstraints()
        setupNotebutton()
        if post != nil {
            navigationItem.title = NSLocalizedString("changePost-profileVC-localizable", comment: "")
        } else {
            navigationItem.title = NSLocalizedString("createPost-profileVC-localizable", comment: "")
        }
    }
    
    func setupNotebutton() {
        if post != nil {
            if imageView.image != nil {
                changeImageButton.isHidden = false
            }
        } else {
            setImageButton.isHidden = false
        }
    }
    
    @objc
    private func buttonPressed() {
        ImagePicker.defaultPicker.getImage(in: self) { imageData in
            DispatchQueue.main.async {
                if let imageData {
                    self.imageCoreData = imageData
                    self.imageView.image = UIImage(data: self.imageCoreData!)
                    self.setImageButton.isHidden = true
                    self.changeImageButton.isHidden = false
                }
            }
        }
    }
    
    private func setupConstraints() {
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(200)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(200)
        }
        
        setImageButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        
        changeImageButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        
    }
    
    @objc
    private func saveButtonPressed() {
        guard let text = textView.text, text != "" else {
            AlertManager.defaulManager.autorizationErrors(showIn: self, error: .empty)
            return
        }
        if let post {
            CoreDataManeger.defaulManager.updatePost(post: post, newText: text, imageData: imageCoreData)
            navigationController?.popViewController(animated: true)
        } else {
            CoreDataManeger.defaulManager.addPost(text: text, image: imageCoreData ?? Data(), for: user)
            navigationController?.popViewController(animated: true)
        }
    }
    
}
