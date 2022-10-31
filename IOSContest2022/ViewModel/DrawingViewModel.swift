//
//  DrawingViewModel.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 27.10.2022.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0)
    
    @Published var canvas = PKCanvasView()
    
    @Published var textBoxes: [TextBox] = []
    @Published var tools: [Tool] = [
        Tool(base: "pen.base", tip: "pen.tip", color: Color("pen.default"), padding: 44, width: 2, isDrawing: true, inkType: .pen),
        Tool(base: "brush.base", tip: "brush.tip", color: Color("brush.default"), padding: 38, width: 6, isDrawing: true, inkType: .marker),
        Tool(base: "neon.base", tip: "neon.tip", color: Color("neon.default"), padding: 38, width: 14, isDrawing: true, inkType: .marker),
        Tool(base: "pencil.base", tip: "pencil.tip", color: Color("pencil.default"), padding: 40, width: 8, isDrawing: true, inkType: .pencil),
        Tool(base: "lasso.base", tip: nil, color: nil, padding: nil, width: 0, isDrawing: false, inkType: nil),
        Tool(base: "eraser.base", tip: nil, color: nil, padding: nil, width: 0, isDrawing: false, eraserType: .bitmap, inkType: nil)
    ]
    
    @Published var addNewBox = false
    
    @Published var currentIndex: Int = 0
    
    @Published var rect: CGRect = .zero
    
    @Published var showAlert = false
    @Published var isOneButton = false
    @Published var title = ""
    @Published var message = ""
    @Published var action: (() -> Void)? = nil
    @Published var actionMessage = ""
    
    @Published var selectedOption: Options = .draw
    
    func cancelImageEditing() -> Void {
        withAnimation {
            imageData = Data(count: 0)
        }
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }
    
    func cancelTextView() {
        // TODO: show ToolPicker
        
        withAnimation {
            addNewBox = false
        }
        
        if !textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
            currentIndex = textBoxes.count - 1
        }
    }
    
    func drag(box: TextBox) -> some Gesture {
        DragGesture()
            .onChanged { [self] in
                textBoxes[getIndex(textBox: box)].offset = $0.translation
            }
            .onEnded { [self] in
                textBoxes[getIndex(textBox: box)].lastOffset.width += $0.translation.width
                textBoxes[getIndex(textBox: box)].lastOffset.height += $0.translation.height
                textBoxes[getIndex(textBox: box)].offset = .zero
            }
    }
    
    func rotate(box: TextBox) -> some Gesture {
        RotationGesture()
            .onChanged { [self] in textBoxes[getIndex(textBox: box)].angle = $0 }
            .onEnded { [self] in
                textBoxes[getIndex(textBox: box)].lastAngle += $0
                textBoxes[getIndex(textBox: box)].angle = .zero
            }
    }
    
    func zoom(box: TextBox) -> some Gesture {
        MagnificationGesture()
            .onChanged { [self] in textBoxes[getIndex(textBox: box)].scale = $0 }
            .onEnded { [self] in
                textBoxes[getIndex(textBox: box)].lastScale *= $0
                textBoxes[getIndex(textBox: box)].scale = 1.0
            }
    }
    
    func getIndex(textBox: TextBox) -> Int {
        let index = textBoxes.firstIndex { box in
            textBox.id == box.id
        } ?? 0
        
        return index
    }
    
    func unavailableAlert() {
        self.title = "Not available"
        self.message = "This function is currently in development."
        self.actionMessage = "Ok"
        self.isOneButton = true
        self.showAlert.toggle()
    }
    
    func unsavedAlert() {
        self.title = "Unsaved changes"
        self.message = "Are you sure you want to discard this media? It will be lost"
        self.action = cancelImageEditing
        self.actionMessage = "Discard"
        self.isOneButton = false
        self.showAlert.toggle()
    }
    
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let SwiftUIView = ZStack {
            ForEach(textBoxes) { [self] box in
                Text(textBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                // TODO: include text size in model
                    .font(.system(size: box.fontSize))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor?.opacity(box.textOpacity))
                    .scaleEffect(box.scale * box.lastScale)
                    .rotationEffect(box.angle + box.lastAngle)
                    .offset(x: box.offset.width + box.lastOffset.width, y: box.offset.height + box.lastOffset.height)
            }
        }
        
        let controller = UIHostingController(rootView: SwiftUIView).view!
        controller.frame = rect
        
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage?.pngData() {
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            cancelImageEditing()
        }
    }
}
