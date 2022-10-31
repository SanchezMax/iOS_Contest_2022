//
//  ToolsView.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 31.10.2022.
//

import SwiftUI
import PencilKit
import Lottie

struct ToolsView: View {
    @EnvironmentObject var model: DrawingViewModel
    
    @Binding var animationView: LottieAnimationView
    @Binding var selectedTool: Tools
    @Binding var isItemSelected: Bool
    
    var body: some View {
        ForEach(Tools.allCases) { tool in
            if !isItemSelected || (isItemSelected && selectedTool == tool) {
                ToolView(
                    base: model.tools[tool.index].base,
                    tip: model.tools[tool.index].tip,
                    color: model.tools[tool.index].color?.opacity(model.tools[tool.index].opacity),
                    padding: model.tools[tool.index].padding,
                    isDrawing: model.tools[tool.index].isDrawing,
                    toolSize: $model.tools[tool.index].width
                )
                .scaleEffect(selectedTool == tool ? (isItemSelected ? 2.0 : 1.05) : 1.0)
                .offset(y: selectedTool == tool ? -15 : 0)
                .transition(.scale)
                .onTapGesture {
                    withAnimation {
                        if selectedTool == tool && selectedTool != .lasso {
                            if !isItemSelected {
                                animationView.play(fromProgress: 0.5, toProgress: 1.0)
                                isItemSelected = true
                            }
                        } else {
                            if !isItemSelected {
                                if tool != .neon {
                                    selectedTool = tool
                                    if model.tools[tool.index].isDrawing {
                                        model.canvas.tool = PKInkingTool(
                                            model.tools[tool.index].inkType!,
                                            color: model.tools[tool.index].color!.opacity(model.tools[tool.index].opacity).uiColor(),
                                            width: model.tools[tool.index].width
                                        )
                                    } else if model.tools[tool.index].eraserType == nil {
                                        model.canvas.tool = PKLassoTool()
                                    } else {
                                        model.canvas.tool = PKEraserTool(model.tools[tool.index].eraserType!)
                                    }
                                } else {
                                    model.unavailableAlert()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        Home(isAuthorized: true)
    }
}
