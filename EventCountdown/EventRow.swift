import SwiftUI

struct Event: Comparable, Identifiable, Hashable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.date < rhs.date
    }
    
    let id: UUID
    var title: String
    var date: Date
    var textColor: Color
    
    init(id: UUID, title: String, date: Date, textColor: Color) {
        self.id = id
        self.title = title
        self.date = date
        self.textColor = textColor
    }
    
    init(title: String, date: Date, textColor: Color) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.textColor = textColor
    }
}

struct EventRow: View {
    let event: Event
    @State private var relativeEventDate: String = ""
    @StateObject private var countdownManager = CountdownManager.shared
    
    private func updateRelativeDateString() {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        relativeEventDate = formatter.localizedString(for: event.date, relativeTo: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title).foregroundColor(event.textColor)
            Text(relativeEventDate)
                .onAppear(perform: updateRelativeDateString)
                .onChange(of: countdownManager.currentDate) {
                    updateRelativeDateString()
                }
        }
    }
}

#Preview {
    let calendar = Calendar.current
    let components = DateComponents(year: 2024, month: 7, day: 18)
    if let specificDate = calendar.date(from: components) {
        return EventRow(event: Event(title: "Preview Event", date: specificDate, textColor: .blue))
    } else {
        return Text("Event date invalid.")
    }
}
