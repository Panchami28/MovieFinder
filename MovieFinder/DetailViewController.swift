//
//  DetailViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var plotLabel: UILabel!
    
    
    var poster:String=""
    var plot:String=""
    var cast=[[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: poster)!

            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                // Create Image and Update Image View
                movieImage.image = UIImage(data: data)
            }
        
        plotLabel.numberOfLines=0
        plotLabel.text=plot
//        for i in 0..<cast.count {
//            castLabel.text = cast[i]["actor"] as! String
//        }
       

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
