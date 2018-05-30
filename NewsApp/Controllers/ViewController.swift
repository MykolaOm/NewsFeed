//
//  ViewController.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setToolBar()
        containerView.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height - 60)
        print(containerView.frame)
    }
    
    private func setToolBar(){
        // Y position due to iphone X screen is moved down on 35 points
        let toolbar = NewsToolBar(frame: CGRect(x:0,y:30,width:self.view.frame.width,height:30))
        view.addSubview(toolbar)
        print("toolbar frame:",toolbar.frame)
    }

}

