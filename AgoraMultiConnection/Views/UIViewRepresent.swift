//
//  CustomViewRepresentable.swift
//  AgoraMultiConnection
//
//  Created by BBC on 2024/9/6.
//

import Foundation
import SwiftUI

struct UIViewRepresent : UIViewRepresentable {
    let containerUIView = UIView()
    
    func makeUIView(context: Context) -> UIView {
        containerUIView.backgroundColor = .darkGray
//        containerUIView.layer.cornerRadius = 25
        return containerUIView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {

    }

}

