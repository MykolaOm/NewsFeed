//
//  TabBarViewController.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 30.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.origin.y //CGFloat(-35.0)
        self.tabBar.frame = tabFrame
//        self.tabBar.backgroundColor = .black
        self.tabBar.barTintColor = UIColor.black
        print("container",self.view.superview?.frame)
//        print("tabbar frame",self.view.frame.width,self.view.frame.width)
//        print("tabfRame",tabFrame.width, tabFrame.height)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
