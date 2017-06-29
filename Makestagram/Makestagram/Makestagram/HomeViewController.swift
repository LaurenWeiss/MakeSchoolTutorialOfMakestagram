//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/27/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    
    //empty array of posts
    var posts = [Post]()
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //used to fetch the posts from Firebase
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
        
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    //   @IBOutlet weak var tableView: UITableView!
    
    //retrieves data from Post array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //now our table view will display the sme number of cells as in our posts array
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
        let imageURL = URL(string: post.imageURL)
        cell.postImageView.kf.setImage(with: imageURL)
        
        return cell
        
        //    self.tableView.register(PostImageCell:AnyClass?, forCellReuseIdentifier: "PostImageCell")
        //self.tableView.regist(UITableViewCell.self, forCellReuseIdentifier: "PostImageCell")
        
        //  let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
    }
}

// MARK : - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    //this method returns the height that each cell should be given an index path
    //allows us to have cells that are varying heights within the same table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let post = posts[indexPath.row]
        
        return post.imageHeight
    }
}
