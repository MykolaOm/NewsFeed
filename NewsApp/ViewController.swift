//
//  ViewController.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       setToolBar()
    }
    
    private func setToolBar(){
        // Y position due to iphone X screen is moved down on 35 points
        let toolbar = NewsToolBar(frame: CGRect(x:0,y:35,width:self.view.frame.width,height:50))
        view.addSubview(toolbar)
    }

}

