import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings
    @Binding var isPresented: Bool
    @State private var tempUserName: String
    @State private var tempIsEnglish: Bool
    
    init(settings: AppSettings, isPresented: Binding<Bool>) {
        self.settings = settings
        self._isPresented = isPresented
        self._tempUserName = State(initialValue: settings.userName)
        self._tempIsEnglish = State(initialValue: settings.isEnglish)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("> \(Localizable.text("settings.title", isEnglish: tempIsEnglish))")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.green)
                    }
                }
                .padding()
                
                Divider().background(Color.green.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("> \(Localizable.text("settings.username", isEnglish: tempIsEnglish))")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.green)
                    
                    TextField("", text: $tempUserName)
                        .placeholder(when: tempUserName.isEmpty) {
                            Text(Localizable.text("settings.placeholder", isEnglish: tempIsEnglish))
                                .foregroundColor(.green.opacity(0.5))
                                .font(.system(size: 16, design: .monospaced))
                        }
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(.green)
                        .padding()
                        .background(Color(white: 0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("> \(Localizable.text("settings.language", isEnglish: tempIsEnglish))")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.green)
                    
                    HStack(spacing: 16) {
                        LanguageButton(
                            text: Localizable.text("settings.english", isEnglish: tempIsEnglish),
                            isSelected: tempIsEnglish
                        ) {
                            tempIsEnglish = true
                        }
                        
                        LanguageButton(
                            text: Localizable.text("settings.spanish", isEnglish: tempIsEnglish),
                            isSelected: !tempIsEnglish
                        ) {
                            tempIsEnglish = false
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    settings.userName = tempUserName
                    settings.isEnglish = tempIsEnglish
                    isPresented = false
                }) {
                    Text("> \(Localizable.text("settings.save", isEnglish: tempIsEnglish))")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }
}

struct LanguageButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .foregroundColor(isSelected ? .black : .green)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(isSelected ? Color.green : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green, lineWidth: isSelected ? 0 : 1)
                )
                .cornerRadius(8)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

