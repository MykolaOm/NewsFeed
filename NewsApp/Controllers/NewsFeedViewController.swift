//
//  NewsFeedViewController.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var topScrollPageControl: UIPageControl!
    @IBOutlet weak var topScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

     setUpScrollView()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
