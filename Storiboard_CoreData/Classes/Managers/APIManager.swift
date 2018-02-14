//
//  APIHelper.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation
import SystemConfiguration

typealias CompletionBlock = (_ result: Data) -> Void

public enum HttpMethod : String {
    case get, post, put, patch, delete
    
    var string: String {
        return self.rawValue.uppercased()
    }
}

public class APIManager {
    
    //MARK: - API Config -
    let baseURL = ConfigHelper.getApiBaseUrl()
    let header = ["api-key" : "test"]
    
    fileprivate let session: URLSession
    
    public init(with session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        URLCache.shared = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
    }
    
    //MARK: - Public Methods -
    func request(_ method: HttpMethod,
                 _ path: String,
                 _ params: [String: String]? = nil,
                 completion: @escaping CompletionBlock)
    {
        guard let baseURL = URL(string: baseURL) else { return }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path + "/" + path
        urlComponents.queryItems = params?.toQueryItems

        guard let url = urlComponents.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.string
        urlRequest.allHTTPHeaderFields = header
        
        let task = session.dataTask(with: urlRequest) { (data, urlReponse, error) in
            guard let data = data, error == nil else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            print(json)
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        task.resume()
    }
    
    func loadData(at url: URL, completion: @escaping CompletionBlock) {
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        task.resume()
    }
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}

extension Dictionary where Key == String, Value == String {
    
    var toQueryItems: [URLQueryItem]? {
        var temp: [URLQueryItem]? = []
        for obj in self {
            let queryItem = URLQueryItem(name: obj.key, value: obj.value)
            temp?.append(queryItem)
        }
        
        return temp
    }
}
