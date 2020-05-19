//
//  CurrentPlayerManager.swift
//  BubblePop
//
//  Created by Jerry Boyaji on 19/5/20.
//  Copyright © 2020 Xavier Carmo. All rights reserved.
//

import Foundation

class PlayersManager {
    private let defaults = UserDefaults.standard
    private var currentPlayerName: String?
    
    static let shared = PlayersManager()
    private(set) var players = [String:Player]()
    var currentPlayer: Player? {
        get {
            if let name = currentPlayerName {
                return players[name]
            }
            
            return nil
        }
    }
    
    private init() {
        LoadPlayers()
        
        // if the last players name exists in defaults then load that player
        if let lastPlayerName = defaults.string(forKey: "lastPlayerName") {
            ChangePlayer(name: lastPlayerName)
        }
    }
    
    // refreshes the players dictionary from user defaults
    private func LoadPlayers() {
        if let playersData = defaults.data(forKey: "players") {
            // if decoding list of players is successful, set them all up to write to
            // user defaults on change
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
    
    // changes the current player name to the name parameter
    // if a player with that name exists, with the option to
    // create a player if one isnt found
    @discardableResult func ChangePlayer(name: String, createIfMissing: Bool = false) -> Player? {
        currentPlayerName = (players[name] != nil || createIfMissing) ? name : nil

        if (players[name] != nil || createIfMissing) {
            defaults.set(name, forKey: "lastPlayerName")
        }
        
        if (players[name] == nil && createIfMissing) {
            defaults.set(name, forKey: "lastPlayerName")
            return NewPlayer(name: name)
        } else {
            return players[name]
        }
    }
    
    // creates a new player with the passed in name, adds
    // them to the player list and saves the list. Returns
    // the newly created player
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
