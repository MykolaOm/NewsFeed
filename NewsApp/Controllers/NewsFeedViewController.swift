//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIScrollViewDelegate, UITabBarDelegate, UITableViewDataSource {
   
    var flag = 0
    var newsFeedSource = [NewsTableDataSource]()
    
    let cellReuseIdentifier = "PosterCell"
    let tableViewRowsQty : Int = 10
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowsQty
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let customCell = tableView.dequeueReusableCell(withIdentifier: "PosterCell", for: indexPath) as? NewsTableViewCell {
            if newsFeedSource.count > 9 {
                
            customCell.cellDescription.text = newsFeedSource[indexPath.row].overview
            customCell.cellRating.text = newsFeedSource[indexPath.row].title
            customCell.cellRelease.text = String(newsFeedSource[indexPath.row].voteAverage)
//             customCell.cellImage.image =
            setCellImage(url:newsFeedSource[indexPath.row].imageUrl, cell : customCell)
            cell = customCell
            }
        }
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func setCellImage(url: String , cell : NewsTableViewCell) {
        let url = URL(string: url)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data!)
            }
        }
    }

    @IBOutlet weak var topScrollPageControl: UIPageControl!
    @IBOutlet weak var topScrollView: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setJsonToDtScr()
        setUpScrollView()
        let cellNib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.backgroundColor = .black
    }

    private func setUpScrollView(){
        let scrollViewSlides = 4
        
        topScrollView.isPagingEnabled = true
        topScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(scrollViewSlides), height: self.view.bounds.height/3)
        
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.showsVerticalScrollIndicator = false
        topScrollView.delegate = self
        topScrollPageControl.numberOfPages = scrollViewSlides
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        topScrollPageControl.currentPage = Int(page)
        topScrollPageControl.defersCurrentPageDisplay = true
        
    }

    private func setJsonToDtScr() {
        let jsonUrlString = "http://api.themoviedb.org/3/movie/popular?api_key=4bc08ab955f501a524c27210af4c49f3"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieNews = try decoder.decode(VideoData.self, from: data)
//                print(moviewNews.results[0].posterPath)
                self.setToArray(movieNews:movieNews.results)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }

        }.resume()

    }
    private func setToArray(movieNews : [Movie]) {
        for item in 0...9 {
        newsFeedSource.append(NewsTableDataSource(overview: movieNews[item].overview , title: movieNews[item].title, posterPath: movieNews[item].posterPath, voteAverage: movieNews[item].voteAverage))
        }
    }
    private func loadTop(){
       if newsFeedSource.count > 0  {
        var count = 0
            for item in newsFeedSource {
        
            if let topView = Bundle.main.loadNibNamed("Top", owner: self, options: nil)?.first as? TopView {
                let url = URL(string: "https://i.ytimg.com/vi/M8wBhKwgrVw/maxresdefault.jpg")
                if item.voteAverage > 7.5 {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            topView.ImageView.image = UIImage(data: data!)
                        }
                    }
                    
                    topView.descriptionLabel.text = item.overview
                    topView.titleLabel.text = item.title
                    topView.voteAvarageLabel.text = String(item.voteAverage)
                    
                    topScrollView.addSubview(topView)
                    topView.frame.size.width = self.view.bounds.width
                    topView.frame.origin.x = CGFloat(count) * self.view.bounds.size.width
                }
            }
                count += 1
        }
            
        }
    }
}
