//
//  ViewController.swift
//  Concentration
//  Thanks you for watching my code.
//  Created by adam west on 27.04.23.

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    //MARK: Properties
    
    private var emojiCollection = "🦅🦂🐊🐅🐆🦓🦍🐘🦛🦏🐫🦩🦒🐃🐍"
    private var emojiDictionary = [Card:String]()
    private var statisticService: StatisticService?
    private lazy var game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    private var numberOfPairsOfCards: Int {
        return (buttonCollection.count + 1) / 2
    }
    
    static let collectionOfColors = [UIColor.red, .blue, .green, .brown, .orange, .purple]
    
    private(set) var touches = 0 {
        didSet {
            updateTouches()
        }
    }
    
     var theme: String? {
        didSet {
            emojiCollection = theme ?? ""
            emojiDictionary = [:]
            updateViewFromModel()
        }
    }
    
    //MARK: Override functions
    
    override func viewDidLoad() {
         super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
    }
    
    //MARK: Functions
    
    private func updateTouches() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: ViewController.collectionOfColors.randomElement() ?? UIColor.red]
        let attributedString = NSAttributedString(string: "Touches: \(touches)", attributes: attributes)
        touchLabel.attributedText = attributedString
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
    private func animation(_ button: UIButton) {
        UIView.animate(withDuration: 0.6, delay: 0.3, options: [.autoreverse], animations: {
            button.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    private func showAlert() {
        var text = "You win with touches: \(touches)"
        if let statisticService = statisticService {
            statisticService.store(total: touches)
            text += """
            \nAmount of played games: \(statisticService.gamesCount)
            Record: \(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
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
    
    // MARK: @IBOutlet Properties, Functions
    
    @IBOutlet private var buttonCollection: [UIButton]!
    @IBOutlet private weak var touchLabel: UILabel! {
        didSet {
            updateTouches()
        }
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
    
}


