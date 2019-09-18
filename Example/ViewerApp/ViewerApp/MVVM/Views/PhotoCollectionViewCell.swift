//
//  PhotoCollectionViewCell.swift
//  ViewerApp
//
//  Created by Shrirang Kawade on 18/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK:- Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:- Properties
    var viewImage: ViewImage?
    
    // MARK:- Private Methods
    private func initialize() {
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    // MARK:- Lifecycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
}
