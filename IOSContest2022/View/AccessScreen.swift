//
//  AccessScreen.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 28.10.2022.
//

import SwiftUI
import PhotosUI
import Lottie

struct AccessScreen: View {
    @Binding var isAuthorized: Bool
    @State var animation: Bool = true
    
    @State var animationView = LottieAnimationView(name: "duck")
    
    var body: some View {
        VStack {
            Spacer()
            
            LottieView(animationView: $animationView)
                .frame(width: 144, height: 144)
                .onAppear {
                    animationView.loopMode = .loop
                    animationView.play()
                }
            
            Text("Access Your Photos And Videos")
                .font(.system(size: 20, weight: .semibold))
                .padding()
            Button {
                if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                    PHPhotoLibrary.requestAuthorization() { status in
                        if #available(iOS 14, *) {
                            if status == .authorized || status == .limited {
                                withAnimation {
                                    isAuthorized = true
                                }
                            }
                        } else {
                            if status == .authorized {
                                withAnimation {
                                    isAuthorized = true
                                }
                            }
                        }
                    }
                } else {
                    gotoAppPrivacySettings()
                }
            } label: {
                
                ZStack {
                    HStack {
                        Spacer()
                        Text("Allow Access")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.vertical, 15)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .background(
                        Color(#colorLiteral(red: 0.07450980693101883, green: 0.5686274766921997, blue: 1, alpha: 1))
                    )
                    .cornerRadius(10)
                    HStack {
                        Spacer()
                        Text("Allow Access")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.vertical, 15)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(10)
                    .mask(
                        Rectangle()
                            .fill(LinearGradient(gradient: .init(colors: [.clear, .white, .clear]), startPoint: .leading, endPoint: .center))
                            .offset(x: self.animation ? -400 : 400)
                    )
                }
                .onAppear {
                    withAnimation(Animation.default.speed(0.2).delay(0).repeatForever(autoreverses: false)) {
                        self.animation.toggle()
                    }
                }
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .transition(.move(edge: .bottom))
        .zIndex(3)
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            assertionFailure("Not able to open App privacy settings")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct AccessScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccessScreen(isAuthorized: .constant(false))
    }
}
