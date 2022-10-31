//
//  ImagePicker.swift
//  IOSContest2022
//
//  Created by Maksim Zykin on 27.10.2022.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var imageData: Data
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
//        controller.mediaTypes = ["public.image", "public.movie"]
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageData = (info[.originalImage] as? UIImage)?.pngData() {
                withAnimation {
                    parent.imageData = imageData
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        }
    }
}
