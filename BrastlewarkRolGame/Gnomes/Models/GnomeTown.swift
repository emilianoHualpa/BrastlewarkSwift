//
//  GnomeTown.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/29/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import Foundation

public enum GnomeTowns {
    case Brastlewark
    case Laekastel
    case Misarias
    case Remesiana
    case Ostenso
}

public final class GnomeTown {
    
    internal struct Keys {
        static let brastlewark = "Brastlewark"
        static let laekastel = "Laekastel"
        static let misarias = "Misarias"
        static let remesiana = "Remesiana"
        static let ostenso = "Ostenso"
    }
    
    // MARK: - Instance Properties
    public let townInhabitants: [Gnome]
    
    // MARK: - Object Lifecycle
    public init?(json: [String: Any], town: GnomeTowns) {
        
        switch town {
        case .Brastlewark:
            let gnomes = json[Keys.brastlewark]
            self.townInhabitants = Gnome.array(jsonArray: gnomes as! [[String : Any]])
        default:
            let gnomes = json[Keys.brastlewark]
            self.townInhabitants = Gnome.array(jsonArray: gnomes as! [[String : Any]])
        }
    }
    
    public init(town: Array<Gnome>) {
        
        self.townInhabitants = town

    }
 }
