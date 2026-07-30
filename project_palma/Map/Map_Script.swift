//
//  Map_Script.swift
//  project_palma
//
//  Created by Christian Kleeberg on 15.07.25.
//

import SwiftUI
import MapKit

struct MapEvent: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let coordinate: CLLocationCoordinate2D
    let category: String
    let isPublic: Bool

    static func == (lhs: MapEvent, rhs: MapEvent) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.date == rhs.date &&
        lhs.category == rhs.category &&
        lhs.isPublic == rhs.isPublic &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct MapEventDraft {
    var title = ""
    var description = ""
    var date = Date()
    var category = "Activity"
    var isPublic = true
}

struct project_palma_map: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
        span: MKCoordinateSpan(latitudeDelta: 0.14, longitudeDelta: 0.14)
    )
    @State private var selectionRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
        span: MKCoordinateSpan(latitudeDelta: 0.14, longitudeDelta: 0.14)
    )
    @State private var events: [MapEvent] = []
    @State private var isShowingCreateEventForm = false
    @State private var isShowingLocationPicker = false
    @State private var draft = MapEventDraft()
    @State private var selectedEvent: MapEvent?
    @State private var creationNotice: String?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: events
            ) { event in
                MapAnnotation(coordinate: event.coordinate) {
                    Button(action: {
                        selectedEvent = event
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                            Text(event.title)
                                .font(.caption)
                                .lineLimit(1)
                                .padding(6)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .mapStyle(.standard(elevation: .realistic))

            Button(action: startEventCreation) {
                Label("Event erstellen", systemImage: "plus.circle.fill")
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 4)
            }
            .padding()
            .accessibilityIdentifier("createEventButton")
        }
        .sheet(isPresented: $isShowingCreateEventForm) {
            NavigationView {
                Form {
                    Section("Event") {
                        TextField("Titel", text: $draft.title)
                        TextField("Beschreibung", text: $draft.description)
                        DatePicker("Datum", selection: $draft.date, displayedComponents: [.date, .hourAndMinute])
                        Picker("Kategorie", selection: $draft.category) {
                            Text("Activity").tag("Activity")
                            Text("Event").tag("Event")
                            Text("Meetup").tag("Meetup")
                        }
                        Toggle("Öffentlich", isOn: $draft.isPublic)
                    }
                }
                .navigationTitle("Neues Event")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Abbrechen") {
                            isShowingCreateEventForm = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Weiter") {
                            prepareLocationSelection()
                        }
                        .disabled(draft.title.isEmpty)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingLocationPicker) {
            NavigationView {
                ZStack {
                    Map(
                        coordinateRegion: $selectionRegion,
                        interactionModes: .all,
                        showsUserLocation: true
                    )
                    .mapStyle(.standard(elevation: .realistic))

                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.red)
                            .shadow(radius: 4)
                            .padding(.top, 40)
                        Spacer()
                    }
                    .allowsHitTesting(false)

                    VStack {
                        Text("Verschiebe die Karte, um den genauen Standort festzulegen.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(12)
                            .background(.regularMaterial)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.top)
                }
                .navigationTitle("Standort wählen")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Zurück") {
                            isShowingLocationPicker = false
                            isShowingCreateEventForm = true
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Bestätigen") {
                            addEvent(at: selectionRegion.center)
                            isShowingLocationPicker = false
                        }
                        .disabled(draft.title.isEmpty)
                    }
                }
            }
        }
        .overlay(alignment: .top) {
            VStack {
                if let selectedEvent {
                    eventDetailView(selectedEvent)
                        .padding()
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                if let creationNotice {
                    Text(creationNotice)
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    creationNotice = nil
                                }
                            }
                        }
                }
            }
            .padding(.top, 16)
        }
    }

    private func startEventCreation() {
        draft = MapEventDraft()
        selectionRegion = region
        isShowingCreateEventForm = true
    }

    private func prepareLocationSelection() {
        selectionRegion = region
        isShowingCreateEventForm = false
        isShowingLocationPicker = true
    }

    private func addEvent(at coordinate: CLLocationCoordinate2D) {
        let event = MapEvent(
            title: draft.title,
            description: draft.description,
            date: draft.date,
            coordinate: coordinate,
            category: draft.category,
            isPublic: draft.isPublic
        )
        events.append(event)
        selectedEvent = event
        region.center = coordinate
        creationNotice = "Event „\(event.title)“ wurde erstellt."
    }

    @ViewBuilder
    private func eventDetailView(_ event: MapEvent) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.headline)
                    Text(event.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: {
                    selectedEvent = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }

            Text(event.description)
                .font(.body)
            Text("Datum: \(event.date.formatted(date: .abbreviated, time: .shortened))")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(16)
        .shadow(radius: 8)
    }
}
