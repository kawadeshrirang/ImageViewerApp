//
//  SessionManager.swift
//  DirectMessaging
//
//  Created by Shrirang Kawade on 15/09/19.
//  Copyright © 2019 Shrirang Kawade. All rights reserved.
//

import Foundation
import UIKit

class SessionManager: NSObject {
    
    // MARK:- Properties
    var session: URLSession?
    var data: Data = Data()
    var queue: OperationQueue = OperationQueue()
    var completion:((_ response: Any?, _ error: Error?) -> Void)?
    
    // MARK:- Private Methods
    func errorResponse(responseData:Any) -> Error? {
        return nil
    }
    
    private func storedCredentials(credential:URLCredentialStorage) -> URLCredentialStorage? {
        return nil
    }
    
    private func sessionConfiguration() -> URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    // MARK:- Lifecycle Method
    override init() {
        self.session = nil
        self.completion = nil
        self.data = Data()
    }
    
    // MARK:- Public Methods
    func dataRequest(url: URL, completion: @escaping((_ response: Any?, _ error: Error?) -> Void)) {
        self.completion = completion
        let request = URLRequest(url: url)
        self.session = URLSession(configuration: sessionConfiguration(), delegate: self, delegateQueue: self.queue)
        let task = self.session!.dataTask(with: request)
        task.resume()
    }
    
    func downloadFile(url: URL, completion: @escaping((_ response: Any?, _ error: Error?) -> Void)) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let randomNumber = arc4random_uniform(99999)
        let destinationUrl = documentsUrl.appendingPathComponent(String(format:"File-%ld", randomNumber))
        if FileManager().fileExists(atPath: destinationUrl.path) {
            // File already exists
            completion(destinationUrl.path, nil)
        } else {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url: url)
            
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationUrl)
                        DispatchQueue.main.async() {
                            completion(destinationUrl.path, nil)
                        }
                    } catch (let writeError) {
                        DispatchQueue.main.async() {
                            completion(nil, writeError)
                        }
                    }
                } else {
                    DispatchQueue.main.async() {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func dowloadImage(url: URL, completion: @escaping((_ response: Any?, _ error: Error?) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil, error)
                return
            }
            DispatchQueue.main.async() {
                completion(image, nil)
            }
        }.resume()
    }
}

extension SessionManager: URLSessionDelegate, URLSessionDataDelegate {
    
    // MARK:- URLSessionDelegate Methods
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        self.completion!(nil, error)
    }
    
    // MARK:- URLSessionDataDelegate Methods
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let urlSessionResponseDisposition = URLSession.ResponseDisposition.allow
        completionHandler(urlSessionResponseDisposition)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if (error != nil) {
            self.urlSession(session, didBecomeInvalidWithError: error)
        } else {
            let responseStatusCode = (task.response as! HTTPURLResponse).statusCode
            if responseStatusCode == 200 {
                self.completion!(self.data, nil)
            } else {
                // Handle Error for reponse with other status codes
                let error: Error? = errorResponse(responseData: "")
                self.urlSession(session, didBecomeInvalidWithError: error)
            }
        }
    }
}
