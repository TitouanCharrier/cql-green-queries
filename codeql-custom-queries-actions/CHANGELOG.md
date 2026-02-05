# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Created the initial directory structure for CodeQL Action queries.
- New query to detect `Hello World` in GitHub Actions workflows.

### Fixed
- Resolved `codeql: command not found` error in the CI pipeline by correctly mapping the tool cache path.

---

## [1.0.0] - 2026-02-05

### Added
- Initial release of the CodeQL Pack for GitHub Actions.
- Automated versioning script using GitHub Actions and `jq`.
- Support for publishing to GitHub Packages (GHCR).

---

## 📘 How to Maintain this Changelog

This project uses **Conventional Commits** to ensure consistency and to automate the update process.

### 1. Mapping Commits to Sections
When you write a commit, it should determine where the information goes in this file:

| Commit Prefix | Changelog Section | Description |
| :--- | :--- | :--- |
| `feat:` | **Added** | For new features or new queries. |
| `fix:` | **Fixed** | For any bug fixes or CI path corrections. |
| `perf:` | **Changed** | For performance improvements in queries. |
| `refactor:` | **Changed** | For code changes that neither fix a bug nor add a feature. |
| `chore:` | **Internal** | Maintenance tasks (usually not visible in the public changelog). |
| `BREAKING CHANGE:` | **Removed / Changed** | Significant changes that require a major version bump. |

### 2. Versioning Rules (SemVer)
- **Major (1.0.0)**: Breaking changes (e.g., removing a query or changing its ID).
- **Minor (0.1.0)**: New features (e.g., adding a new `.ql` file).
- **Patch (0.0.1)**: Bug fixes (e.g., fixing a false positive in a query).

### 3. Workflow
1. **Develop**: Work on your branch.
2. **Commit**: Use a clear message: `feat: add query to detect insecure shell execution`.
3. **Update**: Before merging to `main`, add a line under the `[Unreleased]` section describing the change.
4. **Release**: When the GitHub Action triggers a "Publish", the `[Unreleased]` content is moved to a new version header with the current date.