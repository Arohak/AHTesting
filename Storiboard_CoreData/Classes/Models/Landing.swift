//
//  Landing.swift
//  Storiboard_CoreData
//
//  Created by Ara Hakobyan on 05/02/2018.
//  Copyright © 2018 Ara Hakobyan. All rights reserved.
//

import Foundation
import CoreData

class Landing: NSManagedObject {
    
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Landing> {
//        return NSFetchRequest<Landing>(entityName: "Landing");
//    }
    
    @NSManaged var page: Int
    @NSManaged var total: Int
    @NSManaged var status: String!
    @NSManaged var feeds: [Feed]
}

class Feed: NSManagedObject {
    
    @NSManaged var id: String!
    @NSManaged var webTitle: String!
    @NSManaged var sectionName: String!
    @NSManaged var pillarName: String!
    @NSManaged var thumbnail: String!
}


//class NewsFeed: NSManagedObject, Decodable {
//
//    @NSManaged var response: Response
//
//    required convenience init(from decoder: Decoder) throws {
//        guard let contextUserInfoKey = CodingUserInfoKey.context else { fatalError() }
//        guard let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError() }
//        guard let entity = NSEntityDescription.entity(forEntityName: "NewsFeed", in: context) else { fatalError() }
//
//        self.init(entity: entity, insertInto: nil)
//
//        // Decode
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        self.response = Response(from: )
//    }
//}
//
//class Response: NSManagedObject, Decodable {
//
//    @NSManaged var page: Int
//    @NSManaged var status: String
//    @NSManaged var results: [Result]
//
//    required convenience init(from decoder: Decoder) throws {
//        guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context") else { fatalError() }
//        guard let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError() }
//        guard let entity = NSEntityDescription.entity(forEntityName: "Response", in: context) else { fatalError() }
//
//        self.init(entity: entity, insertInto: nil)
//
//        // Decode
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        self.page = try container.decodeIfPresent(Int.self, forKey: .page)
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case page = "pageSize"
//        case status
//        case results
//    }
//}
//
//class Result: NSManagedObject {
//
//    @NSManaged var id: String!
//    @NSManaged var webTitle: String!
//    @NSManaged var sectionName: String!
//    @NSManaged var pillarName: String!
//    @NSManaged var fields: Field
//
//    required convenience init(from decoder: Decoder) throws {
//        guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context") else { fatalError() }
//        guard let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError() }
//        guard let entity = NSEntityDescription.entity(forEntityName: "Feed", in: context) else { fatalError() }
//
//        self.init(entity: entity, insertInto: nil)
//
//        // Decode
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decodeIfPresent(String.self, forKey: .id)
//        self.webTitle = try container.decodeIfPresent(String.self, forKey: .webTitle)
//        self.sectionName = try container.decodeIfPresent(String.self, forKey: .sectionName)
//        self.pillarName = try container.decodeIfPresent(String.self, forKey: .pillarName)
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case webTitle
//        case sectionName
//        case pillarName
//    }
//}
//
//class Field: NSManagedObject, Decodable {
//
//    @NSManaged var thumbnail: String!
//
//    required convenience init(from decoder: Decoder) throws {
//        guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context") else { fatalError() }
//        guard let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError() }
//        guard let entity = NSEntityDescription.entity(forEntityName: "Field", in: context) else { fatalError() }
//
//        self.init(entity: entity, insertInto: nil)
//
//        // Decode
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
//    }
//
//    public enum CodingKeys: String, CodingKey {
//        case thumbnail
//    }
//}
