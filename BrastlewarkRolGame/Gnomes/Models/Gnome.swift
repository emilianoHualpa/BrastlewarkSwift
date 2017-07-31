//
//  Gnome.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/29/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import Foundation

public final class Gnome: NSObject {
    
    public enum GnomeGender: String{
        case male
        case female
    
        public var gnomeGender : String {
            switch self {
                case .male : return NSLocalizedString("Male", comment: "")
                case .female : return NSLocalizedString("Female", comment: "")
            }
        }

    }
    
    internal struct Keys {
        static let id = "id"
        static let name = "name"
        static let thumbnail = "thumbnail"
        static let age = "age"
        static let weight = "weight"
        static let height = "height"
        static let hair_color = "hair_color"
        static let professions = "professions"
        static let friends = "friends"
    }
    
    internal static var tableName = "gnomes"
    
    // MARK: - Instance Properties
    public let identifier: Int?
    public let name: String
    public let imageURL: URL?
    public let age: Int
    public let weight: Double
    public let height: Double
    public let hair_color: String
    public let professions: Array<String>
    public let friends: Array<String>
    public let gender: GnomeGender
    
    // MARK: - Object Lifecycle
    public init?(json: [String: Any]) {
        
        let imageURL: URL?
        
        if let imageURLString = json[Keys.thumbnail] as? String {
            imageURL = URL(string: imageURLString)
            
        } else {
            imageURL = nil
        }
        
        guard let identifier = json[Keys.id] as? Int,
            let name = json[Keys.name] as? String,
            let age = json[Keys.age] as? Int,
            let weight = json[Keys.weight] as? Double,
            let height = json[Keys.height] as? Double,
            let hair_color = json[Keys.hair_color] as? String,
            let professions = json[Keys.professions] as? Array<String>,
            let friends = json[Keys.friends] as? Array<String> else {
            return nil
        }
        
        self.identifier = identifier
        self.name = name
        self.age = age
        self.imageURL = imageURL
        self.weight = weight
        self.height = height
        self.hair_color = hair_color
        self.professions = professions
        self.friends = friends
        self.gender = (hair_color != "Pink") ? .male : .female
    }
    
    public init(imageURL: URL?,
                name: String,
                age: Int,
                weight: Double,
                height: Double,
                hair_color: String,
                professions: Array<String>,
                friends: Array<String>,
                gender: GnomeGender) {
        
        self.identifier = nil
        self.name = name
        self.age = age
        self.imageURL = imageURL
        self.weight = weight
        self.height = height
        self.hair_color = hair_color
        self.professions = professions
        self.friends = friends
        self.gender = (hair_color != "Pink") ? .male : .female
    }
    
    // MARK: - Class Constructors
    public class func array(jsonArray: [[String: Any]]) -> [Gnome] {
        var array: [Gnome] = []
        for json in jsonArray {
            guard let gnome = Gnome(json: json) else { continue }
            array.append(gnome)
        }
        return array
    }
   
}
