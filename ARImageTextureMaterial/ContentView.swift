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
