import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    private enum Constants {
        static let numberOfItemsInLine: CGFloat = 3
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var photosNames = PhotosNames()
    private var allImages: [UIImage] = []
    private var allImagesProcessed: [UIImage] = []
    let imageProcessor = ImageProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        allImages = PhotoData.photos
        setupConstraints()
        setupButton()
        
        let start = CFAbsoluteTimeGetCurrent()
        imageProcessor.processImagesOnThread(sourceImages: allImages, filter: .fade, qos: .default) { [weak self] completion in
            guard let self = self else { return }
            self.allImagesProcessed = completion.compactMap { $0.flatMap { UIImage(cgImage: $0) } }
            
            let diff = CFAbsoluteTimeGetCurrent() - start
//            print("Took \(diff) seconds")
            
            DispatchQueue.main.async {
                self.allImages = self.allImagesProcessed
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupButton() {
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: self, action: #selector(pushCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc private func pushCancelButton(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = NSLocalizedString("Photo Gallery", comment: "")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? ProfileCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.photoImageView.image = allImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        let width = collectionView.frame.width - (Constants.numberOfItemsInLine - 1) * interItemSpacing - insets.left - insets.right
        let itemWidth = floor(width / Constants.numberOfItemsInLine)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
