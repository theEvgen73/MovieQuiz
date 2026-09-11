import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    private weak var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        presenter = MovieQuizPresenter(viewController: self)
    }


    // MARK: - IBAction
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - UI Methods (вызываются Presenter'ом)
     func show(quiz step: QuizStepViewModel) {
         imageView.layer.borderColor = UIColor.clear.cgColor
         imageView.image = UIImage(data: step.image) ?? UIImage()
         textLabel.text = step.question
         counterLabel.text = step.questionNumber
         
         imageView.layer.borderWidth = 0
         noButton.isEnabled = true
         yesButton.isEnabled = true
     }
     
     func show(quiz result: QuizResultsViewModel) {         
         let alert = UIAlertController(
             title: result.title,
             message: result.text,
             preferredStyle: .alert
         )
         
         let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
             self?.presenter.restartGame()
         }
         
         alert.addAction(action)
         present(alert, animated: true)
     }
     
     func highlightImageBorder(isCorrectAnswer: Bool) {
         imageView.layer.borderWidth = 8
         imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
         noButton.isEnabled = false
         yesButton.isEnabled = false
     }
     
     func showLoadingIndicator() {
         activityIndicator.isHidden = false
         activityIndicator.startAnimating()
     }
     
     func hideLoadingIndicator() {
         activityIndicator.isHidden = true
         activityIndicator.stopAnimating()
     }
     
     func showNetworkError(message: String) {
         hideLoadingIndicator()
         
         let alert = UIAlertController(
             title: "Ошибка",
             message: message,
             preferredStyle: .alert
         )
         
         let action = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
             self?.presenter.restartGame()
         }
         
         alert.addAction(action)
         present(alert, animated: true)
     }
 }
