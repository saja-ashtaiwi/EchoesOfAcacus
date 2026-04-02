** Echoes Of Acacus **

An interactive educational experience built for the Apple Swift Student Challenge.

"Echoes Of Acacus" is an interactive, puzzle-based iPad app designed to teach users about the breathtaking rock art, unique geological formations, and rich cultural heritage of the Tadrart Acacus mountains in the Libyan Sahara. Guided by an animated character named Tariq, users explore ancient history through engaging drag-and-drop puzzles and immersive audio.

Features
* Interactive Puzzles: Engage with the history of the Sahara through custom drag-and-drop mechanics built to test spatial memory and historical facts.
* Immersive Soundscapes: A custom-built audio engine that seamlessly blends background desert ambience with responsive, overlapping sound effects for user interactions.
* Accessible Design: Features a clean, uncluttered interface with high-contrast text and forgiving touch targets, ensuring the educational journey is accessible to all users. 
* Graceful Degradation: The core gameplay relies entirely on visual cues, meaning the app remains fully functional and educational even if the device is muted or audio fails to play.

# Technologies & Frameworks
* SwiftUI: Used for the entire user interface, leveraging its declarative syntax to build responsive layouts and fluid drag-and-drop gesture recognizers.
* AVFoundation: Implemented a custom `AudioManager` class to handle complex, simultaneous audio streams (background music + sound effects) safely and efficiently.
* Swift Playgrounds: Packaged as a `.swiftpm` file, highly optimized to manage asset sizes and resource bundling under a strict 25MB limit.

# How to Run the App
Since this project was built as a Swift Playgrounds App package, it can be run on either a Mac or an iPad.

On Mac (Requires Xcode):**
1. Download or clone this repository.
2. Double-click the `Echoes Of Acacus.swiftpm` file to open it in Xcode.
3. Select an iPad simulator from the run destination menu at the top.
4. Hit the Play (▶) button (or press `Cmd + R`) to build and run.

On iPad (Requires Swift Playgrounds):
1. AirDrop or download the `Echoes Of Acacus.swiftpm` file to your iPad.
2. Open the **Swift Playgrounds** app.
3. Tap on the file to import it into your Playgrounds library.
4. Tap the project to open it, then hit the **Play** button at the top to run the app in full screen.

 Contact
Created by Saja Ashtaiwi
LinkedIn: https://www.linkedin.com/in/saja-ashtaiwi-ab2763321/
