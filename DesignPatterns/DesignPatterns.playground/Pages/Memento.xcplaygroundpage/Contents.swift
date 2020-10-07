import Foundation

//MARK:- Originator
public class Game: Codable {
  public class State: Codable {
    public var attemptsRemaining = 3
    public var score = 0
    public var level = 1
  }
  
  public var state = State()
  
  public func scoreSomePoints() {
    state.score += 9000
  }
  
  public func lostLife() {
    state.attemptsRemaining -= 1
  }
}

//MARK:- Memento
typealias GameMemento = Data

//MARK:- CareTaker
public class GameSystem {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let userDefaults = UserDefaults.standard
  
  public func save(_ game: Game, title: String) throws {
    let data = try encoder.encode(game) // Encoder converts object into external representation ( here data)
    userDefaults.set(data, forKey: title)
  }
  
  public func load(title: String) throws -> Game {
    guard let gameData = userDefaults.data(forKey: title),
      let game = try? decoder.decode(Game.self, from: gameData) else { throw Error.gameNotFound } // Decoder converts  external representation ( here data) into Object
    return game
  }
  
  public enum Error: String, Swift.Error {
    case gameNotFound
  }
}

//MARK:-Example

let gameSystem = GameSystem()

let game1 = Game()
game1.lostLife()
game1.scoreSomePoints()
game1.state.score
game1.state.attemptsRemaining
gameSystem.save(game1, title: "Game 1: Rushi")

let game2 = Game()
game2.state.score
game2.state.attemptsRemaining

let loadedGame1 = try! gameSystem.load(title:"Game 1: Rushi")
loadedGame1.state.score
loadedGame1.state.attemptsRemaining
