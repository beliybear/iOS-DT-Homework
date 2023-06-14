//
//  InfoViewController.swift
//  Navigation
//
//  Created by Beliy.Bear on 16.12.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 12
        stackView.backgroundColor = .white
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        stackView.layer.borderWidth = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let infoButton = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                         target: self,
                                         action: #selector(showSimpleAlert))
        self.navigationItem.rightBarButtonItem = infoButton
        
        networkManagerAct()
        addSubview()
        setupConstraints()
    }
    
    private lazy var networkManager = NetworkManager()
    
    // Задание 2.1 (IOS_DT)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Задание 2.2 (IOS_DT)
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
            let button = UIButton()
            button.backgroundColor = .systemGray
            button.layer.cornerRadius = 12
            button.setTitle(NSLocalizedString("Share", comment: ""), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            button.addTarget(self, action: #selector(showSimpleAlert), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    private func addSubview(){
        view.addSubview(stackView)
        view.addSubview(button)
        stackView.addSubview(titleLabel)
        stackView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
             button.heightAnchor.constraint(equalToConstant: 50),
             button.widthAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
             stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
             stackView.widthAnchor.constraint(equalToConstant: 300),
             stackView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10),
             titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
             descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func networkManagerAct() {
        networkManager.titleRequest { [weak self] title in
            self?.titleLabel.text = title
        }
        networkManager.orbitRequest { [weak self] title in
            self?.descriptionLabel.text = title
        }
    }
    
    @objc func showSimpleAlert() {
            let alert = UIAlertController(title: NSLocalizedString("Accepting", comment: ""),
                                          message: NSLocalizedString("Share this post?", comment: ""),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""),
                                      style: UIAlertAction.Style.cancel,
                                      handler: { (action) in print(NSLocalizedString("Ok, post shared", comment: ""))}))
        
            alert.addAction(UIAlertAction(title: "No",
                                  style: UIAlertAction.Style.default,
                                  handler: { (action) in print(NSLocalizedString("Ok, alert closed", comment: ""))}))
        
            self.present(alert, animated: true, completion: nil)
        }

    }

