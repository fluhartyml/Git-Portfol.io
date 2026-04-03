//
//  OnboardingView.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var errorMessage: String?

    private static let accentPurple = Color(red: 0x66/255.0, green: 0x7E/255.0, blue: 0xEA/255.0)
    private let gitService = GitService()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 128, height: 128)

            Text("Git Portfol.io")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(Self.accentPurple)

            Text("Manage your GitHub Pages portfolio")
                .font(.system(size: 20))
                .foregroundStyle(.secondary)

            Button(action: selectRepository) {
                Text("Select Repository")
                    .font(.system(size: 18, weight: .medium))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(Self.accentPurple)

            if let errorMessage {
                Text(errorMessage)
                    .font(.system(size: 18))
                    .foregroundStyle(.red)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func selectRepository() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.message = "Select your GitHub Pages repository folder"

        guard panel.runModal() == .OK, let url = panel.url else { return }

        let path = url.path
        guard gitService.isGitRepo(at: path) else {
            errorMessage = "Selected folder is not a git repository."
            return
        }

        let repoName = url.lastPathComponent
        var branchName = "main"
        var remoteName = "origin"
        var username = ""

        if let branch = try? gitService.currentBranch(at: path) {
            branchName = branch
        }
        if let remoteURL = try? gitService.remoteURL(at: path) {
            // Extract username from github.com/username/repo
            let components = remoteURL.components(separatedBy: "/")
            if let ghIndex = components.firstIndex(where: { $0.contains("github.com") }),
               ghIndex + 1 < components.count {
                username = components[ghIndex + 1]
            }
        }

        let settings = RepoSettings(
            repoPath: path,
            repoName: repoName,
            remoteName: remoteName,
            branchName: branchName,
            githubUsername: username
        )
        modelContext.insert(settings)
        errorMessage = nil
    }
}
