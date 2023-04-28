//
//  ViewController.swift
//  Concentration
//
//  Created by adam west on 27.04.23.

import UIKit

class ViewController: UIViewController {

    lazy var game = ConcentrationGame(numberOfPairsOfCards: (buttonCollection.count + 1) / 2)
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

    var emojiCollection = ["🦅","🦂","🐊","🐅","🐆","🦓","🦍","🐘","🦛","🦏","🐫","🦩","🦒","🐃","🐍"]
    var emojiDictionary = [Int:String]()
    
    func emojiIdentifier(for card: Card) -> String {
        if emojiDictionary[card.identifier] == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiCollection.count)))
            emojiDictionary[card.identifier] =  emojiCollection.remove(at: randomIndex)
        }
            return emojiDictionary[card.identifier] ?? ""
        }
    func updateViewFromModel() {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
                button.setTitle(emojiIdentifier(for: card), for: .normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? UIColor.white : UIColor.label
            }
        }
    }
    
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet weak var touchLabel: UILabel!
    @IBAction func buttonAction(_ sender: UIButton) {
        touches += 1
        if let buttonIndex = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: buttonIndex)
            updateViewFromModel()
        }
    }
    
}

