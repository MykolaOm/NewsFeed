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
    private var flag = 0
    private var newsFeedSource = [NewsTableDataSource]()
    private let cellReuseIdentifier = "PosterCell"
    private let tableViewRowsQty : Int = 10
    private var imageCache = ImageCache()
    @IBOutlet weak var tableView: UITableView!
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowsQty
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = .black
        if let customCell = tableView.dequeueReusableCell(withIdentifier: "PosterCell", for: indexPath) as? NewsTableViewCell {
            if newsFeedSource.count > 0 {
            customCell.cellRating.text = newsFeedSource[indexPath.row].title
            customCell.cellRelease.text = String(newsFeedSource[indexPath.row].voteAverage)
            let url = URL(string: newsFeedSource[indexPath.row].imageUrl)
                
                if let image = self.imageCache.tryGetImage(url: url!) {
                    customCell.cellImage.image = image
                } else {
                    DispatchQueue.global().async { [url, customCell, unowned imageCashe = self.imageCache] in
                        if let image = imageCashe.getImage(url: url!) {
                            DispatchQueue.main.async { [image, customCell] in
                                customCell.cellImage.image = image
                            }
                        }
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
    override func viewWillLayoutSubviews() {
        if topScrollView.subviews.count > 0{
            print(topScrollView.subviews[3],topScrollView.subviews[4])
            print("topScrollView.subviews[3]",topScrollView.subviews.count)
        }
        print("2")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cellNib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
        setUpScrollView()
        print("1")
//        self.view.setNeedsLayout()
//        self.view.setNeedsDisplay()
//        tableView.layoutIfNeeded()
//        tableView.setNeedsDisplay()
//        topScrollView.setNeedsLayout()
//        topScrollView.setNeedsDisplay()
        let view = UIView()
        view.backgroundColor = .black
        self.tableView.tableFooterView = view
    }
    override func viewDidLayoutSubviews() {
        if flag == 0 {
            flag = 1
            
            print("didlayout if")
        }
   
    }
    
    
    private func setUpScrollView(){
//        let scrollViewSlides = newsFeedSource.filter{$0.voteAverage > 7.0}.count
        loadTop()
//        print("scrollViewSlides:",scrollViewSlides)
        
        topScrollView.isPagingEnabled = true
        topScrollView.contentSize = CGSize(width: (containerForSrollView.bounds.width) * CGFloat(topScrollView.subviews.count), height: containerForSrollView.bounds.height)
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.showsVerticalScrollIndicator = false
        topScrollView.delegate = self
        topScrollPageControl.numberOfPages = topScrollView.subviews.count
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
   
    private func loadTop(){
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
    }
}
