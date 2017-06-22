//  Created by Aibek Rakhim on 6/22/17.
//  Copyright © 2017 ibek inc. All rights reserved.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getBooks(query:String) {
        //replace empty space to %20
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://www.googleapis.com/books/v1/volumes?q=\(query)"
        
        // request and compile dataTask with resume()
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                
                //try - если вышла ошибка, программа не будет идти дальше
                //allowFragments - позволяет игнорировать объекты кроме массива
                //getting JSON object
                let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    as! [String: AnyObject]
                
                if let items = json["items"] as? [[String: AnyObject]] {
                    print("got items", items)
                    
                    self.books = []
                    for item in items {
                        if let volumeInfo = item["volumeInfo"] as? [String: AnyObject] {
                            //instance of class Book
                            let book = Book()
                            book.title = volumeInfo["title"] as? String
                            
                            if let authors = volumeInfo["authors"] as? [String] {
                                var creators = " "
                                for author in authors {
                                    creators += author
                                }
                                book.author = creators
                            }
                            
                            
                            
                            if let imageLinks = volumeInfo["imageLinks"] as? [String: String] {
                                book.imageURL = imageLinks["thumbnail"]
                            }
                            self.books.append(book)
                        }
                    }
                    print(self.books)
                    
                    //to immediately display data in tableViewCell
                    DispatchQueue.main.async {
                        //for update tableView
                        self.tableView.reloadData()
                    }
                }
            }
        }.resume()
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! BookItemTableViewCell
        
        //customizing cell
        cell.titleLabel.text = books[indexPath.row].title!
        cell.authorLabel.text = books[indexPath.row].author
        
        if let imageHaveUrl = books[indexPath.row].imageURL {
            cell.coverImageView.contentMode = .scaleAspectFit
            cell.coverImageView.imageFromURL(urlString: imageHaveUrl)
        }

        return cell
    }
}

// to allow download Image from some Url
//We can add in info.plist Exception domains in Allow Arbitrary loads
extension UIImageView {
    
    public func imageFromURL(urlString: String) {
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if let image = UIImage(data: data!) {
                        //to immediately display image in tableViewCell
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }).resume()
        }
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text != nil && !(searchBar.text?.isEmpty)! {
            let text = searchBar.text
            getBooks(query: text!)
        }
        
    }
}

