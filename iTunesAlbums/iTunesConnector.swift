//
//  iTunesConnector.swift
//  iTunesAlbums
//
//  Created by Nicholas Reeder on 2/12/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//
protocol ConnectorDelegate: AnyObject {
    func didGetDataInWrongFormat(message: String)
}
import UIKit

class iTunesConnector: NSObject {
    static let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    var session = URLSession(configuration: .default)
    weak var delegate: ConnectorDelegate?
    
    func getTopAlbums(_ completion: @escaping(_ albums: [[String: Any]]?, _ error: Error?) -> Void) {
        guard let url = URL(string: iTunesConnector.urlString) else {
            completion(nil, nil)
            return
        }
        let request = URLRequest(url: url)
        self.session = URLSession.shared
       
        let task = self.session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let responseData = data else {
                self.delegate?.didGetDataInWrongFormat(message: "no data")
                return
            }
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    self.delegate?.didGetDataInWrongFormat(message: "jsonData is in wrong format")
                    return
                }
              
                guard let feed = jsonData["feed"] as? [String: Any] else {
                    self.delegate?.didGetDataInWrongFormat(message: "feed doesn't exist")
                    return
                }
                guard let results = feed["results"] as? [[String: Any]] else {
                    self.delegate?.didGetDataInWrongFormat(message: "results in wrong format")
                    return
                }
              completion(results, nil)
            }
            catch {
                completion(nil, error)
            }
        }
        task.resume()
    }

}
