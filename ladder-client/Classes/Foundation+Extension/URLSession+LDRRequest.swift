import Combine
import Foundation

// MARK: - URLSession + LDRRequest
extension URLSession {
  // MARK: public api
  
  func publisher<Value: Decodable>(
    for request: LDRRequest<Value>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<Value, Swift.Error> {
    // swiftlint:disable trailing_closure
    dataTaskPublisher(for: request.urlRequest)
      .mapError(LDRError.networking)
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: {
        HTTPCookieStorage.shared.addCookies(urlResponse: $0.response)
      })
      .map(\.data)
      .decode(type: Value.self, decoder: decoder)
      .mapError(LDRError.decoding)
      .eraseToAnyPublisher()
    // swiftlint:enable trailing_closure
  }
}
