//
//  ViewController.swift
//  Storiboard_CoreData
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    fileprivate typealias FeedsCallback = (_ model: [Feed]) -> (Void)
    fileprivate var items = [Feed]()
    fileprivate var apiManager: APIManager!
    fileprivate var timer: DispatchSourceTimer?
    fileprivate var tuple = (pageSize: 10, loading: false)
        
    deinit {
        self.stopTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseConfig()
    }
}

//MARK: - Private Methods -
extension ViewController {
    
    private func baseConfig() {
        self.title = "News Feed"
        
        setupInitialState()
    }

    fileprivate func setupTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
    
    fileprivate func setupInitialState() {

        apiManager = APIManager()
        
        if Reachability.isConnectedToNetwork() {
            getFeeds { [weak self] items in
                self?.update(with: items)
            }
        } else {
            DBManager.shared.getFeeds() { [weak self] items in
                self?.update(with: items)
            }
        }
    }
    
    fileprivate func update(with items: [Feed]) {
        self.items = items
        self.tableView.reloadData()
    }
    
    fileprivate func loadMore() {
        if !tuple.loading {
            tuple.pageSize += 10
            tuple.loading = true
            activityIndicatorView.startAnimating()
            
            getFeeds { [weak self] items in
                self?.tuple.loading = (items.count == 0)
                self?.activityIndicatorView.stopAnimating()
                
                if items.count > 0 {
                    let all = (self?.items)! + items
                    self?.update(with: all)
                }
            }
        }
    }
    
    fileprivate func loadMore(_ index: Int) {
        if !tuple.loading && index == tuple.pageSize - 1 {
            tuple.pageSize += 10
            tuple.loading = true
            activityIndicatorView.startAnimating()

            getFeeds { [weak self] items in
                self?.tuple.loading = (items.count == 0)
                self?.activityIndicatorView.stopAnimating()

                if items.count > 0 {
                    let all = (self?.items)! + items
                    self?.update(with: all)                }
            }
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate -
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        let item = self.items[indexPath.row]
        cell.setup(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMore(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK: - scrollViewDidScroll -
extension ViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
//            loadMore()
        }
    }
}

//MARK: - Timer -
extension ViewController {
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.arohak.AHNewsFeed")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(30))
        timer!.setEventHandler { [weak self] in
            self?.checkNewFeeds()
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

//MARK: - API -
extension ViewController {
    
    private func checkNewFeeds() {
        let path = "search"
        let params = ["format" : "json", "show-fields" : "thumbnail", "page-size" : "1"]
        apiManager.request(.get, path, params) { [weak self] data in
            guard let data = try? JSONDecoder().decode(NewsFeed.self, from: data) else { return }
            let response = data.response
            
            DBManager.shared.getLanding() { landing in
                if response.total != landing.total {
                    self?.tuple = (pageSize: 10, loading: false)
                    self?.setupInitialState()
                }

            }
        }
    }

    private func getFeeds(callback: @escaping FeedsCallback) {
        let path = "search"
        let params = ["format" : "json", "show-fields" : "thumbnail", "page-size" : "\(tuple.pageSize)"]
        apiManager.request(.get, path, params) { [weak self] data in
            guard let data = try? JSONDecoder().decode(NewsFeed.self, from: data) else { return }
            let response = data.response
            
            //putt in store and get items
            DBManager.shared.storeAndGetFeeds(response, pageSize: (self?.tuple.pageSize)!) { items in
                callback(items)
            }
        }
    }
}
