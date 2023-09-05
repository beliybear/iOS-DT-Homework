//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Ian Belyakov on 01.08.2023
//

import UIKit
import iOSIntPackage
import MobileCoreServices

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentUser: User
    
    init(user: User) {
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageProcessor = ImageProcessor()
    var images: [UIImage] = [UIImage(systemName: "camera")!]
    var imagePickerController = UIImagePickerController()
    
    private enum Constants {
        static let numberOfItemsInLIne: CGFloat = 3
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        imagePickerController.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Photo Gallery"
        self.images = self.currentUser.images
        collectionView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func cancel() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        
        cell.images.image = currentUser.images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        
        let width = collectionView.frame.width - (Constants.numberOfItemsInLIne - 1) * interItemSpacing - insets.left - insets.right
        let itemWidth = floor(width / Constants.numberOfItemsInLIne)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && currentUser.isLogIn {
            loadImage()
        } else {
            if indexPath.row != 0 {
                let fullScreenVC = FullScreenViewController()
                fullScreenVC.image = currentUser.images[indexPath.row]
                navigationController?.pushViewController(fullScreenVC, animated: true)
            }
        }
        if indexPath.row == 0 && !currentUser.isLogIn{
            print("Error, you can't add photos to another account")
        }
    }
    
    func loadImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentUser.images.append(image)
            CoreDataManeger.defaulManager.saveContext()
            images = currentUser.images
            collectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if currentUser.isLogIn {
            guard let collectionView = gesture.view as? UICollectionView else { return }
        
            let touchPoint = gesture.location(in: collectionView)
            guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
        
            if indexPath.row != 0 {
                let alert = UIAlertController(title: "Remove Image", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
            
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.currentUser.images.remove(at: indexPath.row)
                    CoreDataManeger.defaulManager.saveContext()
                    self.images = self.currentUser.images
                    collectionView.reloadData()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true, completion: nil)
            }
        } else {
            print("Error: Only author can delete the photo")
        }
    }
}

extension PhotosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return currentUser.isLogIn
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.5) {
            cell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.5) {
            cell?.transform = CGAffineTransform.identity
        }
    }
}
