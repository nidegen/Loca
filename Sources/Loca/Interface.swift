
import Foundation

class Interface {
  
  
  func loadTranslations(key: String, filter: String) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://localise.biz/api/export/all.json?key=\(key)&order=id&filter=\(filter)")!)
    return data
  }
  
  func loadTranslations(key: String = "4VzaYMZZsAuO0meW2iicPqvO8rcWOXU6", filter: String = "ios") async throws -> [String: [String: Any]] {
    try await loadTranslations(key: key, filter: filter).convertToDictionary() ?? [:]
  }
  
  
  func upload(data: Data, key: String, tag: String, locale: Locale) async throws -> [String: Any] {
    let (data, _) = try await URLSession
      .shared.data(for: makeRequest(data: data, key: key, locale: locale, tagAll: [tag]))
    data.printJSON()
    return data.convertToDictionary() ?? [:]
  }
  
  public func makeRequest(
    data: Data,
    key: String = "REYlbwj4cdwO8mNCPn02peaucDkvK0X4c",
    locale: Locale,
    tagAll: [String]
  ) -> URLRequest {
    
    var urlComponents = URLComponents(string: "https://localise.biz/api/import/json")!


    // Append updated query items array in the url component object
    urlComponents.queryItems = [
      URLQueryItem(name: "locale", value: locale.rawValue),
      URLQueryItem(name: "key", value: key),
      URLQueryItem(name: "tag-all", value: tagAll.joined(separator: ",")),
      URLQueryItem(name: "flag-new", value: "unapproved"),
      URLQueryItem(name: "flag-updated", value: "unapproved")
      
    ]
    
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = data
    
    return request
  }
}
