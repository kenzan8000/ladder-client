import Combine
import Foundation

// MARK: - LDRURLSession
protocol LDRURLSession {
  func publisher<Value: Decodable>(
    for request: LDRRequest<Value>,
    using decoder: JSONDecoder
  ) -> AnyPublisher<Value, LDRError>
}

// MARK: - URLSession + LDRURLSession
extension URLSession: LDRURLSession {
  // MARK: public api
  
  func publisher<Value: Decodable>(
    for request: LDRRequest<Value>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<Value, LDRError> {
    // swiftlint:disable trailing_closure
    dataTaskPublisher(for: request.urlRequest)
      .mapError { urlError -> LDRError in
        let error = LDRError.networking(urlError)
        logger.error("\(logger.prefix(), privacy: .private)\(error.legibleDescription, privacy: .private)")
        return error
      }
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: {
        HTTPCookieStorage.shared.addCookies(urlResponse: $0.response)
      })
      .map(\.data)
      .decode(type: Value.self, decoder: decoder)
      .mapError { urlError -> LDRError in
        let error = LDRError.decoding(urlError)
        logger.error("\(logger.prefix(), privacy: .private)\(error.legibleDescription, privacy: .private)")
        return error
      }
      .eraseToAnyPublisher()
    // swiftlint:enable trailing_closure
  }
}
