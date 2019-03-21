//
//  Scene.swift
//  Space Rescue
//
//  Created by Jacqualyn Blizzard-Caron on 3/11/19.
//  Copyright © 2019 Jacqualyn Blizzard-Caron. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    // Part 2 - Code clean up
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    var isWorldSetUp = false
    
    // Part 4 - Add Sight
    var aim: SKSpriteNode!
    
    // Part 5 - Set up size of game
    let gameSize = CGSize(width: 2, height: 2)
    
    // Part 7 - Track whether you have fuel or not.
    var haveFuel = false
    
    // Part 8 Setting Up the SpriteKit Scene
    let spaceDogLabel = SKLabelNode(text: "Space Dogs Rescued")
    let numberOfDogsLabel = SKLabelNode(text: "0")
    var dogCount = 0 {
        didSet {
            self.numberOfDogsLabel.text = "\(dogCount)"
        }
    }
   
    override func didMove(to view: SKView) {
        // Setup your scene here
        // Part 4 - Add aim sprite node to the scene
        aim = SKSpriteNode(imageNamed: "aim")
        addChild(aim)
        // Part 7
        setUpLabels()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Part 2 - Call setUpWorld
        if isWorldSetUp == false {
            setUpWorld()
        }
        // Part 3 - Call adjustLighting
        adjustLighting()
        
        // Part 7 - Collect Fuel
        guard let currentFrame = sceneView.session.currentFrame  else {
            return
        }
        collectFuel(currentFrame: currentFrame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rescueDog()
    }
    
    // Part 2 - Clean up code and create new function setUpWorld
    // Part 5 - Update setUpWorld
    func setUpWorld() {
        // Create anchor using the camera's current position
        guard let currentFrame = sceneView.session.currentFrame,
            let scene = SKScene(fileNamed: "Level1") else {
                return
            }
            for node in scene.children {
                if let node = node as? SKSpriteNode {
                    var translation = matrix_identity_float4x4
                    let positionX = node.position.x/scene.size.width
                    let positionY = node.position.y/scene.size.height
                    translation.columns.3.x = Float(positionX*gameSize.width)
                    translation.columns.3.z = -Float(positionY*gameSize.height)
                    translation.columns.3.y = Float.random(in: -0.5..<0.5)
                    print(translation.columns.3.y)
                    let transform = simd_mul(currentFrame.camera.transform, translation)
                    //let anchor = ARAnchor(transform: transform)
                    //sceneView.session.add(anchor: anchor)
                    let anchor = Anchor(transform: transform)
                    if let name = node.name,
                        let type = NodeType(rawValue: name) {
                        anchor.type = type
                        sceneView.session.add(anchor: anchor)
                    }
            }
            isWorldSetUp = true
        }
    }
    
    // Part 3 - Light Estimation
    func adjustLighting() {
        guard let currentFrame = sceneView.session.currentFrame, let lightEstimate = currentFrame.lightEstimate else {
            return
        }
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity, neutralIntensity)
        let blendFactor = 1 - ambientIntensity/neutralIntensity
        for node in children {
            if let spaceDog = node as? SKSpriteNode {
                spaceDog.color = .black
                spaceDog.colorBlendFactor = blendFactor
            }
        }
    }
    
    // Part 4 - Rescue Dog
    func rescueDog() {
        let location = aim.position
        let hitNodes = nodes(at: location)
        var rescuedDog: SKNode?
        for node in hitNodes {
            if node.name == "trappedDog" && haveFuel == true {
                rescuedDog = node
                break
            }
        }
        if let rescuedDog = rescuedDog {
            let wait = SKAction.wait(forDuration: 0.3)
            let removeDog = SKAction.removeFromParent()
            let sequence = SKAction.sequence([wait, removeDog])
            rescuedDog.run(sequence)
            dogCount += 1 // Part 8
        }
    }
    
    // Part 7 - Collect Fuel
    func collectFuel(currentFrame: ARFrame) {
        for anchor in currentFrame.anchors {
            guard let node = sceneView.node(for: anchor),
            node.name == NodeType.fuel.rawValue
            else {continue}
            let distance = simd_distance(anchor.transform.columns.3, currentFrame.camera.transform.columns.3)
            if distance < 0.1 {
                sceneView.session.remove(anchor: anchor)
                haveFuel = true
                break
            }
        }
    }
    
    // Part 8 - Set Up Labels Function
    func setUpLabels() {
        spaceDogLabel.fontSize = 20
        spaceDogLabel.fontName = "Futura-Medium"
        spaceDogLabel.color = .white
        spaceDogLabel.position = CGPoint(x: 0, y: 280)
        addChild(spaceDogLabel)
        
        numberOfDogsLabel.fontSize = 30
        numberOfDogsLabel.fontName = "Futura-Medium"
        numberOfDogsLabel.color = .white
        numberOfDogsLabel.position = CGPoint(x: 0, y: 240)
        addChild(numberOfDogsLabel)
    }
    
}
