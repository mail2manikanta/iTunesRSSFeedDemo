//
//  ImageDownloader.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import Foundation
import UIKit


typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

final class ImageDownloadManager {
        
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.stanza.itunesImageDownload"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    static let shared = ImageDownloadManager()
    
    private init () {}
    
    func downloadImage(_ imageUrl: URL, indexPath: IndexPath, handler: @escaping ImageDownloadHandler) {
        
        if let cachedImage = imageCache.object(forKey: imageUrl.absoluteString as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
           handler(cachedImage, imageUrl, indexPath, nil)
        } else {
             /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [ImageLoadOperation])?.filter({$0.imageUrl.absoluteString == imageUrl.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                // Increase the priority
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                let operation = ImageLoadOperation(url: imageUrl, indexPath: indexPath)

                operation.downloadHandler = { (image, imageUrl, indexPath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: imageUrl.absoluteString as NSString)
                    }
                    handler(image, imageUrl, indexPath, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
}
