//
//  BookItemTableViewCell.swift
//  GoogleBooksApi
//
//  Created by Aibek Rakhim on 6/22/17.
//  Copyright © 2017 ibek inc. All rights reserved.
//

import UIKit

class BookItemTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
