//
//  ImageViewModel.swift
//  ViewerApp
//
//  Created by Shrirang Kawade on 18/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import Foundation
import UIKit

struct ImageViewModel {
    
    // MARK:- Properties
    var photos: [ViewImage] = []
    
    // MARK:- Public Method
    func getHeightForImageView() -> CGFloat {
        let heights: [CGFloat] = [175.0, 125.0, 150.0, 200.0, 250.0]
        let index = Int(arc4random_uniform(UInt32(heights.count)))
        return heights[index]
    }
}
