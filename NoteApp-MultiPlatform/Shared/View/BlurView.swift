//
//  BlurView.swift
//  NoteApp-MultiPlatform (iOS)
//
//  Created by GOURAVM on 24/08/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style : UIBlurEffect.Style
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

