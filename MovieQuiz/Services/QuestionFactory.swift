import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        guard !movies.isEmpty else {
            // Если фильмов нет, сообщаем об ошибке
            delegate?.didFailToLoadData(with: NSError(domain: "QuestionFactory", code: 0, userInfo: [NSLocalizedDescriptionKey: "No movies available"]))
            return
        }
        
        // Выбираем случайный фильм
        let index = Int.random(in: 0..<movies.count)
        let movie = movies[index]
        
        // Сообщаем делегату, что начинаем загрузку изображения
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didStartLoadingImage()
        }
        
        // Асинхронно загружаем изображение
        URLSession.shared.dataTask(with: movie.resizedImageURL) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                // Скрываем индикатор загрузки
                self.delegate?.didFinishLoadingImage()
                
                if let error = error {
                    self.delegate?.didFailToLoadData(with: error)
                    return
                }
                
                guard let data = data else {
                    self.delegate?.didFailToLoadData(with: NSError(domain: "ImageLoad", code: 0, userInfo: [NSLocalizedDescriptionKey: "No image data"]))
                    return
                }
                
                // Формируем вопрос
                let rating = Float(movie.rating) ?? 0
                let text = "Рейтинг этого фильма больше чем 7?"
                let correctAnswer = rating > 7
                let question = QuizQuestion(image: data, text: text, correctAnswer: correctAnswer)
                
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }.resume()
    }
}
