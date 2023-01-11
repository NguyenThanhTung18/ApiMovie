//
//  ViewController.swift
//  APIMovie
//
//  Created by Tùng Thiện on 07/01/2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var MovieSearch: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    var arrPost:[Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAPI()
        config()
    }
    
    func config() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func getAPI() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=4aa49f6e724de742f564b8b9cc4ef039&language=en-US&page=1") else {
            print("URL không tồn tại")
            return
        }
        Alamofire.request(url).responseJSON {response in
            print(response.data)
            guard let value = response.result.value else {
                print("No data")
                return
            }
            let json = JSON(value)
            //print(json)
            let result = json["results"]
            self.arrPost = result.arrayValue.map({item in
                Results(item)
            })
            print(self.arrPost)
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
        
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.contentImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + arrPost[indexPath.row].posterPath))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


