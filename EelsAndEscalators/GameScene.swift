//
//  GameScene.swift
//  EelsAndEscalators
//
//  Created by Lamon, Kurt David on 11/18/18.
//  Copyright © 2018 Lamon, Kurt David. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import UIKit


enum Player: Int {
    case Player1 = 1, Player2 = 2
}

class GameScene: SKScene {
    
    var player1Name: String = ""
    
    var currentSpacePlayer1: String = "s0"
    var currentSpacePlayer2: String = "s0"
    
    let eelStart: [Int] = [6, 15, 20, 22]
    let eelEnd: [Int] = [3, 1, 17, 4]
    let escalatorStart: [Int] = [2, 5, 14]
    let escalatorEnd: [Int] = [13, 10, 19]
    
    var tapCount = 0
    
    var moves: Int = 4
    var movesRemaining: Int = 5
    var whosTurn: Player = .Player1
    
    var player1Piece: SKSpriteNode = SKSpriteNode()
    var player2Piece: SKSpriteNode = SKSpriteNode()
    
    var background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        addBackground()
        for node in children {
            if node.name == "player1Piece" {
                if let someNode: SKSpriteNode = node as? SKSpriteNode {
                    player1Piece = someNode
                }
            } else if node.name == "player2Piece" {
                if let someNode: SKSpriteNode = node as? SKSpriteNode {
                    player2Piece = someNode
                }
            }
        }
    }
    
    func addBackground() {
        background = SKSpriteNode(imageNamed: "gameBoard")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.zPosition = -1
        addChild(background)
    }
    
    func movePiece() {
        if (movesRemaining > 0) {
            let currentSpace: String = returnPlayerSpace(player: whosTurn)
            var spaceNumber: String = currentSpace
            
            let firstCharacter: Character = spaceNumber.remove(at: spaceNumber.startIndex)
            let nextNumber:Int = Int(spaceNumber)! + 1
            let nextSpace: String = String(firstCharacter) + String(nextNumber)
            
            for node in children {
                if(node.name == nextSpace) {
                    let moveAction: SKAction = SKAction.move(to: node.position, duration: 0.5)
                    moveAction.timingMode = .easeOut
                    let wait: SKAction = SKAction.wait(forDuration: 0.2)
                    let runAction:SKAction = SKAction.run {
                        self.setThePlayerSpace(space: nextSpace, player: self.whosTurn)
                        self.movesRemaining = self.movesRemaining - 1
                        
                        self.movePiece()
                    }
                    returnPlayerPiece(player: whosTurn).run(SKAction.sequence([moveAction, wait, runAction]))
                }
            }
        } else {
            let currentSpace: Int = returnPlayerSpaceInt(player: whosTurn)
            if let startIndex: Int = eelStart.firstIndex(of: currentSpace) {
                let moveToSpace = eelEnd[startIndex]
                let endSpace: String = "s\(moveToSpace)"
                for node in children {
                    if node.name == endSpace {
                        let moveAction: SKAction = SKAction.move(to: node.position, duration: 0.5)
                        moveAction.timingMode = .easeOut
                        let runAction:SKAction = SKAction.run {
                            self.setThePlayerSpace(space: endSpace, player: self.whosTurn)
                        }
                        returnPlayerPiece(player: whosTurn).run(SKAction.sequence([moveAction, runAction]))
                    }
                }
            } else if let startIndex: Int = escalatorStart.firstIndex(of: currentSpace) {
                let moveToSpace = escalatorEnd[startIndex]
                let endSpace: String = "s\(moveToSpace)"
                for node in children {
                    if node.name == endSpace {
                        let moveAction: SKAction = SKAction.move(to: node.position, duration: 0.5)
                        moveAction.timingMode = .easeOut
                        let runAction:SKAction = SKAction.run {
                            self.setThePlayerSpace(space: endSpace, player: self.whosTurn)
                        }
                        returnPlayerPiece(player: whosTurn).run(SKAction.sequence([moveAction, runAction]))
                    }
                }
            }
        }
    }
    
    func returnPlayerPiece(player: Player) -> SKSpriteNode {
        var playerPiece: SKSpriteNode = SKSpriteNode()
        if (player == .Player1) {
            playerPiece = player1Piece
        } else {
            playerPiece = player2Piece
        }
        
        return playerPiece
    }
    
    func setThePlayerSpace(space: String, player: Player) {
        if(player == .Player1) {
            currentSpacePlayer1 = space
        } else {
            currentSpacePlayer2 = space
        }
    }
    
    func returnPlayerSpace(player: Player) -> String {
        var space: String = ""
        if(player == .Player1) {
            space = currentSpacePlayer1
        } else if(player == .Player2){
            space = currentSpacePlayer2
        }
        return space
    }
    
    func returnPlayerSpaceInt(player: Player) -> Int {
        if(player == .Player1) {
            let currentSpace: String = returnPlayerSpace(player: whosTurn)
            var spaceNumber: String = currentSpace
            
            spaceNumber.remove(at: spaceNumber.startIndex)
            return Int(spaceNumber)!
        } else if(player == .Player2){
            let currentSpace: String = returnPlayerSpace(player: whosTurn)
            var spaceNumber: String = currentSpace
            
            spaceNumber.remove(at: spaceNumber.startIndex)
            return Int(spaceNumber)!
        }
        return 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (tapCount % 2 == 1) {
            moves = Int.random(in: 1...6)
            if moves == 5 {
                for i in stride(from: 2, to: -1, by: -1) {
                    if escalatorStart[i] > returnPlayerSpaceInt(player: whosTurn) {
                        movesRemaining = escalatorStart[i] - returnPlayerSpaceInt(player: whosTurn)
                    }
                }
            } else if moves == 6 {
                for i in stride(from: 3, to: -1, by: -1) {
                    if eelStart[i] > returnPlayerSpaceInt(player: whosTurn) {
                        movesRemaining = eelStart[i] - returnPlayerSpaceInt(player: whosTurn)
                    }
                }
            } else {
                movesRemaining = moves
            }
            for node in children {
                if node.name == "diceLabel" {
                    if let labelNode = node as? SKLabelNode {
                        if moves == 5 {
                            labelNode.text = "Escalators!"
                        } else if moves == 6 {
                            labelNode.text = "Eeeeeellss!"
                        } else {
                            labelNode.text = "\(moves)"
                        }
                        
                    }
                }
            }
            movePiece()
        } else {
            print("\(whosTurn)")
            if (whosTurn == .Player1) {
                whosTurn = .Player2
            } else {
                whosTurn = .Player1
            }
            for node in children {
                if node.name == "playerLabel" {
                    if let labelNode = node as? SKLabelNode {
                        if (whosTurn == .Player1) {
                            labelNode.text = "\(player1Name)'s Turn"
                        } else {
                            labelNode.text = "AI's Turn"
                        }
                        
                    }
                }else if node.name == "diceLabel" {
                    if let labelNode = node as? SKLabelNode {
                        labelNode.text = "Roll"
                    }
                }
            }
            print("done")
        }
        tapCount += 1
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
