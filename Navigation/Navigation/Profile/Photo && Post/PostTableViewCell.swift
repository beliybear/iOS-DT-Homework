//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Beliy.Bear on 02.01.2023.
//

import UIKit
import CoreData

class PostTableViewCell: UITableViewCell {
    
    struct ViewPost {
        var author: String
        var descriptionText: String
        var image: UIImage
        var likes: Int
        var views: Int
        var postId: String
    }
    
    private lazy var authorText: UITextView = {
        let authorText = UITextView()
        authorText.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        authorText.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        authorText.textContainer.maximumNumberOfLines = 2
        authorText.translatesAutoresizingMaskIntoConstraints = false
        authorText.isScrollEnabled = false
        authorText.isEditable = false
        authorText.isUserInteractionEnabled = false
        return authorText
    }()
    
    private lazy var descriptionText: UITextView = {
        let descriptionText = UITextView()
        descriptionText.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        descriptionText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.isScrollEnabled = false
        descriptionText.isEditable = false
        descriptionText.isUserInteractionEnabled = false
        return descriptionText
    }()
    
    private lazy var postImage: UIImageView = {
        let postImage = UIImageView()
        postImage.contentMode = .scaleAspectFit
        postImage.translatesAutoresizingMaskIntoConstraints = false
        return postImage
    }()
    
    private lazy var stackViewHorizontal: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private var indexPath: IndexPath?
    
    private var viewPost: ViewPost?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorText.text = nil
        descriptionText.text = nil
        postImage.image = nil
    }
    
    func setup(with viewPost: ViewPost) {
        self.viewPost = viewPost
        authorText.text = viewPost.author
        descriptionText.text = viewPost.descriptionText
        postImage.image = viewPost.image
        likesLabel.text = "Likes: \(viewPost.likes)"
        viewLabel.text = "Views: \(viewPost.views)"
    }
    
    private func animateHeart() {
        heartImageView.isHidden = false
        heartImageView.alpha = 1.0
        heartImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.heartImageView.transform = CGAffineTransform.identity
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.heartImageView.alpha = 0.0
            }, completion: { _ in
                self.heartImageView.isHidden = true
            })
        })
    }
    
    @objc private func handleDoubleTap() {
        guard let viewPost = viewPost else { return }
        if !CoreDataStack.shared.isPostLiked(postId: viewPost.postId) {
            CoreDataStack.shared.saveLikedPost(viewPost: viewPost, postId: viewPost.postId)
            animateHeart()
        }
    }
    
    private func setupView() {
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        isHighlighted = false
        addSubview(authorText)
        addSubview(descriptionText)
        addSubview(postImage)
        addSubview(stackViewHorizontal)
        addSubview(heartImageView)
        stackViewHorizontal.addArrangedSubview(likesLabel)
        stackViewHorizontal.addArrangedSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            
            authorText.topAnchor.constraint(equalTo: self.topAnchor),
            authorText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            authorText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            postImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0),
            postImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0),
            postImage.topAnchor.constraint(equalTo: authorText.bottomAnchor),
            postImage.bottomAnchor.constraint(equalTo: descriptionText.topAnchor),
            
            descriptionText.bottomAnchor.constraint(equalTo: stackViewHorizontal.topAnchor),
            descriptionText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            descriptionText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            stackViewHorizontal.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackViewHorizontal.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackViewHorizontal.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackViewHorizontal.heightAnchor.constraint(equalToConstant: 40),
            
            heartImageView.centerXAnchor.constraint(equalTo: postImage.centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: postImage.centerYAnchor),
            heartImageView.widthAnchor.constraint(equalToConstant: 100),
            heartImageView.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
}
