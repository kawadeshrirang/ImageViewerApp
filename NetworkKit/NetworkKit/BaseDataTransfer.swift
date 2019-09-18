//
//  BaseDataTransfer.swift
//  DirectMessaging
//
//  Created by Shrirang Kawade on 15/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import Foundation

public enum NetworkServices {
    case JSON
    case XML
    case fileDownload
    case imageDownload
}

// MARK:- Protocol
public protocol DataTransferDelegate: class {
    func didRecieveResponse(parser: BaseDataTransfer, response: Any?)
    func didRecieveError(parser: BaseDataTransfer, error: Error?)
}

// MARK:- Base Data Transfer Class
open class BaseDataTransfer: NSObject {
    
    // MARK:- Properties
    open weak var delegate: DataTransferDelegate?
    open var baseURL: String = "https://api.github.com/"
    open var webServiceName: String
    public var networkService: NetworkServices = .JSON
    
    // MARK:- Lifecycle Method
    public init(webServiceName: String) {
        self.webServiceName = webServiceName
    }
    
    // MARK:- Public Methods
    open func callWebServiceRequest(urlRequest url: URL) {
        let _ = NetworkOperation(urlRequest: url, networkService: networkService, webServiceName: webServiceName, completionHandler: { (responseData: Any?, error: Error?) in
            if responseData == nil && error == nil {
                self.delegate = nil
            } else {
                if self.delegate != nil {
                    if error != nil {
                        self.delegate!.didRecieveError(parser: self, error: error)
                    } else {
                        self.parseResponseData(responseData: responseData)
                    }
                }
            }
        })
    }
    
    open func parseResponseData(responseData response: Any?) {
        // Override this method in webservice data Transfer class
    }
}
