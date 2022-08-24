
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
    request.setValue(key, forHTTPHeaderField: "Authentication")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = data
    
    return request
  }
  
  func write(to url: URL, glossary: Glossary) {
    do {
      let data = try JSONEncoder().encode(glossary)
      // The JSON data is in bytes. Let's printit as a JSON string.
      if let jsonString = String(data: data, encoding: .utf8) {
        print(jsonString)
      }
      let dict = data.convertToArray()!
      let jsonData = dict.jsonData!
      try data.write(to: url)
    } catch {
      print("🚨 Error: Could not write to \(url)")
    }
  }
  
  private func getAssets(key: String) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://localise.biz/api/assets?key=\(key)")!)
    return data
  }
  
  func getAssets(key: String) async throws -> [Asset] {
    try JSONDecoder().decode([Asset].self, from: try await getAssets(key: key))
  }
  
  private func getTranslation(id: String, key: String) async throws -> Data {
    try await URLSession.shared.data(from: URL(string: "https://localise.biz/api/translations/\(id)?key=\(key)")!).0
  }
  
  func getTranslations(ids: [String], key: String) async throws -> [Translation] {
    var translations = [Translation]()
    for id in ids {
      let translation = try JSONDecoder().decode([Translation].self, from: try await getTranslation(id: id, key: key))
      translation.first.map { translations.append($0) }
    }
    return translations
  }
}
