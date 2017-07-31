//
//  GnomesResutlTableController.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/30/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import UIKit

class GnomesResutlTableController: BaseGnomesTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Properties
    
    internal var filteredGnomes = [Gnome]()
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGnomes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GnomeTableViewCell")!
        let gnome = filteredGnomes[indexPath.row]
        configureCell( cell as! GnomeTableViewCell, gnome: gnome)
        
        return cell
    }
}
