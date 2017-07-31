//
//  NewtorkClient.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/29/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

public final class NetworkClient {
    
    // MARK: Instance Properties
    
    internal let baseURL: URL
    internal let networkSession = URLSession.shared
    
    public static let shared: NetworkClient = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: file)!
        let urlString = dict["gnomes_url"] as! String
        let url = URL(string: urlString)!
        
        return NetworkClient(baseURL: url)
    }()
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func getGnomes ( town: GnomeTowns,
                            success successFn: @escaping ([Gnome]) -> Void,
                            failure failureFn: @escaping (NetworkError) -> Void) {
        
        Alamofire.request(self.baseURL).responseJSON { response in
            guard let json = response.result.value as? [String: Any] else {
                failureFn(NetworkError.networkProblem(response.error!))
                print("Response Error: \(response.error ?? "Unknown" as! Error )")
                return
            }
            
            print("JSON: \(json)") // serialized json response
            
            guard let gnomesInTown = GnomeTown(json: json, town: town)?.townInhabitants else {
                print("Error parsin GnomesTown")
                return
            }
            
            successFn(gnomesInTown)
        }
        
    }
    
    public func setGnomePicture(imageURL:URL, imageView:UIImageView) {
        
        let placeholderImage = UIImage(named: "placeholder")
        
        imageView.af_setImage(withURL:imageURL,
                              placeholderImage: placeholderImage,
                              filter:nil,
                              imageTransition: .curlDown(0.3)
            
        )
    }
}
