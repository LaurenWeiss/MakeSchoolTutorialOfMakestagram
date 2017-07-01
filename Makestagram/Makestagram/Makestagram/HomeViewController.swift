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
        
        configureTableView()
        
        //used to fetch the posts from Firebase
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
        
    }
    
    func configureTableView() {
        //remove separators for empty cells
        tableView.tableFooterView = UIView()
        //remove separators from cells
        tableView.separatorStyle = .none
    }
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    //   @IBOutlet weak var tableView: UITableView!
    
    //retrieves data from Post array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //now our table view will display the sme number of cells as in our posts array
       //return posts.count
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            //necessary?
            //cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
            cell.likeCountLabel.text = "\(post.likeCount) likes"
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
        
    }
}
// MARK : - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    //this method returns the height that each cell should be given an index path
    //allows us to have cells that are varying heights within the same table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
        default:
            fatalError()
        }
 
        func configureCell(_ cell: PostActionCell, with post: Post) {
            cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
            cell.likeButton.isSelected = post.isLiked
            cell.likeCountLabel.text = "\(post.likeCount) likes"
        }
        
        
    }
    
    
}

extension HomeViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        // 1
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        // 2
        likeButton.isUserInteractionEnabled = false
        // 3
        let post = posts[indexPath.section]
        
        // 4
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            // 5
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // 6
            guard success else { return }
            
            // 7
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            // 8
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            // 9
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
}
}
