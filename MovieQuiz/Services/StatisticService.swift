import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    // MARK: - StatisticServiceProtocol Properties
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard totalQuestionsAsked > 0 else { return 0 }
        return (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100
    }
    
    // MARK: - Private Properties for Calculations
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    // MARK: - StatisticServiceProtocol Methods
    
    func store(correct count: Int, total amount: Int) {
        // Обновляем общее количество правильных ответов
        totalCorrectAnswers += count
        
        // Обновляем общее количество вопросов
        totalQuestionsAsked += amount
        
        // Увеличиваем счётчик игр
        gamesCount += 1
        
        // Создаём результат текущей игры
        let currentResult = GameResult(correct: count, total: amount, date: Date())
        
        // Сравниваем с лучшим результатом и обновляем, если нужно
        if currentResult.isBetterThan(bestGame) {
            bestGame = currentResult
        }
    }
}
