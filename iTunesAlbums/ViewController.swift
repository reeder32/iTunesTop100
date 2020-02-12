//
//  ViewController.swift
//  iTunesAlbums
//
//  Created by Nicholas Reeder on 2/12/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//
struct Album {
    var imageURL: String
    var artist: String
    var name: String
    var genre: [[String:Any]]
    var releaseDate: String
    var copyrightInfo: String
    var urlString: String
    
    func getImageFromURL() -> UIImage? {
        if let url = URL(string: imageURL) {
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                return UIImage(data: imageData)
            }
        }
        
        return UIImage(named: "no-thumbnail")
    }
}
import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    var albums = [Album]()
    var imageURL = ""
    var artist = ""
    var name = ""
    var genre = [[String: Any]]()
    var releaseDate = ""
    var copyrightInfo = ""
    var urlString = ""
    let connector = iTunesConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getAlbums), name: NSNotification.Name.init("GetAlbums"), object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        connector.delegate = self
        title = "Top 100 Albums"
        setupTableView()
        addConstraints()
        getAlbums()
        
    }
    
    @objc func getAlbums() {
            connector.getTopAlbums { (albums, error) in
                if let albums = albums, error == nil  {
                    for album in albums {
                        let a = self.createAlbum(album)
                        self.albums.append(a)
                    }
                    DispatchQueue.main.async {
                        print(self.albums.count)
                        self.tableView.reloadData()
                    }
                } else {
                    self.showAlertWithMessage(message: error?.localizedDescription ?? "Unable to get albums", fromVC: self)
                }
            }
    }

    func createAlbum(_ album: [String: Any]) -> Album {
        
        if let imageURL = album["artworkUrl100"] as? String {
            self.imageURL = imageURL
        }
        if let artist = album["artistName"] as? String {
            self.artist = artist
        }
        if let releaseDate = album["releaseDate"] as? String {
            self.releaseDate = releaseDate
        }
        if let copyrightInfo = album["copyright"] as? String {
            self.copyrightInfo = copyrightInfo
        }
        if let name = album["name"] as? String {
            self.name = name
        }
        if let genres = album["genres"] as? [[String: Any]] {
            self.genre = genres
        }
        if let urlString = album["url"] as? String {
            self.urlString = urlString
        }
       
        return Album(imageURL: imageURL, artist: artist, name: name, genre: genre, releaseDate: releaseDate, copyrightInfo: copyrightInfo, urlString: urlString)
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func addConstraints() {
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    

    func goToDetailViewWithAlbum(_ album: Album) {
        let dvc = DetailViewController()
        dvc.album = album
        navigationController?.pushViewController(dvc, animated: true)
    }
}

extension ViewController: ConnectorDelegate {
    func didGetDataInWrongFormat(message: String) {
        showAlertWithMessage(message: message, fromVC: self)
    }
    
    
}

extension UIViewController {
    func showAlertWithMessage(message: String?, fromVC: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            NotificationCenter.default.post(name: NSNotification.Name.init("GetAlbums"), object: nil, userInfo: [:])
        }
        if fromVC is ViewController {
            alert.addAction(retry)
        }
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetailViewWithAlbum(self.albums[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let album = albums[indexPath.row]
        cell.imageView?.image = album.getImageFromURL()
        cell.textLabel?.text = album.name
        cell.detailTextLabel?.text = album.artist
        return cell
    }
    
    
}
