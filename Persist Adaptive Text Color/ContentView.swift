//
//  ContentView.swift
//  Persist Adaptive Text Color
//
//  Created by Daniel Witt on 14.11.2023.
//
// Run this on macOS and you will see that the dynamic color is being saved and read.
// On iOS however the dynamic color becomes plain white or black (depending on wether dark mode was on or not while writing)

import SwiftUI

struct ContentView: View {
    #if os(iOS)
        let testAttributedString = NSAttributedString(string: "Test", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
    #elseif os(macOS)
        let testAttributedString = NSAttributedString(string: "Test", attributes: [NSAttributedString.Key.foregroundColor: NSColor.textColor])
    #endif

    @State var textData: Data?

    var body: some View {
        VStack {
            Button("Write string to data") {
                textData = try! testAttributedString.data(from: NSMakeRange(0, testAttributedString.length), documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.rtfd]) // <- This behaves different on macOS and iOS
                printColor(attributedString: testAttributedString, varName: "testAttributedString")
            }
            Button("Read string from data") {
                let testAttributedStringFromData = try! NSAttributedString(data: textData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
                printColor(attributedString: testAttributedStringFromData, varName: "testAttributedStringFromData")
            }
        }
        .padding()
        .buttonStyle(.borderedProminent)
    }

    func printColor(attributedString: NSAttributedString, varName: String) {
        #if os(iOS)
            print("\(varName) color: \(attributedString.attributes(at: 0, effectiveRange: nil)[.foregroundColor] as? UIColor)")
        #elseif os(macOS)
            print("\(varName) color: \(attributedString.attributes(at: 0, effectiveRange: nil)[.foregroundColor] as? NSColor)")
        #endif
    }
}

#Preview {
    ContentView()
}
