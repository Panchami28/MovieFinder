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
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    
    var name:String=""
    var movieId:String=""
    var poster:String=""
    var plot:String=""
    var review:String=""
    var year:String=""
    var cast=[[String:Any]]()
    
    var movieArray=[MovieDetail]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        if let url = URL(string: poster) {
            if let data = try? Data(contentsOf: url) {
                // Create Image and Update Image View
                movieImage.image = UIImage(data: data)
            }
        }
        plotLabel.numberOfLines=0
        plotLabel.text=plot
        reviewLabel.text="Rating: \(review)"
        yearLabel.text="Year of release: \(year)"
        
        castLabel.numberOfLines = 0
        for i in 0..<cast.count {
            //print(cast[i]["actor"])
            castLabel.text!+="\(cast[i]["actor"] as! String), "
        }
    
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        var movie=MovieDetail()

        movie.name = name
        movie.year = Int(year)!
        movie.rating = Float(review)!
        movie.id = movieId
        movie.poster = poster

        
        if let data=try? Data(contentsOf: dataFilePath!) {
            let decoder=PropertyListDecoder()
            do {
            movieArray=try decoder.decode([MovieDetail].self, from: data)
            }catch {
                print("Error decoding data \(error)")
            }
        }
        
        movieArray.append(movie)
        
        let encoder = PropertyListEncoder()
        var alert:UIAlertController
        do {
            let data = try encoder.encode(movieArray)
            try data.write(to: dataFilePath!)
            // Show a successful addition alert
            alert = UIAlertController(title: "Successful", message: "Movie added successfully", preferredStyle: .alert)
        } catch {
            //show alert
            print("Error encoding data:\(error)")
            alert = UIAlertController(title: "Error", message: "Something Went Wrong. Please try again later", preferredStyle: .alert)
        }
        //present here
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(alertAction)
    }

}
