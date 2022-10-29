//
//  Home.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 27.10.2022.
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
                                .navigationBarItems(leading: Button(action: {
                                    model.cancelImageEditing()
                                }, label: {
                                    Image(systemName: "xmark")
                                }))
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
            
            if model.addNewBox {
                Color.black.opacity(0.75)
                    .edgesIgnoringSafeArea(.all)
                
                TextField("Type here", text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.textBoxes[model.currentIndex].textColor)
                    .padding()
                
                HStack {
                    Button {
                        model.textBoxes[model.currentIndex].isAdded = true
                        // TODO: show ToolPicker
                        withAnimation {
                            model.addNewBox = false
                        }
                    } label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        model.textBoxes[model.currentIndex].isBold.toggle()
                    } label: {
                        Text(model.textBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    
                    Spacer()
                    
                    Button {
                        model.cancelTextView()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                // TODO: ColorPicker
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .alert(isPresented: $model.showAlert) {
            Alert(title: Text("Message"), message: Text(model.message), dismissButton: .destructive(Text("Ok")))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//struct Home: View {
//    @Environment(\.undoManager) private var undoManager
//    @State private var canvasView = PKCanvasView()
//
//    @State private var tool: PKTool = PKInkingTool(.pen, color: .black, width: nil)
//    @State private var ink: PKInkingTool.InkType = .pen
//    @State private var color: UIColor = .black
//    @State private var width: CGFloat? = nil
//
//    @State private var angle: Angle = Angle(degrees: 0)
//
//    var body: some View {
//        VStack(spacing: 10) {
//            HStack {
//                Button("Clear") {
//                    canvasView.drawing = PKDrawing()
//
//                }
//                Spacer()
//                Button("Undo") {
//                    undoManager?.undo()
//                }
//                Spacer()
//                Button("Redo") {
//                    undoManager?.redo()
//                }
//            }
//            .padding()
//            ZStack {
//                Image("neon.tip")
//                    .colorMultiply(.blue)
//                Image("neon.base")
//                RoundedRectangle(cornerRadius: 6, style: .continuous)
//                    .fill(.blue)
//                    .frame(width: 102, height: 84)
//                    .offset(x: 0, y: -24)
//            }
//            .scaledToFit()
//            .frame(width: 100, height: 100)
//            MyCanvas(canvasView: $canvasView)
//                .rotationEffect(angle)
//                .gesture(
//                    RotationGesture()
//                        .onChanged({ value in
//                            angle = value
//                        })
//                )
//            HStack(spacing: 30) {
//                Button {
//                    ink = .pen
//                    tool = PKInkingTool(ink, color: color, width: width)
//                    canvasView.tool = tool
//                } label: {
//                    Text("1")
//                }
//                Button {
//                    ink = .marker
//                    tool = PKInkingTool(ink, color: color, width: width)
//                    canvasView.tool = tool
//                } label: {
//                    Text("2")
//                }
//                Button {
//                    ink = .pencil
//                    tool = PKInkingTool(ink, color: color, width: width)
//                    canvasView.tool = tool
//                } label: {
//                    Text("3")
//                }
//                Button {
//                    tool = PKLassoTool()
//                    canvasView.tool = tool
//                } label: {
//                    Text("4")
//                }
//                Button {
//                    tool = PKEraserTool(.bitmap)
//                    canvasView.tool = tool
//                } label: {
//                    Text("5")
//                }
//                Button {
//                    tool = PKEraserTool(.vector)
//                    canvasView.tool = tool
//                } label: {
//                    Text("6")
//                }
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(20)
//            .shadow(radius: 10)
//        }
//    }
//}
