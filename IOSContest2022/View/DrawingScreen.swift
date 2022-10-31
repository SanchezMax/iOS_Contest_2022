//
//  DrawingScreen.swift
//  IOSContest2022
//
//  Created by Maksim Zykin on 27.10.2022.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @Environment(\.undoManager) private var undoManager
    
    @EnvironmentObject var model: DrawingViewModel
    
    @State private var canUndo = false
    private let undoObserver = NotificationCenter.default.publisher(for: .NSUndoManagerCheckpoint)
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                GeometryReader { proxy -> AnyView in
                    
                    let size = proxy.frame(in: .global)
                    
                    DispatchQueue.main.async {
                        if model.rect == .zero {
                            model.rect = size
                        }
                    }
                    
                    return AnyView(
                        ZStack {
                            CanvasView(canvas: $model.canvas, imageData: $model.imageData, rect: size.size)
                                .colorScheme(.light)
                            
                            ForEach(model.textBoxes) { box in
                                Text(model.textBoxes[model.currentIndex].id == box.id && model.addNewBox ? "" : box.text)
                                    .font(.system(size: box.fontSize))
                                    .fontWeight(box.isBold ? .bold : .none)
                                    .foregroundColor(box.textColor?.opacity(box.textOpacity) ?? Color.white)
                                    .scaleEffect(box.scale * box.lastScale)
                                    .rotationEffect(box.angle + box.lastAngle)
                                    .offset(x: box.offset.width + box.lastOffset.width, y: box.offset.height + box.lastOffset.height)
                                    .gesture(model.drag(box: box))
                                    .gesture(
                                        model.rotate(box: box)
                                            .simultaneously(with: model.zoom(box: box)))
                                    .onLongPressGesture {
                                        // TODO: Close ToolPicker
                                        model.currentIndex = model.getIndex(textBox: box)
                                        withAnimation {
                                            model.addNewBox = true
                                        }
                                    }
                            }
                            if model.addNewBox {
                                TextScreen()
                                    .environmentObject(model)
                            }
                            ToolPicker(canUndo: $canUndo)
                                .environmentObject(model)
                                .zIndex(1.2)
                        }
                    )
                }
            }
        }
        .navigationBarItems(
            leading:
                Button {
                    if model.addNewBox {
                        model.selectedOption = .draw
                        model.cancelTextView()
                    } else {
                        undoManager?.undo()
                    }
                } label: {
                    if model.addNewBox {
                        Text("Cancel")
                    } else {
                        Image("undo")
                            .renderingMode(.template)
                    }
                }
                .disabled(model.addNewBox ? false : !canUndo)
                .onReceive(undoObserver) { _ in
                    self.canUndo = self.undoManager!.canUndo
                }
            ,
            
            trailing:
                Button {
                    if model.addNewBox {
//                        model.selectedOption = .draw
                        model.textBoxes[model.currentIndex].isAdded = true
                        // TODO: show ToolPicker
                        withAnimation {
                            model.addNewBox = false
                        }
                    } else {
                        model.canvas.drawing = PKDrawing()
                        undoManager?.removeAllActions()
                        undoManager?.undo()
                    }
                } label: {
                    if model.addNewBox {
                        Text("Done")
                            .fontWeight(.semibold)
                    } else {
                        Text("Clear All")
                    }
                }
                .disabled(model.addNewBox ? false : !canUndo)
                .onReceive(undoObserver) { _ in
                    self.canUndo = self.undoManager!.canUndo
                }
            
        )
    }
}

struct DrawingScreen_Previews: PreviewProvider {
    static var previews: some View {
        Home(isAuthorized: true)
    }
}


struct CanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            canvas.drawingPolicy = .anyInput
        } else {
            canvas.allowsFingerDrawing = true
        }
        
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
        }
        
        return canvas
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        
    }
}
