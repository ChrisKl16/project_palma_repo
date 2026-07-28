//
//  OnboardingViewModel.swift
//  project_palma
//
//  Created by Christian Kleeberg on 28.07.25.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    
    @AppStorage("user") private var userData: Data?
    
    @Published var currentStep: OnboardingStep = .welcome
    @Published var user = User()
    @Published var selectedInterests: Set<String> = []
    @Published var selectedGroupPreferences: Set<GroupPreference> = []
    @Published var selectedCountry: String = ""
    @Published var alertItem: AlertItem?
    
    let availableInterests = [
        "Yoga", "Running", "Hiking", "Cycling", "Sports",
        "Cooking", "Wine Tasting", "Coffee", "Dining",
        "Painting", "Photography", "Music", "Theater",
        "Book Club", "Gaming", "Tech", "Meditation",
        "Dance", "Fitness", "Outdoor", "Community"
    ]
    
    let availableCountries = [
        "Germany", "Austria", "Switzerland", "France",
        "Italy", "Spain", "Netherlands", "Belgium",
        "Poland", "Sweden", "Denmark", "Portugal"
    ]
    
    var isStep1Valid: Bool {
        !selectedInterests.isEmpty && !selectedGroupPreferences.isEmpty
    }
    
    var isStep2Valid: Bool {
        !user.firstName.isEmpty && !user.lastName.isEmpty && 
        !user.email.isEmpty && user.email.isValidEmail &&
        !selectedCountry.isEmpty
    }
    
    func moveToNextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .interestsAndGroup
        case .interestsAndGroup:
            guard isStep1Valid else {
                alertItem = AlertContext.incompleteOnboarding
                return
            }
            user.interests = Array(selectedInterests)
            user.groupPreferences = Array(selectedGroupPreferences)
            currentStep = .profileCreation
        case .profileCreation:
            guard isStep2Valid else {
                alertItem = AlertContext.invalidForm
                return
            }
            currentStep = .privacySettings
        case .privacySettings:
            completeOnboarding()
        }
    }
    
    func moveToPreviousStep() {
        switch currentStep {
        case .welcome:
            break
        case .interestsAndGroup:
            currentStep = .welcome
        case .profileCreation:
            currentStep = .interestsAndGroup
        case .privacySettings:
            currentStep = .profileCreation
        }
    }
    
    func completeOnboarding() {
        user.hasCompletedOnboarding = true
        saveUser()
    }
    
    private func saveUser() {
        do {
            let data = try JSONEncoder().encode(user)
            userData = data
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    
    func retrieveUser() {
        guard let userData = userData else { return }
        
        do {
            user = try JSONDecoder().decode(User.self, from: userData)
            selectedInterests = Set(user.interests)
            selectedGroupPreferences = Set(user.groupPreferences)
            selectedCountry = user.country
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
}

enum OnboardingStep {
    case welcome
    case interestsAndGroup
    case profileCreation
    case privacySettings
    
    var progressValue: Double {
        switch self {
        case .welcome:
            return 0.25
        case .interestsAndGroup:
            return 0.5
        case .profileCreation:
            return 0.75
        case .privacySettings:
            return 1.0
        }
    }
}
