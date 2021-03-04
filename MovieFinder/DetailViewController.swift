//
//  DetailViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var castTableView: UITableView!
    
    
    var poster:String=""
    var plot:String=""
    var cast=[[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castTableView.delegate=self
        castTableView.dataSource=self
        
        let url = URL(string: poster)!

            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                // Create Image and Update Image View
                movieImage.image = UIImage(data: data)
            }
        
        plotLabel.numberOfLines=0
        plotLabel.text=plot

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=castTableView.dequeueReusableCell(withIdentifier: "castCell", for: indexPath)
        cell.textLabel?.text=cast[indexPath.row]["actor"] as! String
        return cell
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
