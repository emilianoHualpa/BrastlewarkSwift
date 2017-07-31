//
//  GnomesLoaderViewController.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/30/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import UIKit

class GnomesLoaderViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    internal let networkClient = NetworkClient.shared
    internal var gnomes: [Gnome] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.hidesWhenStopped = true
        self.getGnomes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    // MARK: - Private
    func getGnomes() {
        self.spinner.startAnimating()
        networkClient.getGnomes(
            town: .Brastlewark,
            success: {
                [weak self] gnomesInTown in
                guard let strongSelf = self else {return}
                strongSelf.gnomes = gnomesInTown
                strongSelf.spinner.stopAnimating()
                strongSelf.performSegue(withIdentifier: "GnomeMain", sender: self)
                
            }, failure: { [weak self] error in
                print("Gnomes download failed: \(error)")
                guard let strongSelf = self else { return }
                strongSelf.showError()
        })
    }
    
    private func showError() {
        let alert = UIAlertController(title: NSLocalizedString("ERROR", comment: ""), message: NSLocalizedString("There was an error and we couldn't find any inhabitant 👹 in Brastlewark, please try again.", comment: ""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:""), style: .default, handler: { action in
            self.getGnomes()
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment:""), style: .cancel, handler: { action in
            //self.showTryAgain()
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
    }

    
    func showTryAgain() {
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        let destinationNavigationController = segue.destination as! UINavigationController
        let gnomesTableVC = destinationNavigationController.topViewController as? GnomesTableViewController
        gnomesTableVC?.gnomes = self.gnomes
    }

    
}
