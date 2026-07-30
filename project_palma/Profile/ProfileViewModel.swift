//
//  AccountViewModel.swift
//  project_palma
//
//  Created by Christian Kleeberg on 29.07.25.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    
    @AppStorage("user") private var userData: Data?
    @Published var user = User()
    @Published var interestsText: String = ""
    
    @Published var alertItem: AlertItem?
    
    var isValidForm: Bool {
        guard !user.firstName.isEmpty && !user.lastName.isEmpty && !user.email.isEmpty else {
            alertItem = AlertContext.invalidForm
            return false }
        
        guard user.email.isValidEmail else {
            alertItem = AlertContext.invalidEmail
            return false
            }
        
        return true
    
    }
    
    func saveChanges() {
        guard isValidForm else { return }
        user.interests = interestsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        do {
            let data = try JSONEncoder().encode(user)
            userData = data
            alertItem = AlertContext.userSaveSuccess
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    
    
    func retrieveUser() {
        guard let userData = userData else { return }
        
        do {
            user = try JSONDecoder().decode(User.self, from: userData)
            interestsText = user.interests.joined(separator: ", ")
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    
    
}
