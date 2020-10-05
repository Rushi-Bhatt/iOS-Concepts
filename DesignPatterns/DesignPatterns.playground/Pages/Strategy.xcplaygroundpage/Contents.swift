import Foundation
import UIKit

public protocol MovieRatingStrategy {
  var ratingService: String { get }
  
  func fetchRating(for movieTitle: String, success: (_ rating: String, _ review: String) -> ())
}

public class RottenTomatoesClient: MovieRatingStrategy {
  public var ratingService: String = "Rotten Tomatoes"
  
  public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
    let rating = "95%"
    let review = "Good Movie!!"
    success(rating, review)
  }
}

public class IMDBClient: MovieRatingStrategy {
  public var ratingService: String = "IMDB"
  
  public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
    let rating = "3/10"
    let review = "Bad Movie!!"
    success(rating, review)
  }
}

public class MovieRatingViewController: UIViewController {
  
  //MARK:- Properties
  public var movieRatingClient: MovieRatingStrategy!
  // Notice how the view controller doesnt know the concrete implementation details of the rating strategy.
  // Whenever this VC is instantiated, movieRatingClient needs to be set to one of the concrete strategy
  // so determination of which strategy to be used can be deferred to at the run time
  
  init(movieRatingClient: MovieRatingStrategy) {
    self.movieRatingClient = movieRatingClient
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK:- Outlets
  @IBOutlet public var movieTitleTextField: UITextField!
  @IBOutlet public var ratingServiceNameLabel: UILabel!
  @IBOutlet public var ratingLabel: UILabel!
  @IBOutlet public var reviewLabel: UILabel!
  
  //MARK:- View LifeCycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    ratingServiceNameLabel.text = movieRatingClient.ratingService
  }
  
  //MARK:- Actions
  @IBAction public func searchButtonPressed(_ sender: Any) {
    guard let movieTitle = movieTitleTextField.text, movieTitle.count > 0 else { return }
    movieRatingClient.fetchRating(for: movieTitle) { (rating, review) in
      self.ratingLabel.text = rating
      self.reviewLabel.text = review
    }
  }
  
}

let imdbClient = IMDBClient()
let vc = MovieRatingViewController(movieRatingClient: imdbClient)
