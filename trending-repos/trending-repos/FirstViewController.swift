//
//  FirstViewController.swift
//  trending-repos
//
//  Created by nabila on 1/20/18.
//  Copyright © 2018 nabila. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var repositories = [Repository]()
    let URL_Repositories = "https://api.github.com/search/repositories?q=created:%3E2017-12-20&sort=stars&order=desc";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonFromUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repository = tableView.dequeueReusableCell(withIdentifier: "repository", for: indexPath) as! RepositoryTableViewCell
        repository.repoName.text = repositories[indexPath.row].name
        repository.nbStars.text = String(describing: (repositories[indexPath.row].stars)!)
        repository.repoDescription.text = repositories[indexPath.row].desc
        repository.ownerName.text = repositories[indexPath.row].ownerName
        
        let image_url = NSURL(string: (repositories[indexPath.row].ownerAvatarUrl)!)
        URLSession.shared.dataTask(with: (image_url as? URL)!, completionHandler: {(data, response, error) -> Void in
            if let imageData = data
            {
                let image = UIImage(data: imageData)
                repository.ownerAvatar.image = image
            }
        }).resume()
        return repository
    }
    
    //this function is fetching the json from URL
    
    func getJsonFromUrl(){
        let url = NSURL(string: URL_Repositories)
        
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
            {
                if let repositoryArray = jsonObj!.value(forKey: "items") as? NSArray
                {
                    for repo in repositoryArray{
                        if let repositoryDict = repo as? NSDictionary
                        {
                            if let name = repositoryDict.value(forKey: "name"),
                                let nb = repositoryDict.value(forKey: "stargazers_count"),
                                let repoDesc = repositoryDict.value(forKey: "description"),
                                let owner = repositoryDict.value(forKey: "owner") as? NSDictionary
                            {
                                if let ownerName = owner.value(forKey: "login"),
                                    let ownerAvatar = owner.value(forKey: "avatar_url")
                                {
                                    self.repositories.append(Repository(name: name as? String, desc: repoDesc as? String, ownerAvatarUrl: ownerAvatar as? String, ownerName: ownerName as? String, stars: nb as? Int))
                                }
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async(execute: {self.tableView.reloadData()})
        }).resume()
    }

}

