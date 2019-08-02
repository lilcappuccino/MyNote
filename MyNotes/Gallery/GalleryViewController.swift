//
//  GalleryViewController.swift
//  MyNotes
//
//  Created by dewill on 01/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.tabBarItem.image = UIImage(named: "album_icon")
//        tabBarController?.tabBarItem.image  = UIImage(named: "album_icon")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
