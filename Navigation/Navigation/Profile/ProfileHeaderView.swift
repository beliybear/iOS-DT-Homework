//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Beliy.Bear on 19.12.2022.
//

import UIKit
import SnapKit
import FirebaseAuth

class ProfileHeaderView: UITableViewHeaderFooterView {
    var currentUser = User(login: "0000", name: "BeliyBear", avatar: UIImage(named: "avatarImage") ?? .add, status: "waiting for something")
    var statusText: String = ""
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var fullNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    lazy var statusLabel: UILabel = {
        let status = UILabel()
        status.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        status.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        status.text = NSLocalizedString("Waiting for something...", comment: "")
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    private lazy var setStatusButton = CustomButton(title: "Show status",
                                                     cornerRadius: 4,
                                                     titleColor: UIColor.createColor(lightMode: .white, darkMode: .black),
                                                     color: .systemBlue)
    
    private lazy var statusTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        text.textAlignment = .center
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.createColor(lightMode: .systemGray2, darkMode: .white).cgColor
        text.layer.cornerRadius = 12
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        text.placeholder = NSLocalizedString("write something", comment: "")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var changeTitle: UIButton = {
        let titleButton = UIButton()
        titleButton.setTitle(NSLocalizedString("Profile", comment: ""), for: .normal)
        titleButton.setTitleColor(UIColor.createColor(lightMode: .black, darkMode: .white), for: .normal)
        titleButton.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        return titleButton
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
        addTarget()
        setUser(avatar: UIImage(named: "avatarImage")!, name: "BeliyBear", status: "")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTarget(){
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    func addSubview() {
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(setStatusButton)
        addSubview(statusTextField)
        addSubview(changeTitle)
    }
    
    func setUser(avatar: UIImage, name: String, status: String ) {
        avatarImageView.image = currentUser.avatar
        fullNameLabel.text = currentUser.name
        statusLabel.text = currentUser.status
    }
    
    func setupConstraints() {
        setStatusButton.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.snp.makeConstraints ({ make in
            make.top.equalTo(changeTitle.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(100)
        })
        fullNameLabel.snp.makeConstraints({ make in
            make.top.equalTo(changeTitle.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
        })
        setStatusButton.snp.makeConstraints ({ make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(50)
        })
        statusLabel.snp.makeConstraints ({ make in
            make.bottom.equalTo(setStatusButton.snp.top).offset(-50)
            make.left.equalTo(avatarImageView.snp.right).offset(25)
        })
        statusTextField.snp.makeConstraints ({ make in
            make.bottom.equalTo(setStatusButton.snp.top).offset(-5)
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-16)
            make.left.equalTo(avatarImageView.snp.right).offset(25)
            make.height.equalTo(40)
        })
        changeTitle.snp.makeConstraints ({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        })
    }
    
    @objc private func buttonPressed() {
        setStatusButton.target = { [self] in
            print(statusTextField.text ?? NSLocalizedString("No text", comment: ""))
            statusLabel.text = statusTextField.text
            statusText = statusTextField.text ?? NSLocalizedString("No text", comment: "")
            self.endEditing(true)
        }
    }
}
