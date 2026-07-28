//
//  OnboardingView.swift
//  project_palma
//
//  Created by Christian Kleeberg on 28.07.25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
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
                    
                    Button(action: viewModel.moveToNextStep) {
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
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}

// Step 1 - Welcome
struct OnboardingWelcomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to Palma")
                .font(.title)
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
            
            Picker("Group Preference", selection: $viewModel.user.groupPreference) {
                Text(GroupPreference.alone.rawValue).tag(GroupPreference.alone)
                Text(GroupPreference.couple.rawValue).tag(GroupPreference.couple)
                Text(GroupPreference.smallGroup.rawValue).tag(GroupPreference.smallGroup)
                Text(GroupPreference.largeGroup.rawValue).tag(GroupPreference.largeGroup)
            }
            .pickerStyle(.segmented)
            .padding(.top, 8)
        }
        .padding()
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
