//
//  File.swift
//  
//
//  Created by Nicolas Degen on 22.08.22.
//

import Foundation

struct Locale: Codable {
  let code: LanguageCode
}

struct Translation: Codable {
  let id: String
  let translation: String
  let locale: Locale
}

struct Asset: Codable {
  let id: String
  let printf: String
  let plurals: Int
  let tags: [String]
}
