//
//  DatabaseHelper.swift
//  ApexPerformance Logger
//
//  Created by Liam Kommer on 6/14/25.
//

import Foundation
import SQLite

class DatabaseHelper {
    static let shared = DatabaseHelper()
    var db: Connection?

    // ✅ Initialize SQLite Database Connection
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/apexStats.sqlite3"
            print("Database path: \(path)")
            db = try Connection(path)
            createTable()
        } catch {
            print("Database connection error: \(error)")
        }
    }

    // ✅ Create Table If Not Exists
    func createTable() {
        do {
            try db?.run(apexStats.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(Platform)
                table.column(matchDate)
                table.column(matchType)
                table.column(playerID)
                table.column(premadeSquad)
                table.column(teamComp)
                table.column(rankBefore)
                table.column(jumpMaster)
                table.column(fullSquad)
                table.column(kills)
                table.column(damageDealt)
                table.column(standing)
                table.column(poi)
                table.column(notes)
            })
        } catch {
            print("Error creating table: \(error)")
        }
    }

    // ✅ Define Table and Columns
    let apexStats = Table("apexStats")

    let id = Expression<Int64>("id")
    let Platform = Expression<String>("Platform")
    let matchDate = Expression<Date>("matchDate")
    let matchType = Expression<String>("matchType")
    let playerID = Expression<String>("playerID")
    let premadeSquad = Expression<Bool>("premadeSquad")
    let teamComp = Expression<String>("teamComp")
    let rankBefore = Expression<String>("rankBefore")
    let jumpMaster = Expression<Bool>("jumpMaster")
    let fullSquad = Expression<Int>("fullSquad")
    let kills = Expression<Int>("kills")
    let damageDealt = Expression<Int>("damageDealt")
    let standing = Expression<String>("standing")
    let poi = Expression<String>("poi")
    let notes = Expression<String>("notes")

    // ✅ Insert Data into Database
    func insertGameData(userInput: UserInput) {
        do {
            let insert = apexStats.insert(
                Platform <- userInput.Platform,
                matchDate <- userInput.matchDate,
                matchType <- userInput.matchType,
                playerID <- userInput.playerID,
                premadeSquad <- userInput.premadeSquad,
                teamComp <- userInput.teamComp,
                rankBefore <- userInput.rankBefore,
                jumpMaster <- userInput.jumpMaster,
                fullSquad <- userInput.fullSquad,
                kills <- userInput.kills,
                damageDealt <- userInput.damageDealt,
                standing <- userInput.standing,
                poi <- userInput.poi,
                notes <- userInput.notes
            )
            try db?.run(insert)
        } catch {
            print("Error saving data: \(error)")
        }
    }
}

