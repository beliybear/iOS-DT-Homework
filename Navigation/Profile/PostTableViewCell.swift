
import UIKit

class PostTableViewCell: UITableViewCell {
    
    var post: Post!
    var delegate: ProfileDelegate?
    var buttonTapCallback: () -> ()  = { }
    
    private let images: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFit
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    private let authors: UILabel = {
        let authors = UILabel()
        authors.font = UIFont.boldSystemFont(ofSize: 20)
        authors.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        authors.numberOfLines = 2
        authors.translatesAutoresizingMaskIntoConstraints = false
        return authors
    }()
    
    private let descriptions: UILabel = {
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
        addSingleAndDoubleTapGesture()
        addTargets()
        #if DEBUG
//        backgroundColor = .cyan
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        images.image = nil
        authors.text = nil
        descriptions.text = nil
        likes.text = nil
    }
    
    func setup () {
        if post.image != nil {
            images.image = UIImage(data: post.image!)
        }
        authors.text = post.author
        descriptions.text = post.text
        likes.text = "\(NSLocalizedString("likes-profileVC-localizable", comment: "")): \(post.likes)"
    }
    
    private func addTargets() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func setupView() {
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubview(images)
        contentView.addSubview(authors)
        contentView.addSubview(descriptions)
        contentView.addSubview(likes)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            
            authors.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authors.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authors.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authors.heightAnchor.constraint(equalToConstant: 30),

            images.topAnchor.constraint(equalTo: authors.bottomAnchor, constant: 16),
            images.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            images.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            images.heightAnchor.constraint(equalTo: images.widthAnchor, multiplier: 1),

            descriptions.topAnchor.constraint(equalTo: images.bottomAnchor, constant: 16),
            descriptions.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptions.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            likes.topAnchor.constraint(equalTo: descriptions.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            likeButton.leadingAnchor.constraint(equalTo: likes.trailingAnchor, constant: 16),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
        ])
        
    }
    
    private func addSingleAndDoubleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)
    }

    @objc
    private func singleTap() {
        guard let currentUser = CoreDataManeger.defaulManager.user else {
            return
        }
        if CoreDataManeger.defaulManager.isAuthorOfPost(post: post, user: currentUser) {
            delegate?.changePost(post: post)
        } else {
            print("Error: only the author can edit the post")
        }
    }
    
    @objc
    private func likeButtonTapped() {
        delegate?.likePost(post: post)
    }
}
