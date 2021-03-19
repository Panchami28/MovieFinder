//
//  DetailViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!

    var basicMovie: BasicMovie?

    var movieDetail: MovieDetail?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")

    // MARK: -
    // MARK: View Life Cycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show Activity Indicator and enable animating
        activityIndicatorView.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// Call fetch movie detail
            loadMovieDetails()
    }

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    /**
        This method will load movie details in a new screen
     */
    func loadMovieDetails() {
        //In the completion of network call fill UI details
        guard let basicMovie = basicMovie else { return }
        MovieDataApiManager.shared.getMovieData(forMovie: basicMovie, completionHandler: {[weak self] (detailedMovie, error) in
            if error != nil {
                //show error
            }
            else {
                if let safeMovieDetail = detailedMovie {
                    self?.movieDetail = safeMovieDetail
                    self?.updateUI()
                } else {
                    
                }
            }
        })


    }
    
    private func updateUI() {
        activityIndicatorView.isHidden = true
        contentView.isHidden=false
        guard let nonOptionalMovieDetail = movieDetail else { return }
        self.movieImage.sd_setImage(with: URL(string: nonOptionalMovieDetail.poster), placeholderImage: UIImage(named: "placeholder"))
        self.plotLabel.numberOfLines = 0 // Do this in Interface Builder
        self.plotLabel.text = nonOptionalMovieDetail.plot
        self.reviewLabel.text = "Rating: \(nonOptionalMovieDetail.rating)"
        self.yearLabel.text = "Year of release: \(nonOptionalMovieDetail.year)"
        self.castLabel.numberOfLines = 0
        self.castLabel.text = nonOptionalMovieDetail.castString
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        var favourites = [BasicMovie]()
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                favourites = try decoder.decode([BasicMovie].self, from: data)
                
            } catch {
                print("Error decoding data \(error)")
            }
    }
        if let _ = basicMovie {
            favourites.append(basicMovie!)
        }
        
        let encoder = PropertyListEncoder()
        var alert:UIAlertController
        do {
            let data = try encoder.encode(favourites)
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
