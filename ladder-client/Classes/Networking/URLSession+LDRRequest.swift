import Combine

// MARK: - URLSession + LDRRequest
extension URLSession {
  // MARK: Error
  enum Error: Swift.Error {
    case networking(URLError)
    case decoding(Swift.Error)
  }

  // MARK: public api
  
  func publisher(
    for request: LDRRequest<Data>
  ) -> AnyPublisher<Data, Swift.Error> {
    dataTaskPublisher(for: request.urlRequest)
      .mapError(Error.networking)
      .map(\.data)
      .eraseToAnyPublisher()
  }

  func publisher<Value: Decodable>(
    for request: LDRRequest<Value>,
    using decoder: JSONDecoder = .init()
  ) -> AnyPublisher<Value, Swift.Error> {
    dataTaskPublisher(for: request.urlRequest)
      .mapError(Error.networking)
      .map(\.data)
      .decode(type: Value.self, decoder: decoder)
      .mapError(Error.decoding)
      .eraseToAnyPublisher()
  }
}
