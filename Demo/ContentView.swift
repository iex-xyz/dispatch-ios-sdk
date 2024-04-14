//
//  ContentView.swift
//  Demo
//
//  Created by Stephen Silber on 4/12/24.
//

import SwiftUI
import Dispatch

struct ContentView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController(nibName: nil, bundle: nil)
        viewController.view.backgroundColor = .red
        return UINavigationController(rootViewController: viewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}

#Preview {
    ContentView()
}
