// ============================================================
// Git Portfol.io — Developer Notes
// ============================================================
//
// Product Name:        Git Portfol.io
// Developer:           Michael Lee Fluharty
// Engineered with:     Claude by Anthropic
// License:             GPL v3
// Created:             2026-04-02
// Bundle ID:           com.nightgard.Git-Portfol-io
// Platform:            macOS 14+
// Distribution:        Self-distribution (personal use)
// GitHub:              fluhartyml/Git-Portfol.io
// Wiki:                https://github.com/fluhartyml/Git-Portfol.io/wiki
//
// ============================================================
// MARK: - What This App Is
// ============================================================
//
// A CMS (Content Management System) for GitHub Pages portfolios.
// No Claude, no terminal, no HTML knowledge needed.
// The user opens the app, fills in forms, manages projects and
// blog posts, and the app generates and pushes the HTML.
//
// Two user types:
//   1. Power user — existing portfolio, edit pages, manage blog, push updates
//   2. New user — starts from template, fills in info, app generates everything
//
// Template: fluhartyml/fluhartyml.github.io (Michael's portfolio)
//   stripped of personal info, offered as a starter to customize.
//
// ============================================================
// MARK: - App Store Connect
// ============================================================
//
// ** Claude: Update this section as information becomes available.
// ** Keep current with every submission. This is the source of truth.
//
// App Name:            Git Portfol.io
// App Apple ID:        (self-distribution, no App Store)
// Bundle ID:           com.nightgard.Git-Portfol-io
// Category:            Developer Tools
// Current Version:     1.0 (pre-release)
// Status:              In development
//
// ============================================================
// MARK: - Versioned Roadmap
// ============================================================
//
// v1.0 — Personal CMS (Michael's Portfolio)
// ------------------------------------------
// Built for an existing portfolio repo. The app replaces Claude
// as the CMS for managing fluhartyml.github.io.
//
// Portfolio Restructure (first run — normalize the monolith):
//   1.1  Extract inline <style> blocks into shared CSS files
//        css/base.css   — background, fonts, nav, footer, cards
//        css/blog.css   — blog post previews, articles
//        css/projects.css — project page styles
//   1.2  Replace inline styles with <link rel="stylesheet"> in all pages
//   1.3  Extract shared JS to js/main.js (back-to-top, etc.)
//   1.4  Centralize all images into photos/ folder
//   1.5  Update all image references across pages to point to photos/
//   1.6  Relative paths handled by depth (../, ../../)
//   1.7  Theme changes in one CSS file affect entire site
//
// Onboarding (minimal — power user):
//   1.8  Welcome screen — hero icon, app name, tagline
//   1.9  Select existing local repo folder (macOS file picker)
//   1.10 Validates it's a git repo with a remote
//   1.11 GitHub sign-in — Personal Access Token, stored in Keychain
//   1.12 Confirm connection — repo name, branch, remote, last commit
//
// App Aesthetics (matches portfolio theme):
//   1.13 Dark mode — matches blog's rgba(0,0,0,0.7) overlays
//   1.14 Purple/indigo accent #667eea throughout app
//   1.15 Apple system font (SwiftUI default)
//   1.16 Sidebar and content areas styled like portfolio cards (12px radius)
//   1.17 Purple highlights on selected items, buttons, active states
//   1.18 The app should feel like the portfolio — editing feels on-site
//
// Profile Editor (form-based, edits css/base.css + index.html):
//   1.19 Name, bio, tagline, email
//   1.20 Background image picker (saves to photos/)
//   1.21 Favicon picker
//   1.22 Social links (GitHub, X, LinkedIn — extensible)
//   1.23 Tawk.to chat widget ID (optional)
//   1.24 CNAME / custom domain
//   1.25 Accent color picker — updates css/base.css, affects whole site
//
// Project Manager:
//   1.26 Project sections — user-defined, not hardcoded:
//        App Store Apps, Self Distribution, Under Development,
//        iOS/macOS Applications, Web Projects, Archived, or custom
//   1.27 Add/remove/rename/reorder sections
//   1.28 List all projects with status badges, grouped by section
//   1.29 Add/edit/remove/reorder project cards
//   1.30 Move projects between sections (drag or dropdown)
//   1.31 Project card fields:
//        - Title
//        - Status badges — multi-select chips (Live on App Store,
//          Active Development, Swift Package, Shelved, MVP Complete,
//          Archived, BBS-Inspired, or custom)
//        - Platform badges — multi-select (iOS, iPadOS, macOS, tvOS,
//          visionOS, Web, Swift Package, GPL v3, or custom)
//        - Description paragraph
//        - Features paragraph
//        - Rating/stats line (optional — "⭐⭐⭐⭐⭐ 5.0 rating")
//        - Status note (optional — "Shelved Nov 8, 2025 - reason")
//   1.32 Links per project — each optional, add as many as needed:
//        Learn More (auto-generates detail page)
//        App Store URL, Demo URL, GitHub URL, Wiki URL,
//        Visit Site URL, Custom link (label + URL)
//   1.33 Icon/screenshot picker (from photos/)
//   1.34 Project grouping — collapse related projects into one card
//        with "View All" link (e.g. Scanner Apps, Inkwell Projects)
//   1.35 Ecosystem badge — links to an ecosystem overview URL
//   1.36 "View All Repositories" footer link — configurable GitHub profile URL
//   1.37 Generates project detail pages referencing css/projects.css
//   1.38 Generates projects.html listing with all sections and cards
//
// Demo Builder (ImageReady/HyperCard-style):
//   1.39 Take screenshots or import from photos/
//   1.40 Draw hotspot rectangles on the image
//   1.41 Assign each hotspot a link to another screenshot/page
//   1.42 Image slicing — auto-splits image into HTML regions
//   1.43 Uses standard HTML image maps (<map>, <area>, <usemap>)
//   1.44 Export as static HTML demo page in demos/
//   1.45 Preview the interactive demo in WebView before saving
//   1.46 Link from project card's "Try Demo" button
//
// Blog Manager:
//   1.32 List all blog posts grouped by category
//   1.33 4 default categories: Announcements, Support, Claude Sessions, Personal
//   1.34 Add/edit/remove blog posts
//   1.35 Post form: title, date, category, hero image (from photos/), body
//   1.36 Rich text or markdown editor for post content
//   1.37 Generates post HTML in posts/[category]/[slug].html
//   1.38 Auto-updates category listing page (blog-[category].html) with preview card
//   1.39 Relative paths auto-calculated by folder depth
//   1.40 Blog hub card management:
//        Add/remove/rename/reorder category cards on blog.html
//        Edit card title and description
//        Creating a category auto-creates: posts/[category]/ folder,
//        blog-[category].html listing page, and card on blog.html
//        Deleting a category removes the card, listing page, and folder
//   1.41 Edit existing posts — parses HTML back into form fields
//   1.42 Delete posts — removes file + removes preview from listing page
//   1.43 Embed button — paste embed code from any provider:
//        YouTube, Amazon, Spotify, social media, iframes, etc.
//        App wraps in responsive container, drops into post body
//   1.44 Embed preview in editor — shows the embedded content inline
//
// File Browser:
//   1.43 Browse repo files in sidebar
//   1.44 Open any file for code editing
//   1.45 Syntax highlighting for HTML/CSS/JS/Markdown
//
// Live Preview:
//   1.46 WebView preview of any page
//   1.47 Auto-refresh on save
//
// Git Operations:
//   1.48 Status — show modified, added, deleted files
//   1.49 Diff — show changes before commit
//   1.50 Commit — message field, commit selected files
//   1.51 Push — push to remote
//   1.52 Pull — pull from remote
//   1.53 Branch display (read-only for v1.0)
//
// Photo Manager:
//   1.54 Single flat photos/ folder — no subfolders (prevents 404 depth issues)
//   1.55 Naming convention: Page.Context.UUID.ext
//        e.g. profile.background.a3f2.jpg
//             blog.my-first-post.hero.d4e5.jpg
//             projects.cryotunes.screenshot1.h8i9.png
//             credentials.diploma.f6g7.jpg
//             personal.beach-sunset.p6q7.jpg
//   1.56 Filename IS the metadata — app filters by prefix per editor
//        Editing credentials? Show credentials.* photos
//        Writing a blog post? Show blog.* photos
//   1.57 PhotosPicker — user selects photos from Apple Photos
//   1.58 App auto-names with Page.Context.UUID convention on import
//   1.59 Sync button — commits and pushes photos to GitHub
//   1.60 Sync a local Mac folder to the repo (drag-drop or folder picker)
//   1.61 Photos available on GitHub Pages site
//   1.62 Blog/project editors pick from filtered photos/ — relative path auto-generated
//   1.63 One path depth from any page: photos/filename.ext
//
// Credentials Editor:
//   1.66 Sections: Education, Military Service, Professional Experience,
//        Developer Credentials, Canine Training (or any custom section)
//   1.67 Add/edit/remove/reorder credential sections
//   1.68 Add/edit/remove/reorder cards within a section
//   1.69 Flexible key/value fields per card — user adds whatever they need
//        (Degree:, Company:, Rating:, Period:, Status:, etc.)
//   1.70 Description/details text per card
//   1.71 Image picker for diplomas/certificates (from photos/)
//   1.72 Clickable images (open full-size in new tab)
//   1.73 External links per credential (e.g. GitHub archive link)
//   1.74 Generates credentials.html referencing css/base.css
//
// Card Customization (applies to credentials, projects, blog, any card):
//   1.75 Background color picker (default: dark overlay)
//   1.76 Background opacity slider
//   1.77 Border color/style picker
//   1.78 Corner radius slider
//   1.79 Card width (full, half, third)
//   1.80 Text color per card
//   1.81 Padding adjustment
//   1.82 Drag to reorder cards
//
// Photo Effects (non-destructive — original preserved, effected version generated):
//   1.83 Resize — width/height with aspect ratio lock
//   1.84 Crop
//   1.85 Color overlay/tint
//   1.86 Opacity slider
//   1.87 Border — color, width, radius
//   1.88 Shadow — color, blur, offset
//   1.89 CSS filters: blur, brightness, contrast, grayscale, sepia, saturate, hue-rotate
//   1.90 Core Image filters for advanced effects
//   1.91 Preview before/after
//   1.92 Click-to-zoom toggle (generates onclick="window.open()" on the image)
//
// Contact Editor:
//   1.72 Heading ("Get In Touch")
//   1.73 Description text
//   1.74 Response time text
//   1.75 App support guidance text
//   1.76 Email address (generates mailto: link + styled button)
//   1.77 Contacts framework integration — pull "Me" card from macOS Contacts
//   1.78 Toggle which fields to show (name, email, phone, photo, address, social, company)
//   1.79 Renders as vCard-style visual card matching portfolio theme
//   1.80 Generates downloadable .vcf (vCard) file in the repo
//   1.81 "Add to Contacts" button on contact page — visitor downloads .vcf
//   1.82 Re-sync from Contacts app when info changes
//   1.83 Generates contact.html referencing css/base.css
//
// Site Settings (shared includes):
//   1.78 Header Settings (_header.html):
//        - Initials/logo text ("MLF")
//        - Logo style/color
//   1.79 Footer Settings (_footer.html):
//        - Social links — add/remove/reorder (platform name + URL)
//        - Monogram/logo text or custom SVG
//        - Copyright name
//        - Copyright year (manual or auto from system date)
//        - Back to Top button — on/off
//        - Custom footer links
//   1.80 Per-Page Widget Toggles:
//        - Live chat (Tawk.to, Crisp, Intercom, or paste embed code)
//          on/off per page + provider ID
//        - Comments (Disqus, Giscus/GitHub, or paste embed code)
//          on/off per page + provider ID
//        - e.g. Contact page: live chat ON, comments OFF
//                Blog posts: live chat OFF, comments ON
//                Projects: both OFF
//   1.81 Nav Settings (_nav.html):
//        - Page list — add/remove/rename/reorder pages
//        - Grid auto-adjusts to page count
//        - Each entry: label + target HTML file
//   1.81 CNAME / custom domain editor
//
// Page Manager:
//   1.82 Add new pages to the site (e.g. Resume, Gallery, Services)
//   1.83 Creates HTML from base template (links css/base.css, includes header/nav/footer)
//   1.84 Auto-adds to _nav.html
//   1.85 Opens editor for content
//   1.86 Delete page — removes file + nav link
//   1.87 Rename page — updates filename + nav label + all internal links
//
// Home Page Editor:
//   1.88 Full name
//   1.89 Title/tagline ("AppleOS Developer")
//   1.90 Bio paragraph 1 (work history)
//   1.91 Bio paragraph 2 (motto)
//   1.92 Background image (from photos/)
//   1.93 Generates index.html referencing css/base.css
//
// v1.1 — New User Onboarding & Template
// --------------------------------------
// Opens the app to anyone. Step-by-step guide from zero to live site.
//
// Onboarding (new user):
//   2.1  Step-by-step: Create a GitHub account (links + instructions)
//   2.2  Step-by-step: Create username.github.io repo
//   2.3  Step-by-step: Enable GitHub Pages in repo Settings
//   2.4  Clone template (fluhartyml.github.io stripped of personal info)
//   2.5  Guided form: fill in name, bio, email, social links
//   2.6  App generates all HTML from template + user input
//   2.7  First push — site goes live
//   2.8  OAuth sign-in option (in addition to PAT)
//
// Template system:
//   2.9  Template repo with placeholder variables
//   2.10 Variable substitution engine ({{name}}, {{bio}}, etc.)
//   2.11 Preview before first push
//   2.12 "Start Over" option to re-run onboarding
//
// Polish:
//   2.13 Undo/redo in editors
//   2.14 Search across all files
//   2.15 Git log viewer (commit history)
//   2.16 Diff viewer (side by side)
//   2.17 Theme customization (colors, fonts)
//
// v1.2 — Advanced
// ----------------
//   3.1  Custom page templates (user-defined)
//   3.2  Demo page builder (interactive previews)
//   3.3  SEO metadata editor
//   3.4  Analytics integration
//   3.5  Bulk image optimization (sips compression)
//   3.6  Export site as ZIP
//   3.7  Multiple repo support
//   3.8  Drag-and-drop file reordering
//
// ============================================================
// MARK: - Template Structure (from fluhartyml.github.io)
// ============================================================
//
// Includes:
//   _includes/_header.html   — "MLF" logo → user's initials
//   _includes/_nav.html      — 2x3 grid nav (Home, Credentials, Projects, Blog, Contact)
//   _includes/_footer.html   — social links, copyright, Tawk.to chat
//
// Pages:
//   index.html               — hero with name, bio, tagline
//   projects.html            — project grid
//   blog.html                — blog hub with 4 categories
//   contact.html             — email contact card
//   credentials.html         — education, experience, certs
//   CNAME                    — custom domain
//
// Projects: projects/*.html  — one page per project
// Posts: posts/*/*.html      — organized by category subfolder
// Demos: demos/*.html        — interactive demo pages
//
// All styling is inline <style> blocks per page.
// No external CSS. No build system. Plain HTML + Liquid includes.
//
// ============================================================
// MARK: - Design Notes
// ============================================================
//
// macOS native SwiftUI app.
// Sidebar navigation: Profile, Projects, Blog, Credentials, Files, Git
// Main content area: form editor or code editor depending on context
// Inspector panel: live preview (WebView)
// 18pt minimum font.
// Dark mode by default (matches Xcode aesthetic).
//
// Git operations use Process() to call git CLI — no libgit2 dependency.
// GitHub auth via Personal Access Token stored in Keychain.
// OAuth is v1.1+ if needed.
//

import Foundation
