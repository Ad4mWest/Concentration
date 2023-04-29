//
//  ConcentrationGame.swift
//  Concentration
//
//  Created by adam west on 28.04.23.
//

import Foundation

struct ConcentrationGame {
   
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
       return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            cards.indices.forEach{ index in
                return cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
   mutating func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchingIndex = indexOfOneAndOnlyFaceUpCard, matchingIndex != index {
                if cards[matchingIndex] == cards[index] {
                    cards[matchingIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
        init(numberOfPairsOfCards: Int) {
            assert(numberOfPairsOfCards > 0, "ConcentrationGame.init must have at list one pair of cards")
            for _ in 1...numberOfPairsOfCards {
                let card = Card()
                cards += [card, card]
                cards = cards.shuffled()
            }
        }
    }

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
