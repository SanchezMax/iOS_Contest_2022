//
//  Home.swift
//  IOSContest2022
//
//  Created by Maksim Zykin on 27.10.2022.
//

import SwiftUI
import PhotosUI

struct Home: View {
    @StateObject var model = DrawingViewModel()
    @State var isAuthorized: Bool =
    PHPhotoLibrary.authorizationStatus() == .notDetermined ||
    PHPhotoLibrary.authorizationStatus() == .restricted ||
    PHPhotoLibrary.authorizationStatus() == .denied ? false : true
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if isAuthorized {
                        if UIImage(data: model.imageData) != nil {
                            DrawingScreen()
                                .environmentObject(model)
                        } else {
                            ImagePicker(imageData: $model.imageData)
                                .transition(.move(edge: .leading))
                                .zIndex(2)
                        }
                    } else {
                        AccessScreen(isAuthorized: $isAuthorized)
                    }
                }
                .navigationBarHidden(false)
                .onAppear {
                    switch PHPhotoLibrary.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        break
                    case .authorized, .limited:
                        withAnimation {
                            isAuthorized = true
                        }
                    @unknown default:
                        break
                    }
                }
            }
        }
        .alert(isPresented: $model.showAlert) {
            if model.isOneButton {
                return Alert(title: Text(model.title), message: Text(model.message), dismissButton: .default(Text(model.actionMessage)))
            } else {
                return Alert(title: Text(model.title), message: Text(model.message), primaryButton: .destructive(Text(model.actionMessage), action: model.action), secondaryButton: .cancel())
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(isAuthorized: true)
    }
}
