//
//  ViewController.swift
//  Plan-Detection
//
//  Created by Rohit Mishra on 24/05/25.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {

    private var arView: ARView = {
       var view = ARView(frame: .zero)
        view.automaticallyConfigureSession = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        
        // Start plan detection
        startPlanDetection()
        
        // Get 2D point
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:))))
    }

}

private extension ViewController {
    func setupARView() {
        view.addSubview(arView)
        
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func startPlanDetection() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
    }
    
    @objc
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
       // Touch location
        
        let tapLocation = recognizer.location(in: arView)
        
        // Raycast (2D -> 3D)
        let results = arView.raycast(from: tapLocation, allowing:   .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first {
            // 3D point (x,y,z)
            let worldPosition = simd_make_float3(firstResult.worldTransform.columns.3)
            
            let sphere = createSphere()
            
            placeObject(object: sphere, at: worldPosition)
        }
    }
    
    func createSphere() -> ModelEntity {
        // Mesh
        let sphere = MeshResource.generateSphere(radius: 0.03)
        
        // Material
        let material = SimpleMaterial(color: .red, isMetallic: true)
        
        // Assign material
        let modelEntity = ModelEntity(mesh: sphere, materials: [material])
        
        return modelEntity
    }
    
    func placeObject(object: ModelEntity, at location: SIMD3<Float>) {
        // Create anchor
        let objectAnchor = AnchorEntity(world: location)
        
        // Add object to the entity
        objectAnchor.addChild(object)
        
        // Adding in AR world
        arView.scene.addAnchor(objectAnchor)
    }
    
}
