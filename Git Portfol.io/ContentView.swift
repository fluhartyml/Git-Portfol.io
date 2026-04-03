//
//  ContentView.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import SwiftUI
import SwiftData

enum SidebarSection: String, CaseIterable, Identifiable {
    case home = "Home"
    case projects = "Projects"
    case blog = "Blog"
    case credentials = "Credentials"
    case contact = "Contact"
    case photos = "Photos"
    case files = "Files"
    case git = "Git"
    case settings = "Settings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .projects: return "folder.fill"
        case .blog: return "text.document.fill"
        case .credentials: return "person.text.rectangle.fill"
        case .contact: return "envelope.fill"
        case .photos: return "photo.on.rectangle.fill"
        case .files: return "doc.text.fill"
        case .git: return "arrow.triangle.branch"
        case .settings: return "gearshape.fill"
        }
    }
}

struct ContentView: View {
    @Query private var repoSettings: [RepoSettings]
    @State private var selectedSection: SidebarSection? = .home

    private static let accentPurple = Color(red: 0x66/255.0, green: 0x7E/255.0, blue: 0xEA/255.0)

    var body: some View {
        if repoSettings.isEmpty {
            OnboardingView()
        } else {
            NavigationSplitView {
                List(SidebarSection.allCases, selection: $selectedSection) { section in
                    Label(section.rawValue, systemImage: section.icon)
                        .font(.system(size: 18))
                }
                .navigationSplitViewColumnWidth(220)
                .listStyle(.sidebar)
            } detail: {
                detailView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .tint(Self.accentPurple)
            .accentColor(Self.accentPurple)
        }
    }

    @ViewBuilder
    private var detailView: some View {
        switch selectedSection {
        case .home:
            HomeEditorView()
        case .projects:
            ProjectManagerView()
        case .blog:
            BlogManagerView()
        case .credentials:
            CredentialsEditorView()
        case .contact:
            ContactEditorView()
        case .photos:
            PhotoManagerView()
        case .files:
            FileBrowserView()
        case .git:
            GitStatusView()
        case .settings:
            SettingsView()
        case .none:
            Text("Select a section")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
        }
    }
}
