//
//  ContactEditorView.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import SwiftUI

struct ContactEditorView: View {
    private static let accentPurple = Color(red: 0x66/255.0, green: 0x7E/255.0, blue: 0xEA/255.0)

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "envelope.fill")
                .font(.system(size: 48))
                .foregroundStyle(Self.accentPurple)
            Text("Contact")
                .font(.system(size: 24, weight: .bold))
            Text("Coming soon")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
