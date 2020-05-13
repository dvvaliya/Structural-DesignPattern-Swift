import Foundation

// Create Vec2D, GameUnit, and GameUnitImp first
struct Vec2D {
    var x, y: Double
}
    
protocol GameUnit {
    var imp: GameUnitImp {get}
    func move(to position: Vec2D)
    func look(at point: Vec2D)
}

// The implementor provides the primitive operations that are defined by the platform-dependent types
protocol GameUnitImp {
    func move(to position: Vec2D)
    func look(at point: Vec2D)
    func spawn(at position: Vec2D)
}

// The platform-dependent types
struct PSUnit: GameUnitImp {
    func move(to position: Vec2D) {
        print("\t Moving to \(position)")
    }
    
    func look(at point: Vec2D) {
        print("\t Looking at \(point)")
    }
    
    func spawn(at position: Vec2D) {
        print("\t Spawning at \(position)")
    }
}

struct XboxUnit: GameUnitImp {
    func move(to position: Vec2D) {
        print("\t Moving to \(adjust(position))")
    }
    
    func look(at point: Vec2D) {
        print("\t Looking at \(adjust(point))")
    }

    func spawn(at position: Vec2D) {
        print("\t Spawning at \(adjust(position))")
    }
    
    private func adjust(_ v: Vec2D) -> Vec2D {
        // mirror Y-axis
        Vec2D(x: v.x, y: -v.y)
    }
}

// The default behavior for the GameUnit method and computed property requirements
extension GameUnit {
    var imp: GameUnitImp {
        GameUnitSystemFactory.makeUnit()
    }

    func move(to position: Vec2D) {
        imp.move(to: position)
    }

    func look(at point: Vec2D) {
        imp.look(at: point)
    }
}

enum Platform: CustomStringConvertible {
    case ps
    case xbox
    
    var description: String {
        self == .xbox ? "Xbox" : "PlayStation"
    }
}

struct GameUnitSystemFactory {
    static var platform: Platform = .ps
    
    static func makeUnit() -> GameUnitImp {
        platform == .xbox ? XboxUnit() : PSUnit()
    }
}

struct PlayerControlled: GameUnit {
    init() {
        print("\(GameUnitSystemFactory.platform) \(self) unit created")
    }
}

// Autonomous agent
struct Agent: GameUnit {
    init() {
        print("\(GameUnitSystemFactory.platform) \(self) unit created")
    }

    func follow(path: [Vec2D]) {
        for pos in path {
            imp.move(to: pos)
        }
    }
}

// NPC type
struct NPC: GameUnit {
    init() {
        print("\(GameUnitSystemFactory.platform) \(self) unit created")
    }
    
    func spawn(at: Vec2D) {
        imp.spawn(at: at)
    }
}

// Provide the platform type by setting the GameUnitSystemFactory's platform property
GameUnitSystemFactory.platform = .xbox

let gameUnit = PlayerControlled()
gameUnit.move(to: Vec2D(x: 10, y: 0))

let agent = Agent()
agent.move(to: Vec2D(x: 100, y: 25))
agent.look(at: Vec2D(x: 1, y: 0))
agent.follow(path: [Vec2D(x: 10, y: 10), Vec2D(x: 15, y: 42)])

// Platform changed to PlayStation
GameUnitSystemFactory.platform = .ps

let psAgent = Agent()
psAgent.look(at: Vec2D(x: 1, y: 1))

let npcPSUnit = NPC()
npcPSUnit.spawn(at: Vec2D(x: 100, y: 0))
