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
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    var mode: Mode = .flashCard
    var state: State = .question
    
    //Quiz-specific state
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
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
    
    //Gets current INDEX and sets UIImage + "?"/"Name"
    func updateFlashCardUI() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
    }
    
    func updateQuizUI() {
        
    }
    
    func updateUI() {
        switch mode {
        case .flashCard:
            updateFlashCardUI()
        case .quiz:
            updateQuizUI()
        }
    }

}

