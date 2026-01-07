import Foundation

struct Match: Codable {
    let matchId: String
    let map: String
    let durationSeconds: Int
    let teams: [Team]

    func validate() throws {
        if matchId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { throw ValidationError("empty matchId") }
        if durationSeconds <= 0 { throw ValidationError("invalid duration") }
        if teams.count != 2 { throw ValidationError("expected 2 teams") }
        for team in teams { try team.validate() }
    }
}

struct Team: Codable {
    let teamId: String
    let name: String
    let score: Int
    let players: [Player]

    func validate() throws {
        if name.trimmingCharacters(in: .whitespaces).isEmpty { throw ValidationError("empty team name") }
        if players.isEmpty { throw ValidationError("no players in team") }
        var ids = Set<String>()
        for p in players {
            if ids.contains(p.playerId) { throw ValidationError("duplicate player id \(p.playerId)") }
            ids.insert(p.playerId)
            try p.validate()
        }
    }
}

struct Player: Codable {
    let playerId: String
    let name: String
    let agent: String
    let kills: Int
    let deaths: Int
    let assists: Int

    func validate() throws {
        if playerId.trimmingCharacters(in: .whitespaces).isEmpty { throw ValidationError("empty player id") }
        if kills < 0 || deaths < 0 || assists < 0 { throw ValidationError("negative stats") }
        if name.trimmingCharacters(in: .whitespaces).isEmpty { throw ValidationError("empty player name") }
    }
}

struct ValidationError: Error, CustomStringConvertible {
    let msg: String
    init(_ s: String) { msg = s }
    var description: String { msg }
}
