//
//  Sample.swift
//  SampleAR
//
//  Created by cmStudent on 2022/10/05.
//

import SwiftUI
import ARKit

struct SampleFaceTracking: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    
    var ARView = ARSCNView()
    
    private var faceNode = SCNNode()

    func makeUIView(context: Context) -> ARSCNView {
        ARView.delegate = context.coordinator
        setARView()
        return ARView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        run()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func setARView() {

        ARView.session = ARSession()
        ARView.scene = SCNScene()
        
        if let geometry = faceNode.geometry {
            let node = SCNNode(geometry: geometry)
            geometry.firstMaterial?.diffuse.contents = UIColor.blue
            ARView.scene.rootNode.addChildNode(node)
            
        }
    }
    
    private func run() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 1
        
        ARView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
        
}

final class Coordinator: NSObject, ARSCNViewDelegate {
    let parent: SampleFaceTracking
    
    var leftEyeNode = SCNReferenceNode()
    var rightEyeNode = SCNReferenceNode()
    
    init(_ sampleAR: SampleFaceTracking) {
        self.parent = sampleAR
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor
                else { return }
            
            rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
            leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
        
            print("=========右目==========")
            print(rightEyeNode.simdTransform)
            print("=========左目==========")
            print(leftEyeNode.simdTransform)
        }
}
