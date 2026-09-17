import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var gameState: GameState = ContentView.makeInitialState()
    @State private var scene: TestRoomScene?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let scene {
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                } else {
                    Color.black.ignoresSafeArea()
                }
                GameHUDView(gameState: gameState)
            }
            .onAppear {
                if scene == nil {
                    scene = TestRoomScene(state: gameState, size: geo.size)
                }
            }
        }
    }

    private static func makeInitialState() -> GameState {
        let bounds = CGRect(x: -600, y: -400, width: 1200, height: 800)
        let room = TestRoom(
            bounds: bounds,
            playerSpawn: CGPoint(x: 0, y: -300),
            batterySpawn: CGPoint(x: 220, y: 60),
            doorPosition: CGPoint(x: 0, y: 330)
        )
        return GameState(room: room)
    }
}

#Preview {
    ContentView()
}
