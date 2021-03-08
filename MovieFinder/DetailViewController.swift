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
    
    let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        
        let url = URL(string: poster)!

            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                // Create Image and Update Image View
                movieImage.image = UIImage(data: data)
            }
        
        plotLabel.numberOfLines=0
        plotLabel.text=plot
        reviewLabel.text="Rating: \(review)"
        yearLabel.text="Year of release: \(year)"
        
        castLabel.numberOfLines=0
        
        for i in 0..<cast.count {
            //print(cast[i]["actor"])
            castLabel.text!+="\(cast[i]["actor"] as! String), "
        }
        
        
        
    
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        let movie=MovieDetail()

        movie.name=name
        movie.year=Int(year)!
        movie.rating=Float(review)!
        movie.id=movieId
        movie.poster=poster

       
        
        //print(movieArray[0].name)
        
        if let data=try? Data(contentsOf: dataFilePath!) {
            let decoder=PropertyListDecoder()
            do {
            movieArray=try decoder.decode([MovieDetail].self, from: data)
            }catch {
                print("Error decoding data \(error)")
            }
        }
        
        movieArray.append(movie)
        
        let encoder=PropertyListEncoder()
        
        do {
            let data=try encoder.encode(movieArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error encoding data:\(error)")
        }
    }
    
    
    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cast.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell=castTableView.dequeueReusableCell(withIdentifier: "castCell", for: indexPath)
//        cell.textLabel?.text=cast[indexPath.row]["actor"] as! String
//        return cell
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
