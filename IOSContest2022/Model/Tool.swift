//
//  Tool.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 29.10.2022.
//

import Foundation
import SwiftUI
import PencilKit

struct Tool {
    var base: String
    let tip: String?
    var color: Color?
    var opacity: Double = 1.0
    let padding: CGFloat?
    var width: CGFloat
    let isDrawing: Bool
    var eraserType: PKEraserTool.EraserType?
    let inkType: PKInkingTool.InkType?
    
    var tool: PKTool
    
    init(base: String, tip: String?, color: Color? = nil, padding: CGFloat?, width: CGFloat, isDrawing: Bool, eraserType: PKEraserTool.EraserType? = nil, inkType: PKInkingTool.InkType?) {
        self.base = base
        self.tip = tip
        self.color = color
        self.padding = padding
        self.width = width
        self.isDrawing = isDrawing
        self.eraserType = eraserType
        self.inkType = inkType
        if isDrawing {
            self.tool = PKInkingTool(inkType!, color: color!.uiColor(), width: width)
        } else if eraserType == nil {
            self.tool = PKLassoTool()
        } else {
            self.tool = PKEraserTool(eraserType!)
        }
    }
}


enum Eraser: String, CaseIterable, Identifiable {
    case bitmap
    case blur
    case vector
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .bitmap:
            return "Pixels"
        case .blur:
            return "Blur"
        case .vector:
            return "Objects"
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

extension Color {
 
    func uiColor() -> UIColor {

        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
