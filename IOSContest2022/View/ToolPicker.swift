//
//  ToolPicker.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 27.10.2022.
//

import SwiftUI
import PencilKit

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
    
    @State var changesMade: Bool = false
    @State private var selectedOption: Options = .draw
    @State private var selectedTool: Tools = .pen
    
    
    var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .bottom) {
                switch selectedOption {
                case .draw:
                    if model.tools[selectedTool.index].isDrawing {
                        Slider(value: $model.tools[selectedTool.index].width, in: 2...24.0, onEditingChanged: { flag in
                            if !flag {
                                model.tools[selectedTool.index].tool = PKInkingTool(
                                    model.tools[selectedTool.index].inkType!,
                                    color: model.tools[selectedTool.index].color!.uiColor(),
                                    width: model.tools[selectedTool.index].width
                                )
                                model.canvas.tool = model.tools[selectedTool.index].tool
                            }
                        })
                        .padding(.bottom, 130)
                    }
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
                            .scaleEffect(selectedTool == tool ? 1.05 : 1.0)
                            .offset(y: selectedTool == tool ? -15 : 0)
                            .onTapGesture {
                                withAnimation {
                                    if selectedTool == tool {
                                        
                                    } else {
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
                        
                        Spacer()
                        Image("add")
                            .renderingMode(.template)
                            .background(Circle().opacity(0.1))
                    }
                    .padding(.bottom, 15)
                case .text:
                    Circle()
                }
                HStack(alignment: .bottom) {
                    Image("cancel")
                        .renderingMode(.template)
                    
                    Picker("Picker", selection: $selectedOption.animation()) {
                        ForEach(Options.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    .background(Color("appearence").blur(radius: 1))
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 8)
                    .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 0, y: -16)
                    .shadow(color: Color("appearence").opacity(0.5), radius: 8, x: 0, y: 16)
                    
                    Image("download")
                        .renderingMode(.template)
                        .opacity(changesMade ? 1.0 : 0.3)
                        .disabled(!changesMade)
                }
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
            }
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    
}

struct ToolView: View {
    let base: String
    let tip: String?
    let color: Color?
    let padding: CGFloat?
    let isDrawing: Bool
    
    @Binding var toolSize: CGFloat
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(base)
                .resizable()
                .aspectRatio(contentMode: .fit)
            if isDrawing {
                Image(tip!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(color!)
                RoundedRectangle(cornerRadius: 1, style: .continuous)
                    .fill(color!)
                    .frame(width: 18.5, height: toolSize, alignment: .top)
                    .padding(.top, padding!)
            }
        }
        .frame(height: 97)
        .padding(.horizontal, 8)
    }
}

struct ToolPicker_Previews: PreviewProvider {
    static var previews: some View {
        ToolPicker()
    }
}
