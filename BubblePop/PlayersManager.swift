//
//  CurrentPlayerManager.swift
//  BubblePop
//
//  Created by Xavier Carmo on 19/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation

// singleton class for managing access to the players dictionary
// from user defaults
class PlayersManager {
    // private members
    private let defaults = UserDefaults.standard
    private var currentPlayerName: String?
    
    // public members/properties
    static let shared = PlayersManager()
    private(set) var players = [String:Player]()
    // property for retrieving the current active player
    var currentPlayer: Player? {
        get {
            if let name = currentPlayerName {
                return players[name]
            }
            
            return nil
        }
    }
    
    private init() {
        // load the player dictionary from user defaults
        LoadPlayers()
        
        // if the last players name exists in defaults then load that player
        if let lastPlayerName = defaults.string(forKey: "lastPlayerName") {
            ChangePlayer(name: lastPlayerName)
        }
    }
    
    // loads the players dictionary from user defaults
    private func LoadPlayers() {
        if let playersData = defaults.data(forKey: "players") {
            // try to decode the dictionary of players, and set them all up
            // to trigger a save when their details change
            players = (try? JSONDecoder().decode([String:Player].self, from: playersData)) ?? players
            players.forEach({ $1.onChanged = { _ in self.Save() }})
        }
    }
    
    // encodes and saves the player list to user defaults
    private func Save() {
        if let encodedPlayers = try? JSONEncoder().encode(players) {
            defaults.set(encodedPlayers, forKey: "players")
        }
    }
    
    // changes the current player name to the name parameter if
    // a player with that name exists, with the option to create
    // a player if one isnt found
    @discardableResult func ChangePlayer(name: String, createIfMissing: Bool = false) -> Player? {
        // if the player exists or one should be created
        if players[name] != nil || createIfMissing {
            currentPlayerName = name
            defaults.set(name, forKey: "lastPlayerName")
            return players[name] ?? NewPlayer(name: name)
        } else {
            currentPlayerName = nil
            return nil
        }
    }
    
    // creates a new player with the passed in name, adds
    // them to the player list and saves the list. Returns
    // the newly created player. Returns an existing player
    // if the name is taken
    func NewPlayer(name: String) -> Player {
        if let player = players[name] {
            return player
        } else {
            let newPlayer = Player(name: name)
            newPlayer.onChanged = { _ in self.Save() }
            
            players[name] = newPlayer
            currentPlayerName = name

            Save()

            return newPlayer
        }
    }
}
