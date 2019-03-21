//
//  ViewController.swift
//  Space Rescue
//
//  Created by Jacqualyn Blizzard-Caron on 3/11/19.
//  Copyright © 2019 Jacqualyn Blizzard-Caron. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    // Part 2 - Update this method to display a sprite node with image named dog
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        /*let spaceDog = SKSpriteNode(imageNamed: "trappedDog")
        spaceDog.name = "trappedDog"
        return spaceDog*/
        var node: SKNode?
        if let anchor = anchor as? Anchor {
            if let type = anchor.type {
                node = SKSpriteNode(imageNamed: type.rawValue)
                node?.name = type.rawValue
            }
        }
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Session Failed - probably due to lack of camera access")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Session interrupted")
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Session resumed")
    }
}
