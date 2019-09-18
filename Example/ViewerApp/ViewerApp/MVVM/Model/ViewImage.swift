//
//  ViewImage.swift
//  ViewerApp
//
//  Created by Shrirang Kawade on 18/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import Foundation
import UIKit

class ViewImage {
    
    // MARK:- Properties
    let userId: String?
    let userName: String?
    let imageUrl: String?
    var imageDownloadStarted: Bool = false
    var imageDownloaded: Bool = false
    var image: UIImage? {
        didSet {
            imageDownloaded = image != nil ? true : false
            imageDownloadStarted = image != nil ? true : false
        }
    }
    
    // MARK:- Lifecycle Method
    init(id: String, name: String, imageUrl: String) {
        userId = id
        userName = name
        self.imageUrl = imageUrl
    }
    
    // MERK:- Public Methods
    func downloadImage(completion: @escaping ((_ image: UIImage?) -> Void)) {
        if imageDownloaded || imageDownloadStarted {
            // skip to download
        } else {
            imageDownloadStarted = true
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: self.imageUrl ?? "")!) {
                    let imageInstance = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.image = imageInstance
                        completion(imageInstance)
                    }
                }
            }
        }
    }
}
