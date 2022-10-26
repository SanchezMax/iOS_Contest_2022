//
//  ContentView.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 25.10.2022.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @Environment(\.undoManager) private var undoManager
        @State private var canvasView = PKCanvasView()

        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    Button("Clear") {
                        canvasView.drawing = PKDrawing()
                    }
                    Spacer()
                    Button("Undo") {
                        undoManager?.undo()
                    }
                    Spacer()
                    Button("Redo") {
                        undoManager?.redo()
                    }
                }
                .padding()
                MyCanvas(canvasView: $canvasView)
            }
        }
}

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
        }
//        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
//        canvasView.tool = PKInkingTool(.marker, color: .yellow, width: 15)
        canvasView.tool = PKInkingTool(.pencil, color: .red, width: 15)
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) { }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
