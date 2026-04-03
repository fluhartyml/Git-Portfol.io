//
//  GitService.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import Foundation

struct FileStatus: Identifiable {
    let id = UUID()
    let path: String
    let status: Status

    enum Status: String {
        case modified = "M"
        case added = "A"
        case deleted = "D"
        case untracked = "?"
        case renamed = "R"
        case unknown = " "

        var icon: String {
            switch self {
            case .modified: return "pencil.circle.fill"
            case .added: return "plus.circle.fill"
            case .deleted: return "minus.circle.fill"
            case .untracked: return "questionmark.circle.fill"
            case .renamed: return "arrow.right.circle.fill"
            case .unknown: return "circle"
            }
        }
    }
}

final class GitService {

    // MARK: - Run git commands via Process

    private func run(_ arguments: [String], at repoPath: String) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = arguments
        process.currentDirectoryURL = URL(fileURLWithPath: repoPath)

        let pipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = pipe
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        if process.terminationStatus != 0 {
            let errorMessage = String(data: errorData, encoding: .utf8) ?? "Unknown git error"
            throw GitError.commandFailed(errorMessage.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    // MARK: - Public API

    func isGitRepo(at path: String) -> Bool {
        do {
            let result = try run(["rev-parse", "--is-inside-work-tree"], at: path)
            return result == "true"
        } catch {
            return false
        }
    }

    func status(at repoPath: String) throws -> [FileStatus] {
        let output = try run(["status", "--porcelain"], at: repoPath)
        guard !output.isEmpty else { return [] }

        return output.components(separatedBy: "\n").compactMap { line in
            guard line.count >= 4 else { return nil }
            let statusChar = String(line.prefix(2)).trimmingCharacters(in: .whitespaces)
            let filePath = String(line.dropFirst(3))

            let status: FileStatus.Status
            switch statusChar {
            case "M", "MM": status = .modified
            case "A": status = .added
            case "D": status = .deleted
            case "??": status = .untracked
            case "R": status = .renamed
            default: status = .unknown
            }

            return FileStatus(path: filePath, status: status)
        }
    }

    func diff(at repoPath: String) throws -> String {
        return try run(["diff"], at: repoPath)
    }

    func commit(message: String, files: [String], at repoPath: String) throws {
        // Stage specified files
        for file in files {
            _ = try run(["add", file], at: repoPath)
        }
        _ = try run(["commit", "-m", message], at: repoPath)
    }

    func push(at repoPath: String) throws -> String {
        return try run(["push"], at: repoPath)
    }

    func pull(at repoPath: String) throws -> String {
        return try run(["pull"], at: repoPath)
    }

    func log(count: Int = 20, at repoPath: String) throws -> String {
        return try run(["log", "--oneline", "-\(count)"], at: repoPath)
    }

    func currentBranch(at repoPath: String) throws -> String {
        return try run(["branch", "--show-current"], at: repoPath)
    }

    func remoteURL(at repoPath: String) throws -> String {
        return try run(["remote", "get-url", "origin"], at: repoPath)
    }

    func clone(url: String, to destinationPath: String) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["clone", url, destinationPath]

        let pipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = pipe
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let errorOutput = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if process.terminationStatus != 0 {
            throw GitError.commandFailed(errorOutput)
        }

        return output.isEmpty ? errorOutput : output
    }
}

enum GitError: LocalizedError {
    case commandFailed(String)

    var errorDescription: String? {
        switch self {
        case .commandFailed(let message):
            return message
        }
    }
}
