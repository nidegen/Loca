
import Foundation

class Interface {
  
  
  func loadTranslations(key: String, filter: String) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://localise.biz/api/export/all.json?key=\(key)&order=id&filter=\(filter)")!)
    return data
  }
  
  func loadTranslations(key: String = "4VzaYMZZsAuO0meW2iicPqvO8rcWOXU6", filter: String = "ios") async throws -> [String: [String: Any]] {
    try await loadTranslations(key: key, filter: filter).convertToDictionary() ?? [:]
  }
}
