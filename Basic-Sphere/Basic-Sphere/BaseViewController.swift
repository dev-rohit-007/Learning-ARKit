//
//  ViewController.swift
//  Basic-Sphere
//
//  Created by Rohit Mishra on 24/05/25.
//

import UIKit
import RealityKit

class BaseViewController: UIViewController {
    private var arView: ARView = {
       let view = ARView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARView()
        setupSphere()
    }
}


// MARK: - Helper methods
private extension BaseViewController {
    func setupARView() {
        self.view.addSubview(arView)
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSphere() {
        // Need: - 3D Model
        let sphere = MeshResource.generateSphere(radius: 0.05)
        let material = SimpleMaterial(color: .red, isMetallic: true)
        
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        
        // Create Anchor Entity
        let sphareAnchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z: 0))
        sphareAnchor.addChild(sphereEntity)
        
        // Add anchor to the scene
        arView.scene.addAnchor(sphareAnchor)
    }
}
