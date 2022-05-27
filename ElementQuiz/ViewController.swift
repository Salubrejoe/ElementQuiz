//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Lore P on 27/05/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateElement()
        
    }
    
    // Shows image of the current Element
    func updateElement() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        answerLabel.text = "?"
    }

}

