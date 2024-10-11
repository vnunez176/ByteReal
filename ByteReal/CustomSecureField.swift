//
//  CustomSecureField.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/11/24.
//
import SwiftUI

struct CustomSecureField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomSecureField

        init(parent: CustomSecureField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    @Binding var text: String
    var placeholder: String

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = placeholder
        textField.textContentType = .none  // Disable strong password suggestions
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.delegate = context.coordinator

        // Add similar styling to match SwiftUI's default
        textField.borderStyle = .roundedRect  // Add rounded border
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
