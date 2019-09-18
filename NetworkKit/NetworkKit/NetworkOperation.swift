//
//  NetworkOperation.swift
//  DirectMessaging
//
//  Created by Shrirang Kawade on 15/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import Foundation
import UIKit

class NetworkOperation: Operation {
    
    // MARK:- Properties
    let urlRequest: URL
    var completion: ((_ response: Any?, _ error: Error?) -> Void)
    let webServiceName: String
    var networkService: NetworkServices = .JSON
    
    // MARK:- Lifecycle Methods
    init(urlRequest: URL, networkService: NetworkServices, webServiceName: String, completionHandler: @escaping ((_ response: Any?, _ error: Error?) -> Void)) {
        self.urlRequest = urlRequest
        completion = completionHandler
        self.webServiceName = webServiceName
        self.networkService = networkService
        super.init()
        let networkOperationManager = NetworkOperationManager.shared
        networkOperationManager.webServiceRequestQueue.addOperation(self)
    }
    
    override func main() {
        if isCancelled {
            completion(nil, nil)
            return
        }
        
        // Call Web Service
        let sessionManager = SessionManager()
        // Give callback with response OR error
        
        switch networkService {
        case .imageDownload:
            sessionManager.dowloadImage(url: urlRequest) { (response, error) in
                if self.isCancelled {
                    self.completion(nil, nil)
                    return
                }
                self.completion(response, error)
            }
        case .fileDownload:
            sessionManager.downloadFile(url: urlRequest) { (response, error) in
                if self.isCancelled {
                    self.completion(nil, nil)
                    return
                }
                self.completion(response, error)
            }
        case .XML:
            sessionManager.dataRequest(url: urlRequest) { (response, error) in
                if self.isCancelled {
                    self.completion(nil, nil)
                    return
                }
                self.completion(response, error)
            }
        default:
            sessionManager.dataRequest(url: urlRequest) { (response, error) in
                if self.isCancelled {
                    self.completion(nil, nil)
                    return
                }
                do {
                    let responseData = try JSONSerialization.jsonObject(with: response as! Data, options: [JSONSerialization.ReadingOptions.mutableContainers])
                    self.completion(responseData, error)
                } catch {
                    self.completion(nil, nil)
                }
            }
        }
    }
}
