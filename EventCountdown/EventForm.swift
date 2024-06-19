import SwiftUI

struct EventForm: View {
    var onSave: (Event) -> Void
    var eventToEdit: Event?
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var selectedDate = defaultDate()
    @State private var selectedColor = Color.blue
    @State private var showAlert = false
    
    static func defaultDate() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 12
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    ColorPicker("Color", selection: $selectedColor)
                }
            }
            .navigationTitle(eventToEdit == nil ? "Add Event" : "Edit Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !title.isEmpty else {
                            showAlert = true
                            return
                        }
                        
                        let newEvent: Event
                        if let eventToEdit = eventToEdit {
                            newEvent = Event(id: eventToEdit.id, title: title, date: selectedDate, textColor: selectedColor)
                        } else {
                            newEvent = Event(title: title, date: selectedDate, textColor: selectedColor)
                        }
                        
                        onSave(newEvent)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                if let eventToEdit = eventToEdit {
                    title = eventToEdit.title
                    selectedDate = eventToEdit.date
                    selectedColor = eventToEdit.textColor
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please enter a title."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    EventForm(onSave: {_ in })
}
