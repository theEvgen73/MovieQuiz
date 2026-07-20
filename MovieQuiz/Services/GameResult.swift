import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    // Метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
