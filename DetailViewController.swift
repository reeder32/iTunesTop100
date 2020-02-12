//
//  DetailViewController.swift
//  iTunesAlbums
//
//  Created by Nicholas Reeder on 2/12/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var album: Album?
    var imgView = UIImageView()
    var button = UIButton()
    var descriptionLabel = UILabel()
    let keyAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray2, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold) ] as [NSAttributedString.Key : Any]
    let valueAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)] as [NSAttributedString.Key : Any]
    let returnString = NSAttributedString(string: "\n")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addAlbumDescription()
        addButton()
        addConstraints()
        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    func setUpView() {
        self.imgView.layer.masksToBounds = true
        //imgView.clipsToBounds = true
        self.imgView.layer.cornerRadius = 100
        self.imgView.image = self.album?.getImageFromURL()
        self.view.addSubview(self.imgView)
    }
    
    // MARK: LABEL
    func addAlbumDescription() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.attributedText = createPrettyDescriptionLabel()
        self.view.addSubview(descriptionLabel)
    }
 
    func createPrettyDescriptionLabel() -> NSAttributedString {
        let mutString = NSMutableAttributedString(string: "Artist: ", attributes: keyAttributes)
        mutString.append(NSAttributedString(string: album?.artist ?? "", attributes: valueAttributes))
        mutString.append(returnString)
        mutString.append(NSAttributedString(string: "Album Name: ", attributes: keyAttributes))
        mutString.append(NSAttributedString(string: album?.name ?? "", attributes: valueAttributes))
        mutString.append(returnString)
        mutString.append(NSAttributedString(string: "Release Date: ", attributes: keyAttributes))
        mutString.append(NSAttributedString(string: album?.releaseDate ?? "", attributes: valueAttributes))
        mutString.append(returnString)
        mutString.append(NSAttributedString(string: "Genre(s): ", attributes: keyAttributes))
        for g in album?.genre ?? [] {
            if let name = g["name"] as? String {
                mutString.append(NSAttributedString(string: name, attributes: valueAttributes))
            }
            
        }
         mutString.append(returnString)
        mutString.append(NSAttributedString(string: "Copyright info: ", attributes: keyAttributes))
        mutString.append(NSAttributedString(string: album?.copyrightInfo ?? "", attributes: valueAttributes))
        let attString = NSAttributedString(attributedString: mutString)
        return attString
    }
    
    
    // MARK: BUTTON
    func addButton() {
        button.center.x = view.center.x
        button.setTitle("View on iTunes", for: .normal)
        button.clipsToBounds = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(goToStore), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
   @objc func goToStore() {
      
        guard let urlString = album?.urlString else {
            return
        }
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            } else {
               showAlertWithMessage(message: "Unable to open URL", fromVC: self)
            }
        }
        
    }
    
    func addConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        imgView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        imgView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
       
        button.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 40).isActive = true
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
