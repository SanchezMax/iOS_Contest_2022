//
//  ToolPicker.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 27.10.2022.
//

import SwiftUI
import PencilKit
import Lottie

enum Options: String, CaseIterable, Identifiable {
    case draw
    case text
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .draw:
            return "Draw"
        case .text:
            return "Text"
        }
    }
}

enum Eraser: String, CaseIterable, Identifiable {
    case bitmap
    case vector
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .bitmap:
            return "Pixel"
        case .vector:
            return "Object"
        }
    }
}

enum Tools: CaseIterable, Identifiable {
    case pen
    case brush
    case neon
    case pencil
    case lasso
    case eraser
    
    var id: Self {
        self
    }
    
    var index: Int {
        switch self {
        case .pen:
            return 0
        case .brush:
            return 1
        case .neon:
            return 2
        case .pencil:
            return 3
        case .lasso:
            return 4
        case .eraser:
            return 5
        }
    }
}

struct ToolPicker: View {
    @EnvironmentObject var model: DrawingViewModel
    
    @State private var selectedOption: Options = .draw
    @State private var selectedTool: Tools = .pen
    @State private var selectedEraser: Eraser = .bitmap
    
    @State var animationView = LottieAnimationView(name: "backToCancel")
    @State var isItemSelected: Bool = false
    
    @Binding var canUndo: Bool
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .bottom) {
                switch selectedOption {
                case .draw:
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(
                                    AngularGradient(
                                        colors: [
                                            Color("gradient.1"),
                                            Color("gradient.2"),
                                            Color("gradient.3"),
                                            Color("gradient.4"),
                                            Color("gradient.5"),
                                            Color("gradient.6"),
                                            Color("gradient.7"),
                                            Color("gradient.8"),
                                            Color("gradient.1")
                                        ],
                                        center: .center, angle: Angle(degrees: 90)),
                                    lineWidth: 3
                                )
                                .frame(width: 30, height: 30)
                            Circle()
                                .frame(width: 19, height: 19)
                        }
                        .padding(1.5)
                        Spacer()
                        ForEach(Tools.allCases) { tool in
                            ToolView(
                                base: model.tools[tool.index].base,
                                tip: model.tools[tool.index].tip,
                                color: model.tools[tool.index].color,
                                padding: model.tools[tool.index].padding,
                                isDrawing: model.tools[tool.index].isDrawing,
                                toolSize: $model.tools[tool.index].width
                            )
                            .scaleEffect(selectedTool == tool ? (isItemSelected ? 2.0 : 1.05) : (isItemSelected ? 0.0 : 1.0))
                            .offset(y: selectedTool == tool ? -15 : 0)
                            .onTapGesture {
                                withAnimation {
                                    if selectedTool == tool {
                                        if !isItemSelected {
                                            animationView.play(fromProgress: 0.5, toProgress: 1.0)
                                            isItemSelected = true
                                        }
                                    } else {
                                        if !isItemSelected {
                                            selectedTool = tool
                                            if model.tools[tool.index].isDrawing {
                                                model.canvas.tool = PKInkingTool(
                                                    model.tools[tool.index].inkType!,
                                                    color: model.tools[tool.index].color!.uiColor(),
                                                    width: model.tools[tool.index].width
                                                )
                                            } else if model.tools[tool.index].eraserType == nil {
                                                model.canvas.tool = PKLassoTool()
                                            } else {
                                                model.canvas.tool = PKEraserTool(model.tools[tool.index].eraserType!)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        Image("add")
                            .renderingMode(.template)
                            .background(Circle().opacity(0.1))
                    }
                    .padding(.bottom, 15)
                case .text:
                    EmptyView()
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
                    .background(Color("appearence").blur(radius: 2))
                    .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: -16, y: 0)
                    .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 16, y: 0)
                    .zIndex(1.3)
                    
                    if isItemSelected {
                        if model.tools[selectedTool.index].isDrawing {
                            HStack {
                                Spacer()
                                CustomSlider(value: $model.tools[selectedTool.index].width, in: 2...24, onEditingChanged: { flag in
                                    if !flag {
                                        model.tools[selectedTool.index].tool = PKInkingTool(
                                            model.tools[selectedTool.index].inkType!,
                                            color: model.tools[selectedTool.index].color!.uiColor(),
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
                            }
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
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        } else if model.tools[selectedTool.index].eraserType != nil {
                            Picker("Picker",
                                   selection: $selectedEraser.animation().onChange({ type in
                                    switch type {
                                    case .bitmap:
                                        model.tools[selectedTool.index].eraserType = .bitmap
                                    case .vector:
                                        model.tools[selectedTool.index].eraserType = .vector
                                    }
                                model.canvas.tool = PKEraserTool(model.tools[selectedTool.index].eraserType!)
                                })) {
                                    ForEach(Eraser.allCases) { option in
                                        Text(option.title).tag(option)
                                    }
                                }
                                .background(Color("appearence").blur(radius: 1))
                                .pickerStyle(.segmented)
                                .padding(.horizontal, 8)
                                .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 0, y: -16)
                                .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 0, y: 16)
                        } else {
                            Spacer()
                        }
                    } else {
                        HStack {
                            Picker("Picker",
                                   selection: $selectedOption
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
                            .disabled(!canUndo)
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
