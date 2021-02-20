import Combine
import Foundation

// MARK: - URLSession + LDRRequest
extension URLSession {
  // MARK: public api
  
  func publisher(
    for request: LDRRequest<Data>
  ) -> AnyPublisher<Data, Swift.Error> {
    dataTaskPublisher(for: request.urlRequest)
      .mapError(LDRError.networking)
      .map(\.data)
      .eraseToAnyPublisher()
  }

  func publisher<Value: Decodable>(
    for request: LDRRequest<Value>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<Value, Swift.Error> {
    dataTaskPublisher(for: request.urlRequest)
      .mapError(LDRError.networking)
      .map(\.data)
      .decode(type: Value.self, decoder: decoder)
      .mapError(LDRError.decoding)
      .eraseToAnyPublisher()
  }
}
