import Foundation

class Glossary {
  var keys = Set<LocalizedKey>()
  
  func load(data: [String: [String: Any]], ofTags tags: Set<String>, languages: [LanguageCode] = [.en, .deCH, .frCH]) {
    for language in languages {
      if let dict = data[language.rawValue] {
        load(data: dict, ofTags: tags, forLanguage: language)
      }
    }
  }
  
  func load(data: [String: Any], ofTags tags: Set<String>, forLanguage language: LanguageCode) {
    data.forEach { (keyId: String, translations: Any) in
      let existingkey = keys.first { $0.id == keyId }
      var key = LocalizedKey(id: keyId)
      if let existingKey = existingkey {
        key = existingKey
      } else {
        keys.insert(key)
      }
      
      if let singleTranslation = translations as? String {
        key.add(translation: singleTranslation, ofLanguage: language, withTags: tags)
      } else if let plurals = translations as? [String: String] {
        plurals.forEach { (count, translation) in
          if let countEnum =  Plural.Count.init(rawValue: count) {
            let parsed = Plural(count: countEnum, translation: translation)
            key.add(plural: parsed, ofLanguage: language, withTags: tags)
          }
        }
      }
      keys.insert(key)
    }
  }
}
