//
//  IntroViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 20/03/21.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let homeScreenController = storyboard.instantiateViewController(identifier: "HomeScreenViewController") as? HomeScreenViewController {
            navigationController?.pushViewController(homeScreenController, animated: true)
        }
    }

}
