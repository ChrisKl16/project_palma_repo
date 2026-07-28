//
//  OnboardingView.swift
//  project_palma
//
//  Created by Christian Kleeberg on 28.07.25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @AppStorage("onboardingComplete") private var onboardingComplete: Bool = false
    @State private var showSuccessOverlay = false
    
    var body: some View {
        ZStack {
            Background(BackgroundColor: .white)
            
            VStack {
                // Progress indicator
                ProgressView(value: viewModel.currentStep.progressValue, total: 1.0)
                    .tint(Color("BrandPrimaryColor"))
                    .padding()
                
                Spacer()
                
                // Current step content
                Group {
                    switch viewModel.currentStep {
                    case .welcome:
                        OnboardingWelcomeView(viewModel: viewModel)
                    case .interestsAndGroup:
                        OnboardingInterestsView(viewModel: viewModel)
                    case .profileCreation:
                        OnboardingProfileView(viewModel: viewModel)
                    case .privacySettings:
                        OnboardingPrivacyView(viewModel: viewModel)
                    }
                }
                
                Spacer()
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if viewModel.currentStep != .welcome {
                        Button(action: viewModel.moveToPreviousStep) {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(Color("BrandPrimaryColor"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .border(Color("BrandPrimaryColor"))
                        }
                    }
                    
                    Button(action: handleNextStep) {
                        Text(viewModel.currentStep == .privacySettings ? "Complete" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("BrandPrimaryColor"))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            if showSuccessOverlay {
                completionOverlay
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
    
    private var completionOverlay: some View {
        Color.black.opacity(0.35)
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("BrandPrimaryColor"))
                        .clipShape(Circle())
                    
                    Text("Onboarding Complete")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Welcome to Palma! Your profile has been saved.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(32)
                .background(Color("BrandPrimaryColor").opacity(0.95))
                .cornerRadius(24)
                .shadow(radius: 20)
            }
    }
    
    private func handleNextStep() {
        if viewModel.currentStep == .privacySettings {
            guard viewModel.isStep2Valid else {
                viewModel.alertItem = AlertContext.invalidForm
                return
            }
            viewModel.completeOnboarding()
            withAnimation {
                showSuccessOverlay = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onboardingComplete = true
            }
        } else {
            viewModel.moveToNextStep()
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Discover local events and connect with like-minded people in your city.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(Color("BrandPrimaryColor"))
                    Text("Find events near you")
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "person.2.circle.fill")
                        .foregroundColor(Color("BrandPrimaryColor"))
                    Text("Connect with others")
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.checkmark")
                        .foregroundColor(Color("BrandPrimaryColor"))
                    Text("Join activities you love")
                }
            }
            .font(.subheadline)
            .padding()
            .background(Color("BrandAccentColor1").opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
    }
}

// Step 2 - Interests & Group Preference
struct OnboardingInterestsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What are you interested in?")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Select at least 3 interests")
                .font(.caption)
                .foregroundColor(.gray)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.availableInterests, id: \.self) { interest in
                    InterestTagView(
                        title: interest,
                        isSelected: viewModel.selectedInterests.contains(interest),
                        action: {
                            if viewModel.selectedInterests.contains(interest) {
                                viewModel.selectedInterests.remove(interest)
                            } else {
                                viewModel.selectedInterests.insert(interest)
                            }
                        }
                    )
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            Text("Are you looking for events...")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                ForEach(GroupPreference.allCases, id: \.self) { preference in
                    PreferenceTagView(
                        title: preference.rawValue,
                        isSelected: viewModel.selectedGroupPreferences.contains(preference)
                    ) {
                        if viewModel.selectedGroupPreferences.contains(preference) {
                            viewModel.selectedGroupPreferences.remove(preference)
                        } else {
                            viewModel.selectedGroupPreferences.insert(preference)
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

struct PreferenceTagView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : Color("BrandPrimaryColor"))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(isSelected ? Color("BrandPrimaryColor") : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("BrandPrimaryColor"), lineWidth: isSelected ? 0 : 1)
            )
            .cornerRadius(12)
            .shadow(color: isSelected ? Color("BrandPrimaryColor").opacity(0.2) : .clear, radius: 3, x: 0, y: 2)
        }
    }
}

// Step 3 - Profile Creation
struct OnboardingProfileView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var agePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Set up your profile")
                .font(.title2)
                .fontWeight(.bold)
            
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("First Name", text: $viewModel.user.firstName)
                    TextField("Last Name", text: $viewModel.user.lastName)
                    TextField("Email", text: $viewModel.user.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
                    DatePicker("Birthday", selection: $viewModel.user.birthdate, displayedComponents: .date)
                    
                    Picker("Country", selection: $viewModel.selectedCountry) {
                        ForEach(viewModel.availableCountries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.top)
    }
}

// Step 4 - Privacy Settings
struct OnboardingPrivacyView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Privacy Settings")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Public Profile", isOn: $viewModel.user.isPublicProfile)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Allow others to find and view your profile")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Divider()
                    .padding(.vertical, 8)
                
                Toggle("Show Event Attendance", isOn: $viewModel.user.showAttendanceInPublic)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Text("Let others know which events you're attending")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("You can change these settings anytime in Profile Settings.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

// Interest Tag Component
struct InterestTagView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : Color("BrandPrimaryColor"))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color("BrandPrimaryColor") : Color.white)
                .border(Color("BrandPrimaryColor"))
                .cornerRadius(6)
        }
    }
}

#Preview {
    OnboardingView()
}
