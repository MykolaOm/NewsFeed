//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var containerForSrollView: UIView!
    
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
        cell.backgroundColor = .black
        if let customCell = tableView.dequeueReusableCell(withIdentifier: "PosterCell", for: indexPath) as? NewsTableViewCell {
            if newsFeedSource.count > 0 {
            
            customCell.cellDescription.text = newsFeedSource[indexPath.row].overview
            customCell.cellRating.text = newsFeedSource[indexPath.row].title
            customCell.cellRelease.text = String(newsFeedSource[indexPath.row].voteAverage)
            let url = URL(string: newsFeedSource[indexPath.row].imageUrl)
                
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    customCell.cellImage.image = UIImage(data: data!)
                }
            }
            cell = customCell
            }
        }
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBOutlet weak var topScrollPageControl: UIPageControl!
    @IBOutlet weak var topScrollView: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setJsonToDtScr()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cellNib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        
        setUpScrollView()
        let view = UIView()
        view.backgroundColor = .black
        self.tableView.tableFooterView = view
    }
    
    
    private func setUpScrollView(){
        
        let scrollViewSlides = newsFeedSource.filter{$0.voteAverage > 7.0}.count
        loadTop()
        print("scrollViewSlides:",scrollViewSlides)
        
        topScrollView.isPagingEnabled = true
        topScrollView.contentSize = CGSize(width: (containerForSrollView.bounds.width) * CGFloat(scrollViewSlides), height: containerForSrollView.bounds.height)
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
    func loadTopA(){
        for (index,_) in newsFeedSource.enumerated() {
            if let topView = Bundle.main.loadNibNamed("Top", owner: self, options: nil)?.first as? TopView {
                if index == 2 {
                    let url = URL(string: newsFeedSource[index].imageUrl)
                    
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            topView.ImageView.image = UIImage(data: data!)
                        }
                    }
                }
                topView.titleLabel.text = newsFeedSource[index].title
                topView.voteAvarageLabel.text = String(newsFeedSource[index].voteAverage)
                
                topScrollView.addSubview(topView)
                topView.frame.size.width = self.view.bounds.width
                topView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
        }
        
        
    }
    
    
    private func loadTop(){
//       if newsFeedSource.count > 0  {
        var count = 0
            for item in newsFeedSource {
        
            if let topView = Bundle.main.loadNibNamed("Top", owner: self, options: nil)?.first as? TopView {
                let url = URL(string: newsFeedSource[count].imageUrl)
                print("THIS IS IMAGE",newsFeedSource[count].imageUrl )
                if item.voteAverage > 7.0 {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            topView.ImageView.image = UIImage(data: data!)
                        }
                    }
                    
                    topView.titleLabel.text = item.title
                    topView.voteAvarageLabel.text = String(item.voteAverage)
                    
                    topScrollView.addSubview(topView)
                    topView.frame.size.width = containerForSrollView.bounds.width
                    topView.frame.origin.x = CGFloat(count) * containerForSrollView.bounds.size.width
                }
            }
                count += 1
        }
            
//        }
    }
}
