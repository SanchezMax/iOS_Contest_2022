//
//  AccessScreen.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 28.10.2022.
//

import SwiftUI
import PhotosUI

struct AccessScreen: View {
    @Binding var isAuthorized: Bool
    
    var body: some View {
        VStack {
            Spacer()
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
                HStack {
                    Spacer()
                    Text("Allow Access")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.vertical, 15)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            Spacer()
        }
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
