//
//  RepoSettings.swift
//  Git Portfol.io
//
//  Created by Michael Fluharty on 4/2/26.
//

import Foundation
import SwiftData

@Model
final class RepoSettings {
    var repoPath: String
    var repoName: String
    var remoteName: String
    var branchName: String
    var githubUsername: String

    init(
        repoPath: String,
        repoName: String = "",
        remoteName: String = "origin",
        branchName: String = "main",
        githubUsername: String = ""
    ) {
        self.repoPath = repoPath
        self.repoName = repoName
        self.remoteName = remoteName
        self.branchName = branchName
        self.githubUsername = githubUsername
    }
}
