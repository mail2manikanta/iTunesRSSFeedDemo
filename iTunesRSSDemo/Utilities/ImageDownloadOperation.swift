//
//  ImageDownloadOperation.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import Foundation
import UIKit

class ImageLoadOperation: Operation {
    
    private let lockQueue = DispatchQueue(label: "com.stanza.imageloadoperation", attributes: .concurrent)

    var downloadHandler: ImageDownloadHandler?
    
    var imageUrl: URL
    private var indexPath: IndexPath
   
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    
    private var _isExecuting = false

    
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    
    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    
    func executing(_ executing: Bool) {
        _isExecuting = executing
    }
    
    func finish(_ finished: Bool) {
        _isFinished = finished
    }
    
    required init (url: URL, indexPath: IndexPath) {
        self.imageUrl = url
        self.indexPath = indexPath
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        executing(true)
        downloadImageFromUrl()
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
       let downloadTask = newSession.downloadTask(with: self.imageUrl) { (location, response, error) in
        if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
             let image = UIImage(data: data)
            self.downloadHandler?(image,self.imageUrl, self.indexPath,error)
          }
        self.finish()
        }
        downloadTask.resume()
    }
}
