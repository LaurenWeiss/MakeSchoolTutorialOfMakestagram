//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Lauren Weiss on 6/29/17.
//  Copyright © 2017 Lauren Weiss. All rights reserved.
//

import Foundation
import UIKit

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}

class PostActionCell: UITableViewCell{
    
    static let height: CGFloat = 46
    
    // MARK: - Properties
    weak var delegate: PostActionCellDelegate?
    
    // MARK: - Subviews
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }
    // MARK: - IBActions
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
}
