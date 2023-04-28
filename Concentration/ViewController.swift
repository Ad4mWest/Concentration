//
//  ViewController.swift
//  Concentration
//
//  Created by adam west on 27.04.23.

import UIKit

class ViewController: UIViewController {

    var touches = 0 {
        didSet {
            touchLabel.text = "Touches: \(touches)"
        }
    }
    
    func flipButton(emoji: String, button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: .normal)
            button.backgroundColor = UIColor.label
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
                button.setTitle(emoji, for: .normal)
                button.backgroundColor = UIColor.white
            }
        }

    let emojiCollection = ["🦊", "🐰", "🦊", "🐰"]
    
    
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var touchLabel: UILabel!
    @IBAction func buttonAction(_ sender: UIButton) {
        touches += 1
        if let buttonIndex = buttonCollection.firstIndex(of: sender) {
            flipButton(emoji: "\(emojiCollection[buttonIndex])", button: sender)
        }
    }
    
}

