//
//  DetailViewController.swift
//  MovieFinder
//
//  Created by Panchami Rao on 03/03/21.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!

    var basicMovie: BasicMovie?

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
        MovieDataApiManager.shared.getMovieData(forMovie: basicMovie, completionHandler: {[weak self] (movieInfo, error) in
            if error != nil {
                //show error
            }
            else {
                if let movieDetail = movieInfo {
                    self?.updateUI(withMovieDetail: movieDetail)
                } else {
                    //Show something went wrong while loading movie details
                }
            }
        })


    }
    
    private func updateUI(withMovieDetail movieDetail: MovieDetail) {
        activityIndicatorView.isHidden = true
        contentView.isHidden=false
        self.movieImage.sd_setImage(with: URL(string: movieDetail.poster), placeholderImage: UIImage(named: "placeholder"))
        self.plotLabel.numberOfLines = 0 // Do this in Interface Builder
        self.plotLabel.text = movieDetail.plot
        self.reviewLabel.text = "Rating\n\(movieDetail.rating)"
        self.yearLabel.text = "Year of Release\n\(movieDetail.year)"
        self.castLabel.numberOfLines = 0
        self.castLabel.text = movieDetail.castString
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        guard let movie = basicMovie else { return }
        FavouritesMovieModel.insertMovie(movie) { [weak self] (isSuccess) in
            if isSuccess {
                self?.showFavouritesAdditionSuccessMessage()
            } else {
                self?.showFavouritesAdditionfailureMessage()
            }
        }
    }

    private func showFavouritesAdditionSuccessMessage() {
        let alert = UIAlertController(title: "Successful", message: "Movie added successfully", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)

    }

    private func showFavouritesAdditionfailureMessage() {
        let alert = UIAlertController(title: "Error", message: "Something Went Wrong. Please try again later", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }

}
