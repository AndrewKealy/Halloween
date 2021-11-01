//
//  ViewController.swift
//  HalloweenItems
//
//  Created by Andrew Kealy on 30/10/2021.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
      //  let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
    //    sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionObjects = referenceObjects
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
   
        
        guard let objectAnchor = anchor as? ARObjectAnchor else {return}
        DispatchQueue.main.async {
            
            let scaleThenRotateAndHover = self.getNodeAnimation()
            let pumpkinNode = self.createPumpkin(withObjectAnchor: objectAnchor)
            pumpkinNode.scale = (SCNVector3( x: 0.0, y: 0.0, z: 0.0))
            
            pumpkinNode.runAction(scaleThenRotateAndHover);
            node.addChildNode(pumpkinNode)
        }
 

    }
    
    //A series of SCNActions to animate the nodes
    
    func getNodeAnimation() -> SCNAction {
        
        // The node is scaled from zero to half size
        let scaleAction = SCNAction.scale(to: 0.5, duration: 1)
        
        //The node is rotated around its y axis
        let rotateAction = SCNAction.rotateBy(x: 0, y: Double.pi, z: 0, duration: 5);
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 1.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 1.5)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let rotateAndHover = SCNAction.group([rotateAction, hoverSequence])
        let repeatForever = SCNAction.repeatForever(rotateAndHover)
        
        guard let audioSource = SCNAudioSource(fileNamed: "art.scnassets/Pumpkin.mp3") else { fatalError("Audio Asset could not be found") }
            let playAudio = SCNAction.playAudio(audioSource, waitForCompletion: false)

  
        
        
        let scaleThenRotateAndHover = SCNAction.group([playAudio, scaleAction, repeatForever])
        
        return scaleThenRotateAndHover
    }
    

    
    func createPumpkin(withObjectAnchor objectAnchor: ARObjectAnchor) -> SCNNode {
        let pumpkinScene = SCNScene(named: "art.scnassets/Halloween_Pumpkin_copy.scn")!
        let pumpkinNode = pumpkinScene.rootNode.childNode(withName: "Halloween_Pumpkin", recursively: true)!
        pumpkinNode.position = SCNVector3(objectAnchor.referenceObject.center.x, 0.0, objectAnchor.referenceObject.center.z)
        return pumpkinNode
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
