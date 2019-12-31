//
//  NetworkService.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import Foundation
import UIKit

enum DataError: Error {
    case emptyData
    case invalidJSON
    case networkError(error:Error)
    case invalidResponse(Data?, URLResponse?)
    
    func message() -> String {
        switch self {
        case .emptyData:
            return "Service returned empty data"
        case .invalidJSON:
            return "Data validation error"
        default:
            return "We are experiencing technical issues. Please try again later."
        }
    }
}


protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (Result<ModelType, DataError>) -> Void)
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (Result<ModelType, DataError>) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            // Check for network error
            if let error = error {
                completion(.failure(.networkError(error: error)))
                return
            }
            
            // Handle invalid http response
            guard let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completion(.failure(.invalidResponse(data, response)))
                    return
            }
            
            // Handle empty response data
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            // Check for decoding error
            guard let model = self?.decode(data) else {
                completion(.failure(.invalidJSON))
                return
            }
            
            completion(.success(model))
            
        })
        task.resume()
    }
}

class ImageRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ImageRequest: NetworkRequest {
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func load(withCompletion completion: @escaping (Result<UIImage, DataError>) -> Void) {
        
        let imageCache = ImageDownloadManager.shared.imageCache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
        }
        
        load(url, withCompletion: completion)
    }
}

class APIRequest<Resource: APIResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> [Album]? {
        do {
            let wrapper = try JSONDecoder().decode(Results.self, from: data)
            return wrapper.results
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func load(withCompletion completion: @escaping (Result<[Album], DataError>) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}

protocol APIResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
}

extension APIResource {
    var url: URL {
        guard var components = URLComponents(string: Constants.host) else {
            fatalError("Invalid Host Url")
        }
        
        components.path = methodPath
        
        guard let apiURL = components.url else {
            fatalError("Invalid API Url")
        }
        
        return apiURL
    }
}

struct AlbumsResource: APIResource {
    typealias ModelType = Album
    let methodPath = Constants.albumEndpoint
}
