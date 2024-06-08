import Foundation
import UIKit


final class StatisticService: StatisticServiceProtocol{
    
    private let storage: UserDefaults = .standard
    private var correctAnswers: Int = 0
    
    private enum Keys: String{
        case correct
        case bestGame
        case gamesCount
        case total
        case date
    }
    
    var correct: Int{
        get{
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int{
        get{
            storage.integer(forKey: Keys.total.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.total.rawValue)
        }
    }

    var totalAccuracy: Double{
        ((Double(total) / Double(gamesCount) * 10))
    }
    
    var gamesCount: Int{
        get{
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult{
        get{
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            return GameResult(correct: correct, total: total, date: date)
        }
        set{
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        correct = count
        total += count
        gamesCount += 1
        
        let newRecord = GameResult(correct: correct, total: amount, date: Date())
        
        if newRecord.isBetterThan(bestGame){
            bestGame = newRecord
        }
    }
}
