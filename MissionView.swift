import SwiftUI
import AVFoundation

struct MissionView: View {
    @Binding var journalEntries: [JournalEntry]
    @Binding var showMission: Bool
    
    enum StoryState {
        case intro, commute, walk1, cave1, puzzleElephant, explainElephant, walk2, cave2, puzzleGiraffe, explainGiraffe, outro, timeMachine, finalLesson
    }
    
    @State private var currentState: StoryState = .intro
    @State private var walkProgress: CGFloat = 0.0
    @State private var mapProgress: CGFloat = 0.0
    
    // --- TARIQ'S DIALOGUE SYSTEM ---
    @State private var dialogue: [String] = [
        "Hey There! I am Tariq, a Libyan archaelogist with a Tuareg background.",
        "We are in year 2050. One of our most special places in Libya is under the threat of being buried under severe sandstorms.",
        "The Sahara has always been known for its harsh weather",
        "But with all the changes that are happening the weather and sandstorms are getting worse.",
        "I am determined to restore these ancient pieces and understand what happened to cause this massive climate change.",
        "Let's find those ancient carvings before they are lost forever!"
    ]
    @State private var dialogueIndex: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // BACKGROUND LAYER
                backgroundLayer
                    .frame(width: geo.size.width, height: geo.size.height)
                
                // MAIN CONTENT
                switch currentState {
                case .intro:
                    // NOW USES THE EXACT SAME LAYOUT AS THE CAVES
                    NarrativeLayout(
                        image: "tariq_again",
                        title: "Tariq",
                        text: dialogue[dialogueIndex],
                        button: dialogueIndex < dialogue.count - 1 ? "Next" : "Begin Journey",
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if dialogueIndex < dialogue.count - 1 {
                                    dialogueIndex += 1 // Go to next sentence
                                } else {
                                    currentState = .commute // Start the game!
                                }
                            }
                        }
                    )
                    .id(dialogueIndex) // Helps the text animate smoothly when changing
                    
                case .commute:
                    ZStack {
                        // THE CURVED, DASHED BROWN PATH
                        Path { path in
                            let startPoint = CGPoint(x: geo.size.width * 0.26, y: geo.size.height * 0.23)
                            let endPoint = CGPoint(x: geo.size.width * 0.12, y: geo.size.height * 0.62)
                            let controlPoint = CGPoint(x: geo.size.width * 0.05, y: geo.size.height * 0.45)
                            
                            path.move(to: startPoint)
                            path.addQuadCurve(to: endPoint, control: controlPoint)
                        }
                        .trim(from: 0, to: mapProgress)
                        .stroke(Color.brown, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [12, 8]))
                        
                        if mapProgress >= 1.0 {
                            VStack {
                                Spacer()
                                Button("Start Walking ->") { currentState = .walk1 }
                                    .font(.title3.bold())
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 80)
                            }
                        }
                    }
                    .onAppear { withAnimation(.linear(duration: 3.0)) { mapProgress = 1.0 } }
                    
                case .walk1:
                    WalkingGame(geo: geo, progress: $walkProgress) {
                        walkProgress = 0
                        currentState = .cave1
                    }
                    
                case .cave1:
                    NarrativeLayout(image: "tariq_again", title: "A Cave!", text: "I see fragmented rock art on the wall but it seems unclear to me now. Can you help me restore it?", button: "Examine Art", action: { currentState = .puzzleElephant })
                    
                case .puzzleElephant:
                    PuzzleGame(geo: geo, image: "elephant_rock_image", title: "Restore ") { currentState = .explainElephant }
                    
                case .explainElephant:
                    NarrativeLayout(image: "tariq_again", title: "An Elephant", text: "Incredible. This proves deep rivers once flowed here and the old people who lived here and Elephants were able to thrive here.", button: "Continue Walking", action: { saveEntry(animal: "Elephant"); currentState = .walk2 })
                    
                case .walk2:
                    WalkingGame(geo: geo, progress: $walkProgress) {
                        walkProgress = 0
                        currentState = .cave2
                    }
                    
                case .cave2:
                    NarrativeLayout(image: "tariq_again", title: "Another Cave", text: "I see more fragments are scattered here. Help me piece them together to see what they are.", button: "Examine Art", action: { currentState = .puzzleGiraffe })
                    
                case .puzzleGiraffe:
                    PuzzleGame(geo: geo, image: "giraffe_rock_image", title: "Restore ") { currentState = .explainGiraffe }
                    
                case .explainGiraffe:
                    NarrativeLayout(image: "tariq_again", title: "A Giraffe", text: "We all know Giraffes eat from tall trees. This desert was once a lush forest before climate change took over it.", button: "Save to Diary", action: { saveEntry(animal: "Giraffe"); currentState = .outro })
                    
                case .outro:
                    NarrativeLayout(image: "tariq_explaining", title: " Mystery Unveiled", text: "We found elephants and giraffes painted in the heart of the Sahara. The Green Sahara is no myth and this strongly proves that this vast desert now was a huge forest back in the days.", button: "How did this happen?", action: { currentState = .timeMachine })
                    
                case .timeMachine:
                    ClimateTransitionView(geo: geo) {
                        currentState = .finalLesson
                    }
                    
                case .finalLesson:
                    ZStack {
                        Image("climate_change_bg")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            VStack(alignment: .leading, spacing: 16) {
                                Text("A Better Future")
                                    .font(.title.bold())
                                    .foregroundColor(.primary)
                                
                                Text("While human activities have harmed the planet, we also have the power to heal it. By reducing pollution and adopting clean energy, we can protect our world for future generations.  ")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Button("End Journey") { showMission = false }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.green)
                                    .cornerRadius(12)
                            }
                            .padding(24)
                            .background(.regularMaterial)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            .frame(maxWidth: 600)
                            .padding(.bottom, 60)
                        }
                    }
                }
                
                // EXIT BUTTON
                VStack {
                    HStack {
                        Button(action: { showMission = false }) {
                            Image(systemName: "xmark.circle.fill").font(.system(size: 40)).foregroundStyle(.white, .gray.opacity(0.8))
                        }.padding(30)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    var backgroundLayer: some View {
        switch currentState {
        case .intro, .outro: Image("acacus_arch").resizable().scaledToFill()
        case .commute: Image("libya_map_dots").resizable().scaledToFill()
        case .walk1, .walk2: Image("new_desert_bg").resizable().scaledToFill()
        case .cave1, .explainElephant, .cave2, .explainGiraffe: Image("cave_entrance").resizable().scaledToFill()
        case .puzzleElephant, .puzzleGiraffe, .timeMachine, .finalLesson: Color.clear
        }
    }
    
    func saveEntry(animal: String) {
        let entry = JournalEntry(title: animal, description: "Evidence of the Green Sahara Era.", date: "2050", imageName: animal == "Elephant" ? "elephant_rock_image" : "giraffe_rock_image")
        journalEntries.append(entry)
    }
}

// ===========================================
// SUB-VIEWS
// ===========================================

struct NarrativeLayout: View {
    var image: String
    var title: String
    var text: String
    var button: String
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom, spacing: 20) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 600)
                    .layoutPriority(1)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(title).font(.title.bold()).foregroundColor(.primary)
                    Text(text).font(.title3).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                    Button(action: action) {
                        Text(button).font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 14).background(Color.blue).cornerRadius(12)
                    }.padding(.top, 8)
                }
                .padding(24).background(.regularMaterial).cornerRadius(20).shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5).frame(maxWidth: 500).padding(.bottom, 40)
            }
            .padding(.horizontal, 40)
        }
    }
}

struct WalkingGame: View {
    var geo: GeometryProxy
    @Binding var progress: CGFloat
    var onWin: () -> Void
    
    let waypoints: [CGPoint] = [
        CGPoint(x: 0.55, y: 0.90), CGPoint(x: 0.65, y: 0.75), CGPoint(x: 0.45, y: 0.55), CGPoint(x: 0.52, y: 0.40), CGPoint(x: 0.48, y: 0.28)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                Text("DRAG TO FOLLOW THE PATH ").font(.title2.bold()).foregroundColor(.white).padding().background(Color.black.opacity(0.6)).cornerRadius(10).padding(.top, 60)
                Spacer()
            }
            
            Path { path in
                path.move(to: CGPoint(x: waypoints[0].x * geo.size.width, y: waypoints[0].y * geo.size.height))
                for i in 1..<waypoints.count { path.addLine(to: CGPoint(x: waypoints[i].x * geo.size.width, y: waypoints[i].y * geo.size.height)) }
            }.stroke(Color.red.opacity(0.8), style: StrokeStyle(lineWidth: 5, dash: [15, 10]))
            
            let currentPos = getPosition(for: progress, in: geo.size)
            let currentScale = 1.0 - (0.85 * progress)
            
            UnevenRoundedRectangle(topLeadingRadius: 40, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 40)
                .fill(LinearGradient(colors: [.brown, .black.opacity(0.9)], startPoint: .top, endPoint: .bottom))
                .frame(width: 80, height: 100).shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                .position(x: waypoints.last!.x * geo.size.width, y: waypoints.last!.y * geo.size.height)
            
            Image("tariq_walking")
                .resizable().scaledToFit().frame(height: 550 * currentScale).position(currentPos)
                .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: progress)
        }
        .contentShape(Rectangle())
        .gesture(DragGesture()
                    .onChanged { value in
                        if AudioManager.shared.walkingPlayer?.isPlaying != true {
                            AudioManager.shared.startWalkingSound(filename: "sand_walk.mp3")
                        }
                        
                        let percent = 1.0 - (value.location.y / geo.size.height)
                        if percent > progress { progress = min(percent, 1.0) }
                        
                        if progress > 0.95 {
                            AudioManager.shared.stopWalkingSound()
                            onWin()
                        }
                    }
                    .onEnded { _ in
                        AudioManager.shared.stopWalkingSound()
                    }
                )
    }
    
    func getPosition(for progress: CGFloat, in size: CGSize) -> CGPoint {
        let segmentCount = CGFloat(waypoints.count - 1)
        let scaledProgress = progress * segmentCount
        let index = min(Int(scaledProgress), waypoints.count - 2)
        let segmentProgress = scaledProgress - CGFloat(index)
        let startPoint = waypoints[index]
        let endPoint = waypoints[index + 1]
        let x = startPoint.x + (endPoint.x - startPoint.x) * segmentProgress
        let y = startPoint.y + (endPoint.y - startPoint.y) * segmentProgress
        return CGPoint(x: x * size.width, y: y * size.height)
    }
}

struct PuzzleGame: View {
    var geo: GeometryProxy
    var image: String
    var title: String
    var onWin: () -> Void
    
    @State private var pieces: [Int] = [3, 0, 1, 2]
    @State private var selectedIndex: Int? = nil
    @State private var isSolved = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()
            VStack(spacing: 20) {
                Text(title).font(.largeTitle.bold()).foregroundColor(.yellow).padding(.top, 40)
                Spacer()
                let boardSize = geo.size.height * 0.7
                let pieceSize = boardSize / 2
                let columns = [GridItem(.fixed(pieceSize), spacing: 2), GridItem(.fixed(pieceSize), spacing: 2)]
                
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(pieces, id: \.self) { piece in
                        let currentIndex = pieces.firstIndex(of: piece)!
                        PieceView(image: image, correctIndex: piece, boardSize: boardSize, pieceSize: pieceSize)
                            .overlay(Rectangle().stroke(selectedIndex == currentIndex ? Color.yellow : Color.clear, lineWidth: 6))
                            .contentShape(Rectangle())
                            .onTapGesture { handleTap(at: currentIndex) }
                    }
                }
                .frame(width: boardSize, height: boardSize).background(Color.black).border(Color.white, width: 4).shadow(radius: 10)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: pieces)
                
                Spacer()
                if isSolved {
                    Button("Art Restored! Continue") { onWin() }.font(.title3.bold()).padding().background(Color.green).foregroundColor(.white).cornerRadius(12).padding(.bottom, 50)
                } else {
                    Text("Tap two pieces to swap them").font(.title3.bold()).foregroundColor(.white).padding(.bottom, 50)
                }
            }
        }
    }
    
    func handleTap(at index: Int) {
        guard !isSolved else { return }
        
        if let selected = selectedIndex {
            if selected != index {
                AudioManager.shared.playSFX(filename: "piece_drag.mp3")
                pieces.swapAt(selected, index)
                checkWin()
            }
            selectedIndex = nil
        } else {
            selectedIndex = index
        }
    }
    
    func checkWin() {
        if pieces == [0, 1, 2, 3] { withAnimation(.easeIn(duration: 0.5)) { isSolved = true } }
    }
}

struct PieceView: View {
    var image: String
    var correctIndex: Int
    var boardSize: CGFloat
    var pieceSize: CGFloat
    var body: some View {
        let correctCol = CGFloat(correctIndex % 2)
        let correctRow = CGFloat(correctIndex / 2)
        let offsetX = (0.5 - correctCol) * pieceSize
        let offsetY = (0.5 - correctRow) * pieceSize
        ZStack {
            Image(image).resizable().scaledToFill().frame(width: boardSize, height: boardSize).offset(x: offsetX, y: offsetY)
        }
        .frame(width: pieceSize, height: pieceSize).clipped().contentShape(Rectangle())
    }
}

struct ClimateTransitionView: View {
    var geo: GeometryProxy
    var onFinish: () -> Void
    @State private var timeFader: Double = 0.0
    
    var body: some View {
        ZStack {
            Image("new_desert_bg")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .ignoresSafeArea()
            
            Image("sahara_green")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .ignoresSafeArea()
                .opacity(1.0 - timeFader)
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom, spacing: 20) {
                    Image("tariq_explaining")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 600)
                        .layoutPriority(1)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(timeFader < 0.5 ? "The Green Sahara" : "The Human Impact")
                            .font(.title.bold())
                            .foregroundColor(.primary)
                        
                        Text(timeFader < 0.5 ?
                             "Thousands of years ago, natural climate cycles made this a lush environment before it slowly dried." :
                             "Today, human effects like extracting gas and oils, and heavy pollution, are accelerating climate change and natural disasters.")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .id(timeFader < 0.5 ? 1 : 2)
                            .transition(.opacity)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Drag to see the change:")
                                .font(.subheadline.bold())
                                .foregroundColor(.secondary)
                            Slider(value: $timeFader, in: 0...1)
                                .accentColor(timeFader < 0.5 ? .green : .orange)
                        }
                        .padding(.top, 10)
                        
                        if timeFader > 0.95 {
                            Button("See Our Future") {
                                onFinish()
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                    .padding(24)
                    .background(.regularMaterial)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .frame(maxWidth: 500)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 40)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: timeFader < 0.5)
    }
}
