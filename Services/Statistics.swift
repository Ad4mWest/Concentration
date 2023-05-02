//
//  Statistics.swift
//  Concentration
//
//  Created by adam west on 30.04.23.
//

import UIKit

protocol StatisticService {
    var total: Int { get set }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(total amount: Int)
}

struct GameRecord: Codable {
    let total: Int
    let date: Date
}

final class StatisticServiceImplementation: StatisticService {
   
    private enum Keys: String {
        case total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set (total) {
            userDefaults.set(total, forKey: Keys.total.rawValue)
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set (gamesCount) {
            userDefaults.set(gamesCount, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(total: total, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Impossible to save result")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(total amount: Int) {
        gamesCount += 1
        total += amount
        let newGame = GameRecord(total: amount, date: Date())
        if newGame.total < bestGame.total {
            bestGame = newGame
        }
    }
}