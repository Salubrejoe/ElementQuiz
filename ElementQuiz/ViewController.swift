//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Lore P on 27/05/2022.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    //Element array and index
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    

    //Instances of enums declarations
    var mode: Mode = .flashCard {
        didSet {
            updateUI()
            
        }
    }
    var state: State = .question
    
    //Quiz-specific state
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    
    //Switch modes Button
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        } else {
            mode = .quiz
        }
    }
    
    //ShowAnswer Button
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    //Next Button
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        //Corrects Index out of range
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        
        state = .question
        updateUI()
    }
    
    //Runs when user hits Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Get the text from textField
        let textFieldContents = textField.text!
        
        //Checks if answer is correct
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        
        
        //Display answer to the user
        state = .answer
        
        updateUI()
        
        return true
    }
    
    //Updates UI in FLASHCARD mode
    func updateFlashCardUI(elementName: String) {
        
        //Hide text field and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        
        //Answer Label
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    //Updates UI for QUIZ mode
    func updateQuizUI(elementName: String) {
        //Shows text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.resignFirstResponder()
        }
        
        //Answer Label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct"
            } else {
                answerLabel.text = "Wack wack waaack.."
            }
        }
    }
    
    //Gets current index, sets UIImage, switch updates UI
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

}

