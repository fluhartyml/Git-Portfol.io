//
//  FileBrowserView.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import SwiftUI
import SwiftData

struct FileNode: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let isDirectory: Bool
    var children: [FileNode]?
}

struct FileBrowserView: View {
    @Query private var repoSettings: [RepoSettings]
    @State private var rootNodes: [FileNode] = []
    @State private var selectedFile: String?
    @State private var fileContent: String = ""
    @State private var statusMessage: String?

    private static let accentPurple = Color(red: 0x66/255.0, green: 0x7E/255.0, blue: 0xEA/255.0)

    private var repoPath: String {
        repoSettings.first?.repoPath ?? ""
    }

    var body: some View {
        HSplitView {
            // File tree
            VStack(alignment: .leading) {
                Text("Files")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top, 12)

                List(rootNodes, children: \.children) { node in
                    Button(action: { selectFile(node) }) {
                        Label(
                            node.name,
                            systemImage: node.isDirectory ? "folder.fill" : fileIcon(for: node.name)
                        )
                        .font(.system(size: 18))
                        .foregroundStyle(
                            node.isDirectory ? Self.accentPurple : .primary
                        )
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.sidebar)
            }
            .frame(minWidth: 250, maxWidth: 350)

            // Editor
            VStack(alignment: .leading, spacing: 8) {
                if let selectedFile {
                    HStack {
                        Text(selectedFile)
                            .font(.system(size: 18, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)

                        Spacer()

                        Button("Save") {
                            saveFile()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Self.accentPurple)
                        .font(.system(size: 18))
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    TextEditor(text: $fileContent)
                        .font(.system(size: 18, design: .monospaced))
                        .scrollContentBackground(.hidden)
                        .padding(4)
                } else {
                    VStack {
                        Spacer()
                        Text("Select a file to edit")
                            .font(.system(size: 18))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }

                if let statusMessage {
                    Text(statusMessage)
                        .font(.system(size: 18))
                        .foregroundStyle(statusMessage.contains("Error") ? .red : .green)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
        }
        .onAppear { loadFileTree() }
    }

    private func fileIcon(for name: String) -> String {
        let ext = (name as NSString).pathExtension.lowercased()
        switch ext {
        case "html", "htm": return "globe"
        case "css": return "paintbrush.fill"
        case "js": return "curlybraces"
        case "json": return "doc.text"
        case "md", "markdown": return "text.document"
        case "png", "jpg", "jpeg", "gif", "svg": return "photo"
        case "yml", "yaml": return "list.bullet"
        default: return "doc.text.fill"
        }
    }

    private func loadFileTree() {
        guard !repoPath.isEmpty else { return }
        let url = URL(fileURLWithPath: repoPath)
        rootNodes = buildTree(at: url)
    }

    private func buildTree(at url: URL) -> [FileNode] {
        let fm = FileManager.default
        guard let contents = try? fm.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        return contents.sorted { $0.lastPathComponent < $1.lastPathComponent }.compactMap { itemURL in
            let isDir = (try? itemURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
            if isDir {
                let children = buildTree(at: itemURL)
                return FileNode(name: itemURL.lastPathComponent, path: itemURL.path, isDirectory: true, children: children)
            } else {
                return FileNode(name: itemURL.lastPathComponent, path: itemURL.path, isDirectory: false, children: nil)
            }
        }
    }

    private func selectFile(_ node: FileNode) {
        guard !node.isDirectory else { return }
        selectedFile = node.path
        do {
            fileContent = try String(contentsOfFile: node.path, encoding: .utf8)
        } catch {
            fileContent = ""
            statusMessage = "Error reading file: \(error.localizedDescription)"
        }
    }

    private func saveFile() {
        guard let path = selectedFile else { return }
        do {
            try fileContent.write(toFile: path, atomically: true, encoding: .utf8)
            statusMessage = "Saved"
        } catch {
            statusMessage = "Error saving: \(error.localizedDescription)"
        }
    }
}
