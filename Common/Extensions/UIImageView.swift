//
//  UIImageView.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func download(image url: URL?) {
        guard let url = url else { return }
        
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        })
        task.resume()
    }
}

