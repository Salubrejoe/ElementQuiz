//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Lore P on 27/05/2022.
//

import UIKit

//MARK: Modes ENUM
enum Mode {
    case flashCard
    case quiz
}

//MARK: States ENUM
enum State {
    case question
    case answer
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    //MARK: Properties
    
    // Element array and index
    let fixedElementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var elementList: [String] = []
    var currentElementIndex = 0
    

    // Instances of enums declarations
    var state: State = .question
    var mode: Mode = .flashCard {
        didSet {
            // setupMode() called
            switch mode {
            case .flashCard:
                setupFlashCards()
            case .quiz:
                setupQuiz()
            }
            updateUI()
        }
    }
    
    
    // Quiz-specific state
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    //
    //
    // MARK: Actions
    // Switch modes Button
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    
    
    //
    //
    // MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .flashCard
        
    }
    
    
    
    //
    //
    // ShowAnswer Button
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    // Next Button
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        // Corrects Index out of range
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            // If QUIZ MODE on show result
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        
        state = .question
        updateUI()
    }
    
  
    
    
    
    //
    // MARK: TEXT FIELD
    // Runs when user hits Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Get the text from textField
        let textFieldContents = textField.text!
        
        // Checks if answer is correct
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        
        
        // Display answer to the user
        state = .answer
        
        updateUI()
        
        return true
    }
    
    //
    // MARK: SETUP MODES
    // New Flash card mode session
    func setupFlashCards (){
        elementList = fixedElementList
        
        state = .question
        currentElementIndex = 0
    }
    // New quiz session
    func setupQuiz() {
        elementList = fixedElementList.shuffled()
        
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
    }
    
    
    //
    //
    //
    // MARK: FLASH CARDS UI
    //Updates UI in FLASHCARD mode
    func updateFlashCardUI(elementName: String) {
        
        // Segment control
        modeSelector.selectedSegmentIndex = 0
        
        // Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)
        
        // Hide text field and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        
        // Answer Label
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    // MARK: QUIZ UI
    // Updates UI for QUIZ mode
    func updateQuizUI(elementName: String) {
        
        // Segment control
        modeSelector.selectedSegmentIndex = 1
        
        // Buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show Score", for: .normal)
        } else {
            nextButton.setTitle("Next Question", for: .normal)
        }
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }
        
        // Text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        // Answer Label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct"
            } else {
                answerLabel.text = "Wack wack waaack..\nCorrect Answer: " + elementName
            }
        case .score:
            answerLabel.text = "Your score is \(correctAnswerCount) out of \(elementList.count)."
        }
        
        // Score display
        if state == .score {
            displayScoreAlert()
        }
    }
    
    // MARK: UPDATE UIs
    // Gets current index, sets UIImage, switch updates UI
    func updateUI() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    
    
    //
    //
    // MARK: ALERT FOR SCORE
    // Show an alert with the score
    func displayScoreAlert() {
        
        // Create a new UI ALERT CONTROLLER
        let alert = UIAlertController(title: "Quiz score", message: "Your score is \(correctAnswerCount) out of \(elementList.count).", preferredStyle: .alert)
        
        // Create ALERT ACTION
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        
        // Present to the usr
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }

}

