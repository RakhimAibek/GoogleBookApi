//
//  BookDescriptionViewController.swift
//  GoogleBooksApi
//
//  Created by Aibek Rakhim on 6/22/17.
//  Copyright © 2017 ibek inc. All rights reserved.
//

import UIKit

class BookDescriptionViewController: UIViewController {

    var book: Book?
    
    @IBOutlet weak var bigThumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to unwrapp
        guard let book = book else { return }
        
        titleLabel.text = book.title
        descriptionLabel.text = book.descriptionInfo
        publishedDateLabel.text = book.publishDate
        bigThumbnail.contentMode = .scaleAspectFit
        bigThumbnail.imageFromURL(urlString: book.bigThumbnail!)
        
    }
    
    @IBAction func goBackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
