//
//  DBHelper.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation
import CoreData

public class DBManager {
    
    static let shared = DBManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - NewsFeed -
    func storeAndGetFeeds(_ response: Response, pageSize: Int, callback: @escaping ([Feed]) -> (Void)) {
        persistentContainer.performBackgroundTask { context in
            let landing = Landing(context: context)
            landing.page = response.page
            landing.total = response.total
            landing.status = response.status

            response.results.forEach { obj in
                let feed = Feed(context: context)
                feed.id = obj.id
                feed.webTitle = obj.webTitle
                feed.pillarName = obj.pillarName
                feed.sectionName = obj.sectionName
                feed.thumbnail = obj.fields.thumbnail
                
                landing.feeds.append(feed)
            }
            try? context.save()

            self.getFeeds(pageSize) { items in
                callback(items)
            }
        }
    }
    
    func getLanding(callback: @escaping (Landing) -> (Void)) {
        persistentContainer.viewContext.perform {
            let request = Landing.fetchRequest() as! NSFetchRequest<Landing>
            guard let matches = try? self.persistentContainer.viewContext.fetch(request), let landing = matches.first else { return }
            
            callback(landing)
        }
    }
    
    func getFeeds(callback: @escaping ([Feed]) -> (Void)) {
        persistentContainer.viewContext.perform {
            let request = Feed.fetchRequest() as! NSFetchRequest<Feed>
            guard let matches = try? self.persistentContainer.viewContext.fetch(request) else { return }
            
            callback(matches)
        }
    }
    
    func getFeeds(_ pageSize: Int, callback: @escaping ([Feed]) -> (Void)) {
        persistentContainer.viewContext.perform {
            let request = Feed.fetchRequest() as! NSFetchRequest<Feed>
//            request.predicate = NSPredicate(format: "")
//            request.sortDescriptors = [NSSortDescriptor(key: "", ascending: true)]
            guard let matches = try? self.persistentContainer.viewContext.fetch(request) else { return }
            let feeds = Array(matches[pageSize - 10..<pageSize])

            callback(feeds)
        }
    }
}

