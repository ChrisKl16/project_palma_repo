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
    var interests: [String] = []  // Changed to array for better handling
    var bio = ""
    var hasCompletedOnboarding = false
    var userType: UserType = .individual
    var groupPreference: GroupPreference = .alone
    var profilePictures: [String] = []  // Store as base64 strings or file paths
    var isPublicProfile = true
    var showAttendanceInPublic = true
}

enum UserType: String, Codable {
    case individual
    case business
}

enum GroupPreference: String, Codable {
    case alone = "Alone"
    case couple = "Couple"
    case smallGroup = "Small Group (3-5)"
    case largeGroup = "Large Group (5+)"
}
