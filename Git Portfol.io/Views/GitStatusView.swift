//
//  GitStatusView.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import SwiftUI
import SwiftData

struct GitStatusView: View {
    @Query private var repoSettings: [RepoSettings]
    @State private var branch: String = ""
    @State private var files: [FileStatus] = []
    @State private var commitMessage: String = ""
    @State private var statusMessage: String?
    @State private var isLoading = false

    private static let accentPurple = Color(red: 0x66/255.0, green: 0x7E/255.0, blue: 0xEA/255.0)
    private let gitService = GitService()

    private var repoPath: String {
        repoSettings.first?.repoPath ?? ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "arrow.triangle.branch")
                    .font(.system(size: 24))
                    .foregroundStyle(Self.accentPurple)
                Text("Git")
                    .font(.system(size: 24, weight: .bold))

                Spacer()

                if !branch.isEmpty {
                    Label(branch, systemImage: "arrow.triangle.branch")
                        .font(.system(size: 18))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Self.accentPurple.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .padding(.bottom, 8)

            // Changed files
            Text("Changed Files")
                .font(.system(size: 18, weight: .semibold))

            if files.isEmpty {
                Text("Working tree clean")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                List(files) { file in
                    HStack(spacing: 12) {
                        Image(systemName: file.status.icon)
                            .foregroundStyle(colorForStatus(file.status))
                            .font(.system(size: 18))

                        Text(file.status.rawValue)
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundStyle(colorForStatus(file.status))
                            .frame(width: 24)

                        Text(file.path)
                            .font(.system(size: 18, design: .monospaced))
                    }
                }
                .listStyle(.inset)
            }

            Divider()

            // Commit area
            Text("Commit Message")
                .font(.system(size: 18, weight: .semibold))

            TextEditor(text: $commitMessage)
                .font(.system(size: 18))
                .frame(height: 80)
                .border(Color.gray.opacity(0.3))
                .scrollContentBackground(.hidden)

            // Buttons
            HStack(spacing: 16) {
                Button(action: performCommit) {
                    Label("Commit", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 18))
                }
                .buttonStyle(.borderedProminent)
                .tint(Self.accentPurple)
                .disabled(commitMessage.isEmpty || files.isEmpty)

                Button(action: performPush) {
                    Label("Push", systemImage: "arrow.up.circle.fill")
                        .font(.system(size: 18))
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button(action: performPull) {
                    Label("Pull", systemImage: "arrow.down.circle.fill")
                        .font(.system(size: 18))
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)

                Spacer()

                Button(action: refresh) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .font(.system(size: 18))
                }
            }

            if let statusMessage {
                Text(statusMessage)
                    .font(.system(size: 18))
                    .foregroundStyle(statusMessage.contains("Error") ? .red : .green)
                    .padding(.top, 4)
            }

            Spacer()
        }
        .padding(24)
        .onAppear { refresh() }
    }

    private func colorForStatus(_ status: FileStatus.Status) -> Color {
        switch status {
        case .modified: return .orange
        case .added: return .green
        case .deleted: return .red
        case .untracked: return .gray
        case .renamed: return .blue
        case .unknown: return .secondary
        }
    }

    private func refresh() {
        guard !repoPath.isEmpty else { return }
        do {
            branch = try gitService.currentBranch(at: repoPath)
            files = try gitService.status(at: repoPath)
        } catch {
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }

    private func performCommit() {
        guard !repoPath.isEmpty else { return }
        do {
            let filePaths = files.map(\.path)
            try gitService.commit(message: commitMessage, files: filePaths, at: repoPath)
            commitMessage = ""
            statusMessage = "Committed successfully"
            refresh()
        } catch {
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }

    private func performPush() {
        guard !repoPath.isEmpty else { return }
        do {
            _ = try gitService.push(at: repoPath)
            statusMessage = "Pushed successfully"
        } catch {
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }

    private func performPull() {
        guard !repoPath.isEmpty else { return }
        do {
            _ = try gitService.pull(at: repoPath)
            statusMessage = "Pulled successfully"
            refresh()
        } catch {
            statusMessage = "Error: \(error.localizedDescription)"
        }
    }
}
