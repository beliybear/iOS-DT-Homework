import UIKit
import SnapKit

class FeedPostTableViewCell: UITableViewCell {
    
    var post: Post!
    var delegate: FeedDelegate?
    
    private let images: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFit
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    private let author: UILabel = {
        let authors = UILabel()
        authors.font = UIFont.boldSystemFont(ofSize: 20)
        authors.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        authors.numberOfLines = 2
        authors.translatesAutoresizingMaskIntoConstraints = false
        return authors
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptions = UILabel()
        descriptions.font = UIFont.systemFont(ofSize: 14)
        descriptions.textColor = .systemGray
        descriptions.numberOfLines = 0
        descriptions.translatesAutoresizingMaskIntoConstraints = false
        return descriptions
    }()
    
    private let likes: UILabel = {
        let likes = UILabel()
        likes.font = UIFont.systemFont(ofSize: 16)
        likes.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addTargets()
        #if DEBUG
//        backgroundColor = .cyan
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup () {
        if post.image != nil {
            images.image = UIImage(data: post.image!)
        }
        author.text = post.author
        descriptionLabel.text = post.text
        likes.text = "\(NSLocalizedString("likes-profileVC-localizable", comment: "")): \(post.likes)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        images.image = nil
        author.text = nil
        descriptionLabel.text = nil
        likes.text = nil
    }
    
    private func setupView() {
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubview(images)
        contentView.addSubview(author)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likes)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            
            author.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            author.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            author.heightAnchor.constraint(equalToConstant: 30),

            images.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 16),
            images.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            images.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            images.heightAnchor.constraint(equalTo: images.widthAnchor, multiplier: 1),

            descriptionLabel.topAnchor.constraint(equalTo: images.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            likes.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            likeButton.leadingAnchor.constraint(equalTo: likes.trailingAnchor, constant: 16),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
        ])
        
    }
    
    private func addTargets() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(authorPressed))
        author.isUserInteractionEnabled = true
        author.addGestureRecognizer(tap)


    }
    
    func updateLikesUI() {
        likes.text = "\(NSLocalizedString("likes-profileVC-localizable", comment: "")): \(post.likes)"
    }
    
    @objc
    private func likeButtonTapped() {
        guard let currentUser = CoreDataManeger.defaulManager.user else {
            return
        }
    
        if CoreDataManeger.defaulManager.isLiked(post: post, by: currentUser) {
            if let like = CoreDataManeger.defaulManager.getLike(post: post, by: currentUser) {
                CoreDataManeger.defaulManager.removeLike(like: like)
                post.likes -= 1
            }
            
        } else {
            CoreDataManeger.defaulManager.addLike(user: currentUser, post: post)
            post.likes += 1
        }
        updateLikesUI()
    }
    
    @objc func authorPressed(sender:UITapGestureRecognizer) {
        let profileVC = ProfileViewController(user: post.user ?? User(), viewModel: ProfileViewModel(), isUser: false)
        delegate?.authorPressed(viewController: profileVC)
    }
    
}
