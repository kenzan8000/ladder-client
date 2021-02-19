import Alamofire
import ISHTTPOperation
import SwiftyJSON

// MARK: - LDRPinOperationQueue
class LDRPinOperationQueue: ISHTTPOperationQueue {

  // MARK: - property

  static let shared = LDRPinOperationQueue()

 // MARK: - initialization

  override init() {
    super.init()
    maxConcurrentOperationCount = 3
  }

  // MARK: - destruction

  deinit {
    cancelAllOperations()
  }

  // MARK: - public api
    
  /// request api/pin/add api
  ///
  /// - Parameters:
  ///   - link: pin url
  ///   - title: pin title
  ///   - completionHandler: handler called when request ends
  func requestPinAdd(
    link: URL,
    title: String,
    completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
  ) {
    guard let apiKey = LDRRequestHelper.getApiKey() else {
      completionHandler(nil, LDRError.invalidApiKey)
      return
    }
    // invalid url
    guard let url = LDRRequestHelper.createUrl(path: LDR.Api.pinAdd) else {
      completionHandler(nil, LDRError.invalidLdrUrl)
      return
    }
    // request
    let httpBody = ["ApiKey": apiKey, "title": title, "link": link.absoluteString].HTTPBodyValue()
    let headers = LDRRequestHelper.createCookieHttpHeader(url: url, httpBody: httpBody)
    guard var request = try? URLRequest(
      url: url,
      method: HTTPMethod(rawValue: "POST"),
      headers: headers
    ) else {
      completionHandler(nil, LDRError.invalidLdrUrl)
      return
    }
    request.httpBody = httpBody
    self.addOperation(LDROperation(
      request: request
    ) { [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
      if let r = response {
        HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
      }
      var json = JSON([])
      do {
        if let data = object as? Data {
          json = try JSON(data: data)
        }
      } catch {
        DispatchQueue.main.async { [unowned self] in
          self.cancelAllOperations()
          LDRFeedOperationQueue.shared.cancelAllOperations()
          NotificationCenter.default.post(
            name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
            object: nil
          )
          completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
        }
        return
      }
      DispatchQueue.main.async {
        if let e = error {
          completionHandler(nil, e)
          return
        }
        completionHandler(json, nil)
      }
    })
  }

  /// request api/pin/remove api
  ///
  /// - Parameters:
  ///   - link: pin url
  ///   - completionHandler: handler called when request ends
  func requestPinRemove(
    link: URL,
    completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void
  ) {
    guard let apiKey = LDRRequestHelper.getApiKey() else {
      completionHandler(nil, LDRError.invalidApiKey)
      return
    }
    // invalid url
    guard let url = LDRRequestHelper.createUrl(path: LDR.Api.pinRemove) else {
      completionHandler(nil, LDRError.invalidLdrUrl)
      return
    }
    // request
    let httpBody = ["ApiKey": apiKey, "link": link.absoluteString].HTTPBodyValue()
    let headers = LDRRequestHelper.createCookieHttpHeader(url: url, httpBody: httpBody)
    guard var request = try? URLRequest(
      url: url,
      method: HTTPMethod(rawValue: "POST"),
      headers: headers
    ) else {
      completionHandler(nil, LDRError.invalidLdrUrl)
      return
    }
    request.httpBody = httpBody
    self.addOperation(LDROperation(
      request: request
    ) { [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
      if let r = response {
        HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
      }
      var json = JSON([])
      do {
        if let data = object as? Data {
          json = try JSON(data: data)
        }
      } catch {
        DispatchQueue.main.async { [unowned self] in
          self.cancelAllOperations()
          LDRFeedOperationQueue.shared.cancelAllOperations()
          NotificationCenter.default.post(
            name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
            object: nil
          )
          completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
        }
        return
      }
      DispatchQueue.main.async {
        if let e = error {
          completionHandler(nil, e)
          return
        }
        completionHandler(json, nil)
      }
    })
  }
    
  /// request api/pin/all api
  ///
  /// - Parameter completionHandler: handler called when request ends
  func requestPinAll(completionHandler: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
    guard let apiKey = LDRRequestHelper.getApiKey() else {
      completionHandler(nil, LDRError.invalidApiKey)
      return
    }
    // invalid url
    guard let url = LDRRequestHelper.createUrl(path: LDR.Api.pinAll) else {
      completionHandler(nil, LDRError.invalidLdrUrl)
      return
    }
    // request
    let httpBody = ["ApiKey": apiKey].HTTPBodyValue()
    let headers = LDRRequestHelper.createCookieHttpHeader(url: url, httpBody: httpBody)
    guard var request = try? URLRequest(
      url: url,
      method: HTTPMethod(rawValue: "POST"),
      headers: headers
    ) else {
      completionHandler(nil, LDRError.invalidLdrUrl)
      return
    }
    request.httpBody = httpBody
    self.addOperation(LDROperation(
      request: request
    ) { [unowned self] (response: HTTPURLResponse?, object: Any?, error: Error?) -> Void in
      if let r = response {
        HTTPCookieStorage.shared.addCookies(httpUrlResponse: r)
      }
      var json = JSON([])
      do {
        if let data = object as? Data {
          json = try JSON(data: data)
        }
      } catch {
        DispatchQueue.main.async { [unowned self] in
          self.cancelAllOperations()
          LDRFeedOperationQueue.shared.cancelAllOperations()
          NotificationCenter.default.post(
            name: LDRNotificationCenter.didGetInvalidUrlOrUsernameOrPasswordError,
            object: nil
          )
          completionHandler(nil, LDRError.invalidUrlOrUsernameOrPassword)
        }
        return
      }
      DispatchQueue.main.async {
        if let e = error {
          completionHandler(nil, e)
          return
        }
        completionHandler(json, nil)
      }
    })
  }
}
