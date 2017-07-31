//
//  GnomesDetailViewController.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/29/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import UIKit

class GnomesDetailViewController: UIViewController {
    
    // MARK: - Types
    
    // Constants for Storyboard/ViewControllers.
    static let storyboardName = "GnomesHome"
    static let viewControllerIdentifier = "GnomeDetailViewController"
    
    // MARK: - Properties
    
    internal var gnome: Gnome!
    @IBOutlet weak var gnomeName: UILabel!
    @IBOutlet weak var gnomePicture: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var professionsLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var genderView: UIView!
    
    // MARK: - Initialization
    
    class func detailViewControllerForGnome(_ gnome: Gnome) -> GnomesDetailViewController {
        let storyboard = UIStoryboard(name: GnomesDetailViewController.storyboardName, bundle: nil)
        
        let detailVC = storyboard.instantiateViewController(withIdentifier: GnomesDetailViewController.viewControllerIdentifier) as! GnomesDetailViewController
        
        detailVC.gnome = gnome
        
        return detailVC
    }
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gnomeName.text = gnome.name
        NetworkClient.shared.setGnomePicture(imageURL: gnome.imageURL!, imageView: gnomePicture)
        ageLabel.text = String(gnome.age)
        weightLabel.text = String(gnome.weight)
        heightLabel.text = String(gnome.height)
        hairLabel.text = gnome.hair_color
        professionsLabel.text = getProfessions()
        friendsLabel.text = getFriends()
        genderView.backgroundColor = gnome.gender == .male ? UIColor.lightBlue() : UIColor.pink()
        
    }
    
    func getFriends() -> String{
        
        guard gnome.friends.count > 0 else {
            return "Aparently I don't have any friends!"
        }
        return gnome.friends.joined(separator: " - ")
        
    }
    
    func getProfessions() -> String{
        
        guard gnome.friends.count > 0 else {
            return "Aparently I do nothing for living!"
        }
        return gnome.professions.joined(separator: " - ")
        
    }
}
