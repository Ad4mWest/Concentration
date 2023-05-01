//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by adam west on 30.04.23.
//

import UIKit
import AudioToolbox

class ConcentrationThemeChooserViewController: UIViewController {

    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🥏🎱🥊⛸️🛹",
        "Food": "🍕🍔🍟🥪🌮🥟🍤🍣🍡🍭🍩🍫🍿",
        "Animals": "🦅🦂🐊🐅🐆🦓🦍🐘🦛🦏🐫🦩🦒🐃🐍",
        "Flags": "🇬🇪🇨🇦🇦🇺🇨🇳🇮🇱🇯🇵🇷🇺🇺🇸🇬🇧🇰🇷🇲🇾🇩🇪🇧🇩"
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                    if let cvc = segue.destination as? ViewController {
                        cvc.theme = theme
                        
                    }
            }
        }
    }
    
    @IBAction func actionForButtons(_ sender: UIButton) {
        sender.tintColor = ViewController.collectionOfColors.randomElement() ?? .red
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})

    }
}
