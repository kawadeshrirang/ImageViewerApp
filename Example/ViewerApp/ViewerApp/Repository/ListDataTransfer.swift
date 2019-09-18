//
//  ListDataTransfer.swift
//  ViewerApp
//
//  Created by Shrirang Kawade on 18/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import Foundation
import NetworkKit.Swift

class ListDataTransfer: BaseDataTransfer {
    
    // MARK:- Lifecycle Method
    init() {
        super.init(webServiceName: "http://pastebin.com/raw/wgkJgazE")
        self.networkService = .JSON
    }
    
    // MARK:- Public Methods
    func getUserList() {
        let urlRequest = URL(string: webServiceName)
        callWebServiceRequest(urlRequest: urlRequest!)
    }
    
    override func parseResponseData(responseData response: Any?) {
        DispatchQueue.global(qos: .background).async {
            var viewImages: [ViewImage] = []
            if let data = response as? [[String:Any]] {
                for imageData in data {
                    let userDictionary = imageData["user"] as! [String:Any]
                    let profileImageDictionary = userDictionary["profile_image"] as! [String:Any]
                    let imageUrl = profileImageDictionary["medium"] ?? ""
                    let userId = userDictionary["id"] ?? ""
                    let userName = userDictionary["username"] ?? ""
                    let viewImage = ViewImage(id: userId as! String, name: userName as! String, imageUrl: imageUrl as! String)
                    viewImages.append(viewImage)
                }
            }
            self.delegate?.didRecieveResponse(parser: self, response: viewImages)
        }
    }
}
