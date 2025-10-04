# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS todo application with the following key features:
- Task management with subtasks
- Tag-based filtering and organization
- Historical list tracking (Library feature)
- AI-powered suggestions using Google's Gemini API
- Dark mode support

## Architecture

### Core Data Models
- **TodoTask** (`todo_app/Task/Task.swift`): Main task entity with subtasks and tag relationships
- **Tag** (`todo_app/Tag/Tag.swift`): Categorization system with active/inactive states
- **SubTask** (`todo_app/Task/SubTask.swift`): Nested tasks within main tasks
- **TaskManager** (`TaskManager.swift`): Legacy model, being phased out

### State Management
- **ListManager** (`todo_app/List/ListManager.swift`): Central state manager handling all task operations, tag filtering, and data persistence
- **ListLibrary** (`todo_app/List/ListLibrary.swift`): Manages historical task lists and generates AI prompts from user data

### Data Persistence
All data is stored as JSON files in the app's Documents directory:
- `List.json`: Current active tasks
- `Tags.json`: All tags and their states
- `TaskMap.json` & `TagMap.json`: UUID-based lookup maps
- `ListLibrary.json`: File references to historical lists
- `List_YYYYMMDD_HHMMSS.json`: Archived task lists

### Folder Structure
```
todo_app/
├── Task/           # Task-related models and views
├── Tag/            # Tag system components
├── List/           # List management and library
├── ChatBot/        # Gemini AI integration
└── Core files      # Main app, ContentView, etc.
```

## Development Commands

### Building and Running
```bash
# Open in Xcode
open todo_app.xcodeproj

# Build from command line
xcodebuild -project todo_app.xcodeproj -scheme todo_app -destination 'platform=iOS Simulator,name=iPhone 15' build

# Run tests
xcodebuild test -project todo_app.xcodeproj -scheme todo_app -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Key Implementation Details

### Environment Objects
The app uses two main environment objects passed down from `todo_appApp.swift`:
- `ListManager`: Handles all task and tag operations
- `ListLibrary`: Manages historical data and AI context

### Tag System
Tags have bidirectional relationships with tasks:
- Tasks store tag UUIDs in a `tags` array
- Tags store actual TodoTask references in a `tasks` array
- The `viewableList` in ListManager is filtered based on active tags

### AI Integration
The Gemini API integration requires:
- `GenerativeAI-Info.plist` file with API_KEY
- Internet connection for suggestions
- Historical task data for context generation

### Data Flow
1. User interactions update ListManager state
2. ListManager triggers save operations to JSON files
3. Tag filtering updates `viewableList` which drives UI
4. List operations (clear/rollover) archive to ListLibrary

## Important Notes

- The app uses `@Published` properties extensively for SwiftUI reactivity
- All models implement `Codable` for JSON persistence
- Task and Tag models implement `Hashable` for Set operations
- The legacy `TaskManager.swift` should not be used for new features