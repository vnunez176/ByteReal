//
//  CodeTextView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/11/24.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable {
    @Binding var codeSnippet: String
    var lineNumbers: Bool

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CodeTextView

        init(parent: CodeTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.codeSnippet = textView.text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "Menlo", size: 14) 
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.autocapitalizationType = .none
        textView.keyboardType = .default
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = codeSnippet
    }
}
