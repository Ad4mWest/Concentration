//
//  ViewController.swift
//  Concentration
//
//  Created by adam west on 27.04.23.

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    private lazy var game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
    static let collectionOfColors = [UIColor.red, .blue, .green, .brown, .orange, .purple]

    var numberOfPairsOfCards: Int {
        return (buttonCollection.count + 1) / 2
    }
    
    private func updateTouches() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: ViewController.collectionOfColors.randomElement() ?? UIColor.red]
        let attributedString = NSAttributedString(string: "Touches: \(touches)", attributes: attributes)
        touchLabel.attributedText = attributedString
    }
    private(set) var touches = 0 {
        didSet {
            updateTouches()
        }
    }
    
    private func flipButton(emoji: String, button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: .normal)
            button.backgroundColor = UIColor.label
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
            button.setTitle(emoji, for: .normal)
            button.backgroundColor = UIColor.white
        }
    }
    
    var theme: String? {
        didSet {
            emojiCollection = theme ?? ""
            emojiDictionary = [:]
            updateViewFromModel()
        }
    }
    
    
    private var emojiCollection = "🦅🦂🐊🐅🐆🦓🦍🐘🦛🦏🐫🦩🦒🐃🐍"
    private var emojiDictionary = [Card:String]()
    
    private func emojiIdentifier(for card: Card) -> String {
        if emojiDictionary[card] == nil {
            let randomStringIndex = emojiCollection.index(emojiCollection.startIndex, offsetBy: emojiCollection.count.arc4randomExtension)
            emojiDictionary[card] = String(emojiCollection.remove(at: randomStringIndex))
        }
        return emojiDictionary[card] ?? ""
    }
    
    private func updateViewFromModel() {
        if buttonCollection != nil {
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
    }
    @IBOutlet private var buttonCollection: [UIButton]!
    @IBOutlet private weak var touchLabel: UILabel! {
        didSet {
            updateTouches()
        }
    }
    func animation(_ button: UIButton) {
        UIView.animate(withDuration: 0.6, delay: 0.3, options: [.autoreverse], animations: {
            button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    @IBAction private func buttonAction(_ sender: UIButton) {
       
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})

        touches += 1
        
        if let buttonIndex = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: buttonIndex)
            animation(sender)
            updateViewFromModel()
        } else {
            sender.layer.removeAllAnimations()
        }
        if ConcentrationGame.countOfMatches == 6 {
            showAlert()
        }
    }
    
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
         super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
    }
    func showAlert() {
        var text = "You end game for \(touches) touches"
        if let statisticService = statisticService {
            statisticService.store(total: touches)
            text += """
            \nAmount of played games: \(statisticService.gamesCount)
            Record: \(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Total accuracy: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        }
        let alertController = UIAlertController(title: "Congratulations!", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.touches = 0
            ConcentrationGame.countOfMatches = 0
            
            self.self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension Int {
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
           return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

