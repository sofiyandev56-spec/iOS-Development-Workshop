# iOS Development Workshop

My work from a **2-day iOS Development workshop** led by **Apple Authorised Mentors** at our college's **Apple Authorised Training Center for Education**.

During the workshop I learned the basics of the **Swift** programming language and used **SwiftUI** in **Xcode** to build the two apps in this repo.

## What I learned

**Swift basics**
- Constants, variables and data types
- Operators
- Control statements (`if` / `else`)
- Loops
- Functions
- Structures

**SwiftUI and iOS**
- Getting around Xcode and using Previews
- Building screens with `VStack`, `HStack` and `ZStack`
- Text, images, buttons, text fields and gradients
- `@State` to make screens update when data changes
- Navigation between pages with `NavigationStack`, `NavigationLink` and `navigationDestination`
- Lists, sections and alerts
- Simple animations

## Projects

### 1. First app
My first SwiftUI app: a "Welcome To The Jungle" title screen with gradient text and Play / Exit buttons.

📁 [`First app`](First%20app)

### 2. Programmer corner
A learning app for programmers, designed with Apple's **Liquid Glass** (iOS 26+). It runs on iOS 27.

- **Login:** animated colours with floating topic logos, Liquid Glass text fields, a shake animation and haptics on a wrong password, and a one-tap **Use Demo Account** button (`test@example.com` / `password123`).
- **Learn tab:** a "Continue learning" card, your XP and level, and a grid of 8 topics that **zoom** open into their pages.
- **52 lessons:** each has a short explanation and a code sample with Xcode-style colours and a copy button. **Mark as Complete** earns XP.
- **Arcade tab:** all 8 mini games in one place, with saved best scores.
- **Profile tab:** level progress, stats, 8 badges to unlock, reset progress and sign out.
- **Search tab:** find any lesson by title, topic or code.
- **Built in:** Liquid Glass tab bar that shrinks while you scroll, Dark Mode, VoiceOver labels, Reduce Motion support, and progress saved on the device.

| Topic | Mini game |
|------|-------------|
| Swift | **Type Detective**: guess the type Swift gives each value |
| Python | **Guess the Output**: read a line of Python and pick what it prints |
| C++ | **Find the Bug**: tap the line of code that has the mistake |
| AntiGravity | **Defy Gravity**: switch gravity off and watch the logo float |
| Apple | **Catch the Apple**: tap the apple as many times as you can in 20 seconds |
| Claude | **Prompt Deck**: swipeable prompt cards you can copy into Claude |
| F1 | **Lights Out**: a real reaction-time test, measured in milliseconds, like an F1 race start |
| Spotify | **Coding Playlist**: a mini music player with made-up coding songs |

**How the code is organised** (`Programmer corner/Programmer corner/`):

| Folder | What's inside |
|------|-------------|
| `Models` | Topics, lessons, games, and `ProgressStore`, which saves XP and scores |
| `Design` | Colours, backgrounds, the code block and other reusable pieces |
| `Views` | Login, tabs, home (`homePage`), topic, lesson, Arcade, Profile and Search screens |
| `Games` | One file per mini game |

📁 [`Programmer corner`](Programmer%20corner)

## How to run

1. Install **Xcode** on a Mac.
2. Open `Programmer corner/Programmer corner.xcodeproj` (or `First app/First app.xcodeproj`).
3. Pick an iPhone simulator and press **Run** (⌘R).

## Note

Company names and logos used in the app belong to their owners. They are only used here for learning.
