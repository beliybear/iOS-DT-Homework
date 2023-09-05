//
//  PostViewController.swift
//  Navigation
//
//  Created by Ian Belyakov on 01.08.2023
//

import UIKit

class PostViewController: UIViewController {
    
    var source = SecondPost(title: "Some title")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "First Text"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.text = source.title
        setupConstraints()
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
}
