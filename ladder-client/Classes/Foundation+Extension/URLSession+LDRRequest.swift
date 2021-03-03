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
      .handleEvents(receiveOutput: {
        HTTPCookieStorage.shared.addCookies(urlResponse: $0.response)
      })
      .map(\.data)
      .handleEvents(receiveOutput: {
        do {
          let json = try JSONSerialization.jsonObject(with: $0, options: [])
          let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
          print(String(data: data, encoding: .utf8))
        } catch {
        }
      })
      .decode(type: Value.self, decoder: decoder)
      .mapError(LDRError.decoding)
      .eraseToAnyPublisher()
    // swiftlint:enable trailing_closure
  }
}
