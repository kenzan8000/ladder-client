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
      .handleEvents(receiveOutput: { (output: URLSession.DataTaskPublisher.Output) in
        HTTPCookieStorage.shared.addCookies(urlResponse: output.response)
      })
      .map(\.data)
      .decode(type: Value.self, decoder: decoder)
      .mapError(LDRError.decoding)
      .eraseToAnyPublisher()
    // swiftlint:enable trailing_closure
  }
}
