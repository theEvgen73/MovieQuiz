import Foundation

// MARK: - Protocol
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

// MARK: - Implementation
struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    // ✅ URL для запроса (исправлено: добавлено свойство)
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    // ✅ Исправлено: MostPopularMovies.self (с заглавной)
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    
                    // ✅ Проверяем errorMessage
                    if !mostPopularMovies.errorMessage.isEmpty {
                        let error = NSError(
                            domain: "MoviesLoader",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: mostPopularMovies.errorMessage]
                        )
                        handler(.failure(error))
                    } else {
                        // ✅ Успешный ответ
                        handler(.success(mostPopularMovies))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
