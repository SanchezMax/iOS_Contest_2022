//
//  TextBox.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 27.10.2022.
//

import SwiftUI

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text: String = ""
    var isBold: Bool = false
    
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var angle: Angle = .zero
    var lastAngle: Angle = .zero
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var textColor: Color = .white
    
    var isAdded: Bool = false
}
