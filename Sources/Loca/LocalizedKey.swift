import Foundation

enum Locale: String, Codable {
  case en = "en"
  case deCH = "de-CH"
  case frCH = "fr-CH"
}

struct Plural: Codable, Hashable {
  enum Count: String, Codable {
    case one, other
  }
  
  var count: Count
  var translation: String
}

class LocalizedKey: Codable, Identifiable, Hashable {
  static func == (lhs: LocalizedKey, rhs: LocalizedKey) -> Bool {
    lhs.id == rhs.id
  }
  public func hash(into hasher: inout Hasher) {
       hasher.combine(ObjectIdentifier(self))
  }
  
  init(id: String) {
    self.id = id
  }
  
  var id: String
  var translations: [Locale: String]?
  var plurals: [Locale: [Plural]]?
  var tags: Set<String>?
  var comment: String?
  
  func add(translation: String, ofLanguage language: Locale, withTags newTags: Set<String>) {
    
    if (id == "more__help_legal__support") {
        print(2)
      }
    
    if let existingTranslations = translations {
      // Already some languages exist
      if let existingTranslation = existingTranslations[language]  {
        if existingTranslation != translation {
          // Conflict
          fatalError("Conflict: \(translation) already exists in \(language.rawValue)")
        } else {
          // Do nothing as already existing
        }
      } else {
        translations?[language] = translation
      }
    } else {
      translations = [language: translation]
    }
    
    tags = newTags.union(tags ?? [])
  }
  
  func add(plural: Plural, ofLanguage language: Locale, withTags newTags: Set<String>) {
    if let existingPlurals = plurals {
      // Already some languages exist
      if var existingLanguagePlurals = existingPlurals[language]  {
        if existingLanguagePlurals.contains(where: { $0.count == plural.count && $0.translation != plural.translation }) {
          // Conflict
          fatalError("Conflict: \(plural) already exists in \(language.rawValue)")
        } else if existingLanguagePlurals.contains(plural) {
          // Do nothing as already existing
        } else {
          existingLanguagePlurals.append(plural)
          plurals?[language] = existingLanguagePlurals
        }
      } else {
        plurals?[language] = [plural]
      }
    } else {
      plurals = [language: [plural]]
    }
    
    tags = newTags.union(tags ?? [])
  }
}
