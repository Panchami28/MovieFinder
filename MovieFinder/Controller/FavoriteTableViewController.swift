//
//  FavoriteTableViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 08/03/21.
//

import UIKit

class FavoriteTableViewController: UITableViewController {

    @IBOutlet var favoriteTableView: UITableView!
    
    
    
    let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")
    
    let networkcall=NetworkCalls()
    
    var movieArray=[MovieDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
        
        favoriteTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        if let data=try? Data(contentsOf: dataFilePath!) {
            let decoder=PropertyListDecoder()
            do {
            movieArray=try decoder.decode([MovieDetail].self, from: data)
            }catch {
                print("Error decoding data \(error)")
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell

       
            cell.movieLabel?.text=movieArray[indexPath.row].name
            
            let url=URL(string:movieArray[indexPath.row].poster)
            
            if let data = try? Data(contentsOf: url!) {
                // Create Image and Update Image View
                cell.posterImage!.image = UIImage(data: data)
            }
            cell.movieLabel?.numberOfLines=0

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        networkcall.globalURL+=movieArray[indexPath.row].id
        
        networkcall.getMovieData(networkcall.globalURL){
            (success) in
            if success==true {
                DispatchQueue.main.async {
                self.performSegue(withIdentifier: "moveToDetailedPage", sender: self)
            }
            }
        }
    }
    
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="moveToDetailedPage" {
            let destinationVC=segue.destination as! DetailViewController
            
            destinationVC.name=networkcall.titleOfMovie
            destinationVC.movieId=networkcall.id
            destinationVC.poster=networkcall.movieImage
            destinationVC.plot=networkcall.plotDescription
            destinationVC.cast=networkcall.jsonArray
            destinationVC.review=networkcall.rating
            destinationVC.year=networkcall.year
            
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
