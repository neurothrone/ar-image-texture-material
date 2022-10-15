//
//  ContentView.swift
//  ARImageTextureMaterial
//
//  Created by Zaid Neurothrone on 2022-10-15.
//

import Combine
import RealityKit
import SwiftUI

struct ContentView : View {
  var body: some View {
    ARViewContainer().edgesIgnoringSafeArea(.all)
  }
}

final class Coordinator {
  var arView: ARView?
  var cancellable: Cancellable?
  
  func setUp() {
    guard let arView = arView else { return }
    
    let anchor = AnchorEntity(plane: .horizontal)
//    anchor.addChild(loadTextureResourceSynchronouslyAndAttachToAllFaces())
    anchor.addChild(loadMultipleTextureResourcesAsynchronouslyAndAttachToEachFaceOfCube())
    arView.scene.addAnchor(anchor)
  }
  
  private func loadTextureResourceSynchronouslyAndAttachToAllFaces() -> ModelEntity {
    let box = ModelEntity(mesh: .generateBox(size: 0.3))
    let textureResource = try? TextureResource.load(named: "placeholder")
    
    if let textureResource {
      var textureMaterial = UnlitMaterial()
      textureMaterial.color = .init(tint: .white, texture: .init(textureResource))
      box.model?.materials = [textureMaterial]
    }
    
    return box
  }
  
  private func loadMultipleTextureResourcesAsynchronouslyAndAttachToEachFaceOfCube() -> ModelEntity {
    let box = ModelEntity(mesh: .generateBox(width: 0.3, height: 0.3, depth: 0.3, cornerRadius: .zero, splitFaces: true))
    
    cancellable = TextureResource.loadAsync(named: "placeholder")
      .append(TextureResource.loadAsync(named: "cube"))
      .append(TextureResource.loadAsync(named: "1.JPG"))
      .append(TextureResource.loadAsync(named: "2.JPG"))
      .append(TextureResource.loadAsync(named: "3.JPG"))
      .append(TextureResource.loadAsync(named: "4"))
      .collect()
      .sink(receiveCompletion: { [weak self] completion in
        if case let .failure(error) = completion {
          fatalError("❌ -> Unable to load textures. Error: \(error)")
        }
        
        self?.cancellable?.cancel()
      }, receiveValue: { textureResources in
        var materials: [UnlitMaterial] = []
        
        textureResources.forEach { texture in
          var material = UnlitMaterial()
          material.color = .init(tint: .white, texture: .init(texture))
          materials.append(material)
        }
        
        box.model?.materials = materials
      })
    
    return box
  }
}

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> ARView {
    let arView = ARView(frame: .zero)
    
    context.coordinator.arView = arView
    context.coordinator.setUp()
    
    return arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    .init()
  }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
