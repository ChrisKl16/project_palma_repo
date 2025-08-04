//
//  User.swift
//  project_palma
//
//  Created by Christian Kleeberg on 29.07.25.
//

//User - Data - UserDefaults
import Foundation

struct User: Codable {
    var firstName = ""
    var lastName = ""
    var country = ""
    var email = ""
    var birthdate = Date()
    var interests = ""
    var bio = ""
}
