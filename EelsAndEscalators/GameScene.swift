//
//  GameScene.swift
//  EelsAndEscalators
//
//  Created by Lamon, Kurt David on 11/18/18.
//  Copyright © 2018 Lamon, Kurt David. All rights reserved.
//

import SpriteKit
import GameplayKit


enum Player: Int {
    case Player1 = 1, Player2
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var currentSpacePlayer1: String = "s0"
    var currentSpacePlayer2: String = "s0"
    
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
            if (whosTurn == .Player1) {
                whosTurn = .Player2
            } else {
                whosTurn = .Player1
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        movesRemaining = moves
        movePiece()
    }
    
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
