//
//  EqualizerTabBarController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/31/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

class EqualizerTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc0 = storyboard.instantiateViewController(withIdentifier: "channel0") as! EqualizerViewController
        let vc1 = storyboard.instantiateViewController(withIdentifier: "channel0") as! EqualizerViewController
        let rightButton = UIBarButtonItem(customView: vc0.mainButton)
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "EQAULIZER"
        vc0.title = "Channel 0"
        vc1.title = "Channel 1"
        vc0.channel1 = false
        vc1.channel1 = true
        self.viewControllers = [vc0, vc1]
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
