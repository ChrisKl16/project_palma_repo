//
//  Alert.swift
//  project_palma
//
//  Created by Christian Kleeberg on 29.07.25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}


struct AlertContext {
    // MARK: - Network Alerts
    static let invalidData = AlertItem(title: Text("Server errors"),
                                              message: Text("The recevied from the server is invalid"),
                                              dismissButton: .default(Text("OK")))
    
    static let invalidResponse = AlertItem(title: Text("Server Error"),
                                              message: Text("Something is wrong with device"),
                                              dismissButton: .default(Text("OK")))
    
    static let invalidURL = AlertItem(title: Text("Server Error"),
                                              message: Text("There was an issue connection to the server"),
                                              dismissButton: .default(Text("OK")))
    

    static let unableToComplete = AlertItem(title: Text("Server Error"),
                                              message: Text("Unable to complete your request. Please check your internet connection"),
                                              dismissButton: .default(Text("OK")))
    
    //MARK: - Account Alerts
    static let invalidForm = AlertItem(title: Text("Invalid Form"),
                                              message: Text("Unable to complete your request. Please check your internet connection"),
                                              dismissButton: .default(Text("OK")))
    

    static let invalidEmail = AlertItem(title: Text("Invalid Email"),
                                              message: Text("Unable to complete your request. Please check your internet connection"),
                                              dismissButton: .default(Text("OK")))
    
    static let userSaveSuccess = AlertItem(title: Text("Profile Saved"),
                                              message: Text("Your profile information was successfully saved"),
                                              dismissButton: .default(Text("OK")))
    
    static let invalidUserData = AlertItem(title: Text("Profile Error"),
                                              message: Text("There was an error saving or retrieving your profile"),
                                              dismissButton: .default(Text("OK")))
    
    static let incompleteOnboarding = AlertItem(title: Text("Incomplete"),
                                              message: Text("Please complete all required fields before proceeding"),
                                              dismissButton: .default(Text("OK")))
}
