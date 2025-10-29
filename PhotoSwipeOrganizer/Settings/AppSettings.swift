import Foundation
import SwiftUI
import Combine

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isEnglish") var isEnglish: Bool = true
    @Published var showSettings: Bool = false
    
    var displayName: String {
        userName.isEmpty ? (isEnglish ? "user" : "usuario") : userName
    }
    
    private init() {}
}

