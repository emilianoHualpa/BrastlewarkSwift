//
//  BaseTableViewController.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/30/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import UIKit

class BaseGnomesTableViewController: UITableViewController {
    
    internal var networkClient = NetworkClient.shared
    
    // MARK: - Types
    
    static let nibName = "GnomeTableViewCell"
    static let tableViewCellIdentifier = "GnomeTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseGnomesTableViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BaseGnomesTableViewController.tableViewCellIdentifier)
    }
    
    func configureCell (_ cell: GnomeTableViewCell, gnome: Gnome) {
        cell.selectionStyle = .none
        cell.gnomeNameLabel.text = gnome.name
        cell.gnomeAgeLabel.text = "Age: \(String(gnome.age))"
        networkClient.setGnomePicture(imageURL: gnome.imageURL!, imageView: cell.gnomeImageView)
        
        cell.gnomeGenderView.backgroundColor = gnome.gender == .male
        ? UIColor.lightBlue()
        : UIColor.pink()
    }
    
    
}

extension UIColor {
    static func pink() -> UIColor{
        return UIColor(red: 219/255, green: 105/255, blue: 124/255, alpha: 1.0)
    }
    
    static func lightBlue() -> UIColor{
        return UIColor(red: 91/255, green: 173/255, blue: 191/255, alpha: 1.0)
    }
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let cellIdentifier: String =  String(describing:T.self)
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellIdentifier)")
        }
        return cell
    }
    
    func animateTable() {
        self.reloadData()
        
        let cells = self.visibleCells
        let tableHeight: CGFloat = self.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    func scrollToTop () {
        self.setContentOffset(CGPoint.zero, animated: true)
    }
}
