import Foundation
import ArgumentParser

@main
struct Loca: AsyncParsableCommand {
  @Option(name: .shortAndLong, help: "Example toggle")
  var example: Bool = false
  
  mutating func run() async throws {
    let interface = Interface()
    
    let glossary = Glossary()
    
    let dict = try await interface.loadTranslations(filter: "ios")
    glossary.load(data: dict, ofTags: ["ios"])
    let dictAndroid = try await interface.loadTranslations(filter: "android")
    glossary.load(data: dictAndroid, ofTags: ["android"])
    
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
