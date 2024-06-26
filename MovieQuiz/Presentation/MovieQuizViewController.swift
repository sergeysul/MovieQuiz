import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol{
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
 
    
    private var alertDelegate: MovieQuizViewControllerDelegate?
    private var presenter: MovieQuizPresenter!
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        hideLoadingIndicator()
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
        let message = presenter.makeResultsMessage()
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            
            self.presenter.restartGame()
            self.showLoadingIndicator()
        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            //guard let self = self else {return}
            //self.showNextQuestionOrResults()
        //}
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }


    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
        presenter.viewController = self
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
        
        let alert = UIAlertController (
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Попробовать еще раз", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.presenter.restartGame()
        }
        alert.addAction(action)
        
    }
}

