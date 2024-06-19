import SwiftUI

struct EventsView: View {
    @State private var events: [Event] = []
    
    @State private var isPresentingEventsForm = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    NavigationLink(destination: EventForm(onSave: { newEvent in
                        if let index = events.firstIndex(where: { $0.id == newEvent.id }) {
                            events[index] = newEvent
                        }
                    }, eventToEdit: event)) {
                        EventRow(event: event)
                    }
                }
                .onDelete { indexSet in
                    events.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Events")
            .toolbar {
                Button(action: {
                    isPresentingEventsForm = true
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
            .sheet(isPresented: $isPresentingEventsForm) {
                EventForm { newEvent in
                    events.append(newEvent)
                }
            }
        }
    }
}

#Preview {
    EventsView()
}
