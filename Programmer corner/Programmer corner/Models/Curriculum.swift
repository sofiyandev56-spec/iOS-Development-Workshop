//
//  Curriculum.swift
//  Programmer corner
//
//  Created by Developer Sofiyan on 30/10/26.
//

import Foundation

/// Every unit and lesson in the app, grouped by topic.
enum Curriculum {
    static func units(for topic: Topic) -> [CourseUnit] {
        all[topic] ?? []
    }

    static let allLessons: [Lesson] = Topic.allCases.flatMap(\.lessons)

    private static let all: [Topic: [CourseUnit]] = [
        .swift: swift,
        .antigravity: antigravity,
        .claude: claude,
        .python: python,
        .cpp: cpp,
        .apple: apple,
        .f1: f1,
        .spotify: spotify
    ]

    // MARK: - Swift (from the workshop)

    private static let swift: [CourseUnit] = [
        CourseUnit(number: 1, title: "Introduction to Swift", lessons: [
            Lesson(.swift, "1.1", "History of Swift", minutes: 2,
                   summary: "Apple introduced Swift at WWDC in 2014 as a modern, safe and fast replacement for Objective-C. It became open source in 2015 and now powers apps on iPhone, iPad, Mac, Apple Watch, Apple TV and Apple Vision Pro.",
                   code: #"""
                   print("Hello, Swift!")
                   """#),
            Lesson(.swift, "1.2", "Constants, Variables and Data Types", minutes: 4,
                   summary: "Use let for values that never change and var for values that do. Swift works out the type for you: 20 is an Int, 3.14 is a Double, \"Hi\" is a String and true is a Bool.",
                   code: #"""
                   let name = "King"      // String
                   var age = 20           // Int
                   let pi = 3.14          // Double
                   var isLearning = true  // Bool
                   """#),
            Lesson(.swift, "1.3", "Operators and Control Flow", minutes: 4,
                   summary: "Operators do maths (+ - * /) and compare values (== != > <). Control statements like if, else and switch let your code make decisions.",
                   code: #"""
                   let score = 85

                   if score >= 80 {
                       print("Great job!")
                   } else {
                       print("Keep practising")
                   }
                   """#),
            Lesson(.swift, "1.4", "Functions", minutes: 4,
                   summary: "A function is a named block of code you can run again and again. It can take inputs, called parameters, and give back a result.",
                   code: #"""
                   func greet(name: String) -> String {
                       return "Hello, \(name)!"
                   }

                   print(greet(name: "King"))
                   """#),
            Lesson(.swift, "1.5", "Loops", minutes: 3,
                   summary: "Loops repeat code. A for-in loop walks through a range or a list, and a while loop keeps going until its condition becomes false.",
                   code: #"""
                   for lap in 1...5 {
                       print("Lap \(lap)")
                   }
                   """#),
            Lesson(.swift, "1.6", "Structures", minutes: 4,
                   summary: "A struct groups related values and functions into your own type. Every SwiftUI screen you build is a struct that conforms to View.",
                   code: #"""
                   struct Student {
                       var name: String
                       var level: Int
                   }

                   let me = Student(name: "King", level: 1)
                   """#)
        ]),
        CourseUnit(number: 2, title: "iOS Development", lessons: [
            Lesson(.swift, "2.1", "Intro to Xcode", minutes: 3,
                   summary: "Xcode is Apple's app for building apps. You write Swift in the editor, see your screen update live in Previews, and run your app in the Simulator or on your iPhone."),
            Lesson(.swift, "2.2", "Interface Building", minutes: 4,
                   summary: "SwiftUI builds screens from small views like Text, Image and Button. You arrange them with stacks and style them with modifiers.",
                   code: #"""
                   VStack {
                       Image(systemName: "swift")
                       Text("Hello, SwiftUI")
                           .font(.title)
                   }
                   """#),
            Lesson(.swift, "2.3", "Navigation Control", minutes: 4,
                   summary: "A NavigationStack holds a stack of screens. NavigationLink pushes a new screen when tapped, and navigationDestination opens one when your data changes.",
                   code: #"""
                   NavigationStack {
                       NavigationLink("Open Swift") {
                           Text("Swift page")
                       }
                   }
                   """#),
            Lesson(.swift, "2.4", "Layout Containers", minutes: 4,
                   summary: "Stacks, grids, lists and scroll views decide where views go. Spacer, padding and frame fine-tune the space around them.",
                   code: #"""
                   LazyVGrid(columns: [GridItem(), GridItem()]) {
                       Text("Swift")
                       Text("Python")
                   }
                   """#)
        ])
    ]

    // MARK: - AntiGravity

    private static let antigravity: [CourseUnit] = [
        CourseUnit(number: 1, title: "Getting Started", lessons: [
            Lesson(.antigravity, "1.1", "What is AntiGravity?", minutes: 2,
                   summary: "AntiGravity is an AI-powered code editor built around agents. You describe a task, and an agent plans it, writes the code and tests it while you review the work."),
            Lesson(.antigravity, "1.2", "A Tour of the Editor", minutes: 3,
                   summary: "It looks like a classic code editor, with files, tabs and a terminal, plus a place where you chat with agents and keep track of what they are doing."),
            Lesson(.antigravity, "1.3", "Your First Project", minutes: 4,
                   summary: "Open a folder, ask an agent to build something small, then read every change it made before you keep it. Small tasks are easier to check.",
                   code: #"""
                   Create a SwiftUI screen with a title,
                   a text field for an email and a Sign In button.
                   Keep the code simple and add comments.
                   """#)
        ]),
        CourseUnit(number: 2, title: "Working with AI Agents", lessons: [
            Lesson(.antigravity, "2.1", "What is an AI Agent?", minutes: 3,
                   summary: "An agent is an AI that can take actions, not just answer questions. It can read files, run commands and check its own results."),
            Lesson(.antigravity, "2.2", "Giving Clear Tasks", minutes: 3,
                   summary: "Good tasks are small and specific: one feature, the files involved, and how you will know it is done.",
                   code: #"""
                   In LoginView.swift, show an error message
                   under the password field when sign-in fails.
                   Don't change any other screen.
                   """#),
            Lesson(.antigravity, "2.3", "Reviewing the Agent's Changes", minutes: 3,
                   summary: "Agents make mistakes too. Read the changes, run the app and test it yourself before you trust the result. You are still the developer.")
        ])
    ]

    // MARK: - Claude

    private static let claude: [CourseUnit] = [
        CourseUnit(number: 1, title: "Learning with Claude", lessons: [
            Lesson(.claude, "1.1", "What is Claude?", minutes: 2,
                   summary: "Claude is an AI assistant made by Anthropic. It can explain code, help you plan apps and find bugs, and it works best when you give it clear context."),
            Lesson(.claude, "1.2", "Writing a Good Prompt", minutes: 3,
                   summary: "Say what you are building, what you tried and what you want back. Specific prompts get specific answers.",
                   code: #"""
                   I'm building a SwiftUI login screen.
                   When I tap Login, nothing happens.
                   Here's my code: ...
                   Explain the bug before you fix it.
                   """#),
            Lesson(.claude, "1.3", "Ask for Explanations, Not Just Answers", minutes: 2,
                   summary: "Ask why, not just what. Understanding a fix is how you grow as a developer, and it helps you spot the same bug next time.")
        ]),
        CourseUnit(number: 2, title: "Building with Claude", lessons: [
            Lesson(.claude, "2.1", "Planning an App", minutes: 3,
                   summary: "Before coding, ask Claude to break your idea into screens, data and small steps. Then build one step at a time and test as you go."),
            Lesson(.claude, "2.2", "Claude Code", minutes: 3,
                   summary: "Claude Code is a coding agent that works inside your project. It can read files, run builds and make changes that you review."),
            Lesson(.claude, "2.3", "Checking AI Code Before Using It", minutes: 2,
                   summary: "Always read, run and test code from AI before you trust it. AI is your pair programmer, and you make the final call.")
        ])
    ]

    // MARK: - Python

    private static let python: [CourseUnit] = [
        CourseUnit(number: 1, title: "Python Basics", lessons: [
            Lesson(.python, "1.1", "What is Python?", minutes: 2,
                   summary: "Python is a popular language known for clean, readable code. It is used for websites, data science, AI and automation.",
                   code: #"""
                   print("Hello, Python!")
                   """#),
            Lesson(.python, "1.2", "Variables and Data Types", minutes: 3,
                   summary: "Python works out the type for you. Text is a str, whole numbers are int, decimals are float and True or False is a bool.",
                   code: #"""
                   name = "King"
                   age = 20
                   height = 5.9
                   is_learning = True
                   """#),
            Lesson(.python, "1.3", "Making Decisions", minutes: 3,
                   summary: "Python uses indentation, the spaces at the start of a line, instead of curly braces to group code under if and else.",
                   code: #"""
                   marks = 85

                   if marks >= 80:
                       print("Distinction")
                   else:
                       print("Keep going")
                   """#)
        ]),
        CourseUnit(number: 2, title: "Going Further", lessons: [
            Lesson(.python, "2.1", "Loops", minutes: 3,
                   summary: "A for loop repeats code for each item. range(1, 6) gives the numbers 1 to 5, because the end number is not included.",
                   code: #"""
                   for i in range(1, 6):
                       print(i)
                   """#),
            Lesson(.python, "2.2", "Lists and Dictionaries", minutes: 4,
                   summary: "A list keeps items in order. A dictionary stores pairs of keys and values, so you can look things up by name.",
                   code: #"""
                   languages = ["Swift", "Python", "C++"]
                   ages = {"King": 20, "Ada": 36}

                   print(languages[0])  # Swift
                   print(ages["King"])  # 20
                   """#),
            Lesson(.python, "2.3", "Functions", minutes: 3,
                   summary: "def creates a function. An f-string, with an f before the quotes, puts values right inside your text.",
                   code: #"""
                   def greet(name):
                       return f"Hello, {name}!"

                   print(greet("King"))
                   """#)
        ])
    ]

    // MARK: - C++

    private static let cpp: [CourseUnit] = [
        CourseUnit(number: 1, title: "Introduction to C++", lessons: [
            Lesson(.cpp, "1.1", "History of C++", minutes: 2,
                   summary: "Bjarne Stroustrup created C++ in the 1980s as \"C with Classes\". It is very fast, so it powers game engines, web browsers and operating systems.",
                   code: #"""
                   #include <iostream>
                   using namespace std;

                   int main() {
                       cout << "Hello, C++!";
                       return 0;
                   }
                   """#),
            Lesson(.cpp, "1.2", "Variables and Data Types", minutes: 3,
                   summary: "In C++ you write the type first, and every statement ends with a semicolon.",
                   code: #"""
                   int age = 20;
                   double pi = 3.14;
                   char grade = 'A';
                   string name = "King";
                   """#),
            Lesson(.cpp, "1.3", "Input and Output", minutes: 3,
                   summary: "cout prints to the screen, and cin reads what the user types.",
                   code: #"""
                   int age;
                   cout << "Enter your age: ";
                   cin >> age;
                   cout << "You are " << age;
                   """#)
        ]),
        CourseUnit(number: 2, title: "Going Deeper", lessons: [
            Lesson(.cpp, "2.1", "Conditions and Loops", minutes: 3,
                   summary: "for loops count with a starting value, a condition and a step. % gives the remainder, which is handy for checking even numbers.",
                   code: #"""
                   for (int i = 1; i <= 5; i++) {
                       if (i % 2 == 0) {
                           cout << i << " is even\n";
                       }
                   }
                   """#),
            Lesson(.cpp, "2.2", "Classes and Objects", minutes: 4,
                   summary: "A class is a blueprint, and an object is a thing built from that blueprint.",
                   code: #"""
                   class Car {
                   public:
                       string name;
                       void drive() {
                           cout << name << " is driving";
                       }
                   };
                   """#),
            Lesson(.cpp, "2.3", "Pointers and Memory", minutes: 4,
                   summary: "A pointer stores the memory address of another value. & gets the address, and * reads the value stored there.",
                   code: #"""
                   int score = 10;
                   int* p = &score;

                   cout << *p;  // 10
                   """#)
        ])
    ]

    // MARK: - Apple

    private static let apple: [CourseUnit] = [
        CourseUnit(number: 1, title: "Apple Platforms", lessons: [
            Lesson(.apple, "1.1", "The Apple Ecosystem", minutes: 2,
                   summary: "iPhone, iPad, Mac, Apple Watch, Apple TV and Apple Vision Pro work together. With Swift and SwiftUI, one codebase can reach all of them."),
            Lesson(.apple, "1.2", "iOS and iPadOS", minutes: 3,
                   summary: "iOS runs on iPhone and iPadOS runs on iPad. SwiftUI adapts your layout to each screen, from a small iPhone to a large iPad."),
            Lesson(.apple, "1.3", "Liquid Glass", minutes: 3,
                   summary: "Liquid Glass is Apple's design material. It blurs and reflects the content behind it and reacts to your touch. This app uses it for buttons, cards and the tab bar.",
                   code: #"""
                   Text("Hello")
                       .padding()
                       .glassEffect()
                   """#)
        ]),
        CourseUnit(number: 2, title: "Developer Tools", lessons: [
            Lesson(.apple, "2.1", "Xcode and Previews", minutes: 3,
                   summary: "Xcode is where you write, design, test and debug apps. #Preview shows your SwiftUI view live while you type.",
                   code: #"""
                   #Preview {
                       ContentView()
                   }
                   """#),
            Lesson(.apple, "2.2", "SF Symbols", minutes: 2,
                   summary: "SF Symbols is a library of thousands of icons that match Apple's San Francisco font. Use them with Image(systemName:).",
                   code: #"""
                   Image(systemName: "star.fill")
                       .foregroundStyle(.yellow)
                   """#),
            Lesson(.apple, "2.3", "TestFlight and the App Store", minutes: 3,
                   summary: "TestFlight lets friends test your app before launch. When it is ready, you submit it through App Store Connect for Apple's review.")
        ])
    ]

    // MARK: - F1

    private static let f1: [CourseUnit] = [
        CourseUnit(number: 1, title: "Race Weekend = Building an App", lessons: [
            Lesson(.f1, "1.1", "Practice = Trying Ideas", minutes: 2,
                   summary: "In practice sessions, teams try different setups and learn the track. When building an app, you make quick prototypes to learn what works."),
            Lesson(.f1, "1.2", "Qualifying = Testing", minutes: 2,
                   summary: "Qualifying finds the fastest setup under pressure. Testing finds the bugs in your app before your users do."),
            Lesson(.f1, "1.3", "Race Day = Launch Day", minutes: 2,
                   summary: "On race day everything has to work together. Launch day is when your app goes live on the App Store.")
        ]),
        CourseUnit(number: 2, title: "The Tech Behind F1", lessons: [
            Lesson(.f1, "2.1", "Live Car Data", minutes: 3,
                   summary: "F1 cars carry hundreds of sensors. They stream data like speed, tyre temperature and fuel to the team's engineers in real time."),
            Lesson(.f1, "2.2", "Simulators and Strategy", minutes: 3,
                   summary: "Teams run thousands of simulations to plan pit stops, just like you test your app in the iOS Simulator before it ships."),
            Lesson(.f1, "2.3", "Build a Lap Timer in Swift", minutes: 4,
                   summary: "Date gives you the current time. Subtract one date from another to measure how long something took. The Lights Out game uses the same idea.",
                   code: #"""
                   let start = Date()
                   // ... drive a lap ...
                   let lap = Date().timeIntervalSince(start)
                   print(String(format: "%.3f s", lap))
                   """#)
        ])
    ]

    // MARK: - Spotify

    private static let spotify: [CourseUnit] = [
        CourseUnit(number: 1, title: "How Spotify Works", lessons: [
            Lesson(.spotify, "1.1", "How Music Streaming Works", minutes: 2,
                   summary: "Streaming sends a song in small pieces over the internet, so it starts playing before the whole file has downloaded."),
            Lesson(.spotify, "1.2", "How Spotify Picks Songs for You", minutes: 3,
                   summary: "Recommendations learn from what you play, skip and save, and from people with similar taste, to suggest music you might like."),
            Lesson(.spotify, "1.3", "The Tech Behind It", minutes: 2,
                   summary: "Big apps like Spotify are built by many teams using many languages, with servers in the cloud serving millions of listeners at once.")
        ]),
        CourseUnit(number: 2, title: "Build a Music Player", lessons: [
            Lesson(.spotify, "2.1", "Playing Audio in Swift", minutes: 3,
                   summary: "Apple's AVFoundation framework plays sound. AVAudioPlayer can play a song file that you add to your app.",
                   code: #"""
                   import AVFoundation

                   let url = Bundle.main.url(forResource: "song", withExtension: "mp3")!
                   let player = try AVAudioPlayer(contentsOf: url)
                   player.play()
                   """#),
            Lesson(.spotify, "2.2", "Play and Pause with @State", minutes: 3,
                   summary: "Store isPlaying in @State. When it changes, SwiftUI updates the button's icon for you automatically.",
                   code: #"""
                   @State private var isPlaying = false

                   Button {
                       isPlaying.toggle()
                   } label: {
                       Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                   }
                   """#),
            Lesson(.spotify, "2.3", "Lists of Songs", minutes: 3,
                   summary: "Put your songs in an array and use ForEach to show each one as a row.",
                   code: #"""
                   let songs = ["Lo-fi Beats", "Infinite Loop"]

                   ForEach(songs, id: \.self) { song in
                       Text(song)
                   }
                   """#)
        ])
    ]
}
