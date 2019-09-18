//
//  ViewController.swift
//  ViewerApp
//
//  Created by Shrirang Kawade on 18/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import UIKit
import AVFoundation
import NetworkKit.Swift

class ViewController: UICollectionViewController {
    
    // MARK:- Properties
    let listDataTransfer = ListDataTransfer()
    let refreshControl = UIRefreshControl()
    var viewModel = ImageViewModel()
    
    // MARK:- Private Methods
    @objc private func getUserList() {
        listDataTransfer.getUserList()
    }
    
    // MARK:- Lifecycle Method
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listDataTransfer.delegate = self
        getUserList()
        if let layout = collectionView?.collectionViewLayout as? CollectionViewLayout {
            layout.delegate = self
        }
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        collectionView?.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(getUserList), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCellIdentifier", for: indexPath as IndexPath) as! PhotoCollectionViewCell
        cell.viewImage = viewModel.photos[indexPath.item]
        cell.imageView?.image = cell.viewImage?.image
        cell.viewImage?.downloadImage(completion: { (image) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension ViewController: CollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return viewModel.getHeightForImageView()
    }
}

extension ViewController: DataTransferDelegate {
    
    func didRecieveResponse(parser: BaseDataTransfer, response: Any?) {
        viewModel.photos = response as! [ViewImage]
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func didRecieveError(parser: BaseDataTransfer, error: Error?) {
        
    }
}

