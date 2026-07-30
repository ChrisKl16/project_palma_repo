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
    @State private var events: [MapEvent] = [
        MapEvent(
            title: "Sunset Meetup",
            description: "Lockeres Treffen im Park für neue Kontakte.",
            date: Date().addingTimeInterval(60 * 60 * 24),
            coordinate: CLLocationCoordinate2D(latitude: 52.5175, longitude: 13.4030),
            category: "Meetup",
            isPublic: true
        )
    ]
    @State private var isShowingCreateEvent = false
    @State private var draft = MapEventDraft()
    @State private var selectedEvent: MapEvent?

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

            Button(action: {
                draft = MapEventDraft()
                isShowingCreateEvent = true
            }) {
                Label("Event erstellen", systemImage: "plus.circle.fill")
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 4)
            }
            .padding()
            .accessibilityIdentifier("createEventButton")
        }
        .sheet(isPresented: $isShowingCreateEvent) {
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

                    Section("Standort") {
                        Text("Koordinaten der Kartenmitte")
                        Text("Lat: \(region.center.latitude, format: .number.precision(.fractionLength(4)))")
                        Text("Lon: \(region.center.longitude, format: .number.precision(.fractionLength(4)))")
                    }
                }
                .navigationTitle("Neues Event")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Abbrechen") {
                            isShowingCreateEvent = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Erstellen") {
                            addEvent()
                            isShowingCreateEvent = false
                        }
                        .disabled(draft.title.isEmpty)
                    }
                }
            }
        }
        .overlay(alignment: .top) {
            if let selectedEvent {
                eventDetailView(selectedEvent)
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private func addEvent() {
        let event = MapEvent(
            title: draft.title,
            description: draft.description,
            date: draft.date,
            coordinate: region.center,
            category: draft.category,
            isPublic: draft.isPublic
        )
        events.append(event)
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
