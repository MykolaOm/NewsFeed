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
    private var width:CGFloat = 0.0
    private var newsFeedSource = [NewsTableDataSource]()
    private let cellReuseIdentifier = "PosterCell"
    private let tableViewRowsQty : Int = 10
    private var imageCache = ImageCache()
    private var lock = false
//    private var imgCache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var tableView: UITableView!
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowsQty
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = .black
        if let customCell = tableView.dequeueReusableCell(withIdentifier: "PosterCell", for: indexPath) as? NewsTableViewCell {
            customCell.cellSpinner.startAnimating()
            if newsFeedSource.count > 0 {
                customCell.cellRating.text = newsFeedSource[indexPath.row].title
                customCell.cellRelease.text = String(newsFeedSource[indexPath.row].voteAverage)
                let url = URL(string: newsFeedSource[indexPath.row].imageUrl)
//                imgCache.setObject(<#T##obj: UIImage##UIImage#>, forKey: <#T##NSString#>)
                if let image = self.imageCache.tryGetImage(url: url!) {
                    customCell.cellImage.image = image
                    customCell.cellSpinner.stopAnimating()
                    customCell.cellSpinner.isHidden = true

                } else {
                    DispatchQueue.global().async { [url, customCell, unowned imageCashe = self.imageCache] in
                        if let image = imageCashe.getImage(url: url!) {
                            DispatchQueue.main.async { [image, customCell] in
                                customCell.cellImage.image = image
                                customCell.cellSpinner.stopAnimating()
                                customCell.cellSpinner.isHidden = true

                            }
                        }
                    }
                }
                tableView.reloadInputViews()
            cell = customCell
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.setNeedsDisplay()
//        tableView.setNeedsLayout()
//        cell.setNeedsLayout()
//        cell.setNeedsDisplay()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBOutlet weak var topScrollPageControl: UIPageControl!
    @IBOutlet weak var topScrollView: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setJsonToDtScr()
        setUpScrollView()

        let view = UIView()
        view.backgroundColor = .black
        self.tableView.tableFooterView = view
    }
    override func viewWillLayoutSubviews() {
        loadTop()
        tableView.reloadData()
        print("2")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cellNib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
//        setUpScrollView()
        setUpScrollView()

        print("1")
        tableView.setNeedsLayout()


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
        tableView.reloadData()
//        topScrollView.reloadInputViews()
    }
    
    private func setToArray(movieNews : [Movie]) {
        for item in 0...9 {
        newsFeedSource.append(NewsTableDataSource(overview: movieNews[item].overview , title: movieNews[item].title, posterPath: movieNews[item].posterPath, voteAverage: movieNews[item].voteAverage))
        }
    }
   
    private func loadTop(){
        var count = 0
        if !lock {
            for item in newsFeedSource {
                if let topView = Bundle.main.loadNibNamed("Top", owner: self, options: nil)?.first as? TopView {
                    let url = URL(string: newsFeedSource[count].imageUrl)
                    if item.voteAverage > 7.0 {
                        if let image = self.imageCache.tryGetImage(url: url!) {
                            topView.ImageView.image = image
                        } else {
                            DispatchQueue.global().async {
                                let data = try? Data(contentsOf: url!)
                                DispatchQueue.main.async {
                                    topView.ImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                        topView.titleLabel.text = item.title
                        topView.voteAvarageLabel.text = String(item.voteAverage)
                        topScrollView.addSubview(topView)
                        lock = true
                        topView.frame.size.width = containerForSrollView.bounds.width
                        topView.frame.origin.x = CGFloat(count) * containerForSrollView.bounds.size.width
                        count += 1
                    }
                    
                }
                
            }
         
        }
    }
}
