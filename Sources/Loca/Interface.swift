
import Foundation

class Interface {
  
  
  func loadTranslations(key: String, filter: String) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://localise.biz/api/export/all.json?key=\(key)&order=id&filter=\(filter)")!)
    return data
  }
  
  func loadTranslations(key: String = "4VzaYMZZsAuO0meW2iicPqvO8rcWOXU6", filter: String = "ios") async throws -> [String: [String: Any]] {
    try await loadTranslations(key: key, filter: filter).convertToDictionary() ?? [:]
  }
  
  
  func upload(data: Data, key: String = "REYlbwj4cdwO8mNCPn02peaucDkvK0X4c", tag: String = "ios") async throws -> [String: Any] {
    let (data, _) = try await URLSession
      .shared.data(for: makeRequest(data: data, key: key, tagAll: [tag]))
    return data.convertToDictionary() ?? [:]
  }
  
  public func makeRequest(
    data: Data,
    key: String = "REYlbwj4cdwO8mNCPn02peaucDkvK0X4c",
    tagAll: [String]
  ) -> URLRequest {
    
    var urlComponents = URLComponents(string: "https://localise.biz/api/import/json")!


    // Append updated query items array in the url component object
    urlComponents.queryItems = [
      URLQueryItem(name: "key", value: key),
      URLQueryItem(name: "tags-all", value: tagAll.joined(separator: ",")),
      URLQueryItem(name: "flag-new", value: "unapproved")
    ]
    
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = data
    
    return request
  }
}
