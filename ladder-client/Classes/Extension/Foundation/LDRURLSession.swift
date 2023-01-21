import Combine
import Foundation

// MARK: - LDRURLSession
protocol LDRURLSession {
  func publisher<Value: Decodable>(
    for request: LDRRequest<Value>,
    using decoder: JSONDecoder
  ) -> AnyPublisher<Value, LDRError>
}

// MARK: - LDRURLSession
struct LDRDefaultURLSession: LDRURLSession {
  // MARK: property
  
  private let keychain: LDRKeychain
  private let urlSession: URLSession
  
  // MARK: initializer
  
  init(keychain: LDRKeychain, urlSession: URLSession = .shared) {
    self.keychain = keychain
    self.urlSession = urlSession
  }
  
  // MARK: public api
  
  func publisher<Value: Decodable>(
    for request: LDRRequest<Value>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<Value, LDRError> {
    // swiftlint:disable trailing_closure
    urlSession.dataTaskPublisher(for: request.urlRequest)
      .validate(statusCode: 200..<300)
      .mapError { urlError -> LDRError in
        let error = LDRError.networking(urlError)
        logger.error("\(logger.prefix(), privacy: .private)\(error.legibleDescription, privacy: .private)")
        return error
      }
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: {
        keychain.addCookies(urlResponse: $0.response)
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
