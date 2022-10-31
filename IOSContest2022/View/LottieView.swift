//
//  LottieView.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 31.10.2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    @Binding var animationView: LottieAnimationView
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        animationView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
