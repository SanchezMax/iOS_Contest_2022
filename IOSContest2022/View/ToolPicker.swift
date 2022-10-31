//
//  ToolPicker.swift
//  IOSContest2022
//
//  Created by Maksim Zykin on 27.10.2022.
//

import SwiftUI
import PencilKit
import Lottie

struct ToolPicker: View {
    @EnvironmentObject var model: DrawingViewModel
    
    //    @State private var selectedOption: Options = .draw
    @State private var selectedTool: Tools = .pen
    @State private var selectedEraser: Eraser = .bitmap
    
    @State var animationView = LottieAnimationView(name: "backToCancel")
    @State var isItemSelected: Bool = false
    
    @State var showColorPicker: Bool = false
    @State var showWidthIndicator: Bool = false
    
    @Binding var canUndo: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    switch model.selectedOption {
                    case .draw:
                        HStack {
                            Button {
                                showColorPicker.toggle()
                            } label: {
                                ZStack {
                                    PickerGradient()
                                    Circle()
                                        .fill(model.tools[selectedTool.index].color?.opacity(model.tools[selectedTool.index].opacity) ?? .white)
                                        .frame(width: 19, height: 19)
                                }
                                .padding(1.5)
                            }
                            .disabled(selectedTool == .lasso || selectedTool == .eraser)
                            
                            Spacer()
                            
                            ToolsView(
                                animationView: $animationView,
                                selectedTool: $selectedTool,
                                isItemSelected: $isItemSelected
                            )
                            .environmentObject(model)
                            
                            Spacer()
                            Button {
                                model.unavailableAlert()
                            } label: {
                                Image("add")
                                    .renderingMode(.template)
                                    .background(Circle().opacity(0.1))
                            }
                        }
                        .padding(.bottom, 15)
                    case .text:
                        HStack {
                            Button {
                                showColorPicker.toggle()
                            } label: {
                                ZStack {
                                    PickerGradient()
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 19, height: 19)
                                }
                                .padding(1.5)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 47)
                    }
                    HStack(alignment: .bottom) {
                        Button {
                            if isItemSelected {
                                animationView.play(fromProgress: 0.0, toProgress: 0.5)
                                withAnimation {
                                    isItemSelected.toggle()
                                }
                            } else {
                                if canUndo || !model.textBoxes.isEmpty {
                                    model.unsavedAlert()
                                } else {
                                    model.cancelImageEditing()
                                }
                            }
                        } label: {
                            LottieView(animationView: $animationView)
                                .frame(width: 33, height: 33)
                                .onAppear {
                                    animationView.play(toProgress: 0.5)
                                }
                        }
                        .background(Color("appearence").blur(radius: 2).frame(width: 50).offset(x: -10))
                        .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: -16, y: 0)
                        .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 16, y: 0)
                        .zIndex(1.3)
                        
                        if isItemSelected {
                            if model.tools[selectedTool.index].isDrawing {
                                HStack {
                                    Spacer()
                                    CustomSlider(value: $model.tools[selectedTool.index].width, in: 2...24, onEditingChanged: { flag in
                                        if flag {
                                            withAnimation {
                                                showWidthIndicator = true
                                            }
                                        } else {
                                            withAnimation {
                                                showWidthIndicator = false
                                            }
                                            model.tools[selectedTool.index].tool = PKInkingTool(
                                                model.tools[selectedTool.index].inkType!,
                                                color: model.tools[selectedTool.index].color!.opacity(model.tools[selectedTool.index].opacity).uiColor(),
                                                width: model.tools[selectedTool.index].width
                                            )
                                            model.canvas.tool = model.tools[selectedTool.index].tool
                                        }
                                    }, track: {
                                        SliderBack()
                                            .foregroundColor(.white.opacity(0.2))
                                            .frame(width: 240, height: 24)
                                    }, fill: {
                                        EmptyView()
                                    }, thumb: {
                                        Circle()
                                            .foregroundColor(.white)
                                            .shadow(radius: 33 / 1)
                                    }, thumbSize: CGSize(width: 33, height: 33))
                                    Spacer()
                                    Button {
                                        model.unavailableAlert()
                                    } label: {
                                        HStack {
                                            Text("Round")
                                            Circle()
                                                .frame(width: 17, height: 17)
                                        }
                                    }
                                }
                                .modifier(CustomBackground())
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            } else {
                                HStack {
                                    Spacer()
                                    
                                    Picker("Picker",
                                           selection: $selectedEraser.animation().onChange({ type in
                                        switch type {
                                        case .bitmap:
                                            model.tools[selectedTool.index].eraserType = .bitmap
                                            model.tools[selectedTool.index].base = "eraser.base"
                                        case .blur:
                                            switch model.tools[selectedTool.index].eraserType! {
                                            case .vector:
                                                selectedEraser = .vector
                                            case .bitmap:
                                                selectedEraser = .bitmap
                                            @unknown default:
                                                fatalError()
                                            }
                                            model.unavailableAlert()
                                        case .vector:
                                            model.tools[selectedTool.index].eraserType = .vector
                                            model.tools[selectedTool.index].base = "objectEraser"
                                        }
                                        model.canvas.tool = PKEraserTool(model.tools[selectedTool.index].eraserType!)
                                    })) {
                                        ForEach(Eraser.allCases) { option in
                                            Text(option.title).tag(option)
                                                .disabled(true)
                                        }
                                    }
                                }
                                .modifier(CustomBackground())
                            }
                        } else {
                            HStack {
                                Picker("Picker",
                                       selection: $model.selectedOption
                                    .animation()
                                    .onChange{ option in
                                        switch option {
                                        case .draw:
                                            model.cancelTextView()
                                        case .text:
                                            model.textBoxes.append(TextBox())
                                            
                                            model.currentIndex = model.textBoxes.count - 1
                                            
                                            withAnimation {
                                                model.addNewBox.toggle()
                                            }
                                            // TODO: closing ToolPicker
                                        }
                                    }) {
                                        ForEach(Options.allCases) { option in
                                            Text(option.title).tag(option)
                                        }
                                    }
                                    .background(Color("appearence").blur(radius: 1))
                                    .pickerStyle(.segmented)
                                    .padding(.horizontal, 8)
                                    .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 0, y: -16)
                                    .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 0, y: 16)
                                
                                Button {
                                    model.saveImage()
                                } label: {
                                    Image("download")
                                        .renderingMode(.template)
                                }
                                .disabled(!(canUndo || (!model.textBoxes.isEmpty && !model.addNewBox)))
                            }
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .onAppear() {
                model.canvas.tool = model.tools[0].tool
            }
            .padding(.horizontal, 8)
            .modifier(CustomBackground())
            if showWidthIndicator {
                Circle()
                    .fill(model.tools[selectedTool.index].color!.opacity(model.tools[selectedTool.index].opacity))
                    .frame(width: model.tools[selectedTool.index].width)
                    .transition(.opacity)
            }
            ZStack {
                if showColorPicker {
                    switch model.selectedOption {
                    case .draw:
                        ColorPicker(selectedColor: $model.tools[selectedTool.index].color, selectedOpacity: $model.tools[selectedTool.index].opacity, show: $showColorPicker)
                            .padding(.top, UIScreen.main.bounds.size.height * 0.15)
                            .transition(.move(edge: .bottom))
                            .animation(.default.speed(0.7))
                            .onDisappear {
                                model.tools[selectedTool.index].tool = PKInkingTool(
                                    model.tools[selectedTool.index].inkType!,
                                    color: model.tools[selectedTool.index].color!.opacity(model.tools[selectedTool.index].opacity).uiColor(),
                                    width: model.tools[selectedTool.index].width
                                )
                                model.canvas.tool = model.tools[selectedTool.index].tool
                            }
                    case .text:
                        ColorPicker(selectedColor: $model.textBoxes[model.currentIndex].textColor, selectedOpacity: $model.textBoxes[model.currentIndex].textOpacity, show: $showColorPicker)
                            .padding(.top, UIScreen.main.bounds.size.height * 0.15)
                            .transition(.move(edge: .bottom))
                            .animation(.default.speed(0.7))
                    }
                }
            }
            .zIndex(2.0)
        }
    }
}

struct CustomBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8), Color.black]), startPoint: .top, endPoint: .bottom))
                        .frame(height: UIScreen.main.bounds.size.height * 0.17)
                        .zIndex(1.3)
                }
                    .edgesIgnoringSafeArea(.all)
            )
    }
}

struct ToolPicker_Previews: PreviewProvider {
    static var previews: some View {
        Home(isAuthorized: true)
    }
}

struct PickerGradient: View {
    let colors = [
        Color("gradient.1"),
        Color("gradient.2"),
        Color("gradient.3"),
        Color("gradient.4"),
        Color("gradient.5"),
        Color("gradient.6"),
        Color("gradient.7"),
        Color("gradient.8"),
        Color("gradient.1")
    ]
    
    var body: some View {
        Circle()
            .stroke(
                AngularGradient(
                    colors: colors,
                    center: .center, angle: Angle(degrees: 90)),
                lineWidth: 3
            )
            .frame(width: 30, height: 30)
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
            })
    }
}
