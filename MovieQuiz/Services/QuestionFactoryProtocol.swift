import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    func requestNextQuestion() // ✅ метод без возврата, использует делегат
}
