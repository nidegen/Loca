import Foundation
import ArgumentParser

@main
struct Loca: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "Example toggle")
  var example: Bool = false
  
  var testRepoKey = "REYlbwj4cdwO8mNCPn02peaucDkvK0X4c"
  var brezelkoenigKey = "4VzaYMZZsAuO0meW2iicPqvO8rcWOXU6"
  
  mutating func run() async throws {
    let interface = Interface()
    
    let glossary = Glossary()
    
    let dict = try await interface.loadTranslations(filter: "ios")
    glossary.load(data: dict, ofTags: ["ios"])
    let dictAndroid = try await interface.loadTranslations(filter: "android")
    glossary.load(data: dictAndroid, ofTags: ["android"])
    
    guard let data = glossary.getData(language: .frCH, tag: "ios").jsonData else { return }
    
    let response = try await interface.upload(data: data, key: testRepoKey, tag: "android", locale: .frCH)
    print(response)
    print("-=-=-")
  }
}

extension Data {
  func printJSON() {
    if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
      print(JSONString)
    }
  }
}

extension Dictionary {
  var jsonData: Data? {
    try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
  }
}
extension Data {
  func convertToDictionary() -> [String: [String: Any]]? {
    return try? JSONSerialization.jsonObject(with: self, options: []) as? [String: [String: Any]]
  }
}
