import SwiftUI
import Combine

class CountdownManager: ObservableObject {
    static let shared = CountdownManager()
    
    @Published var currentDate: Date = Date()
    private var timer: AnyCancellable?
    
    private init() {
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.currentDate = date
            }
    }
}

