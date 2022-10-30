//
//  ToolView.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 30.10.2022.
//

import SwiftUI

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

struct ToolView_Previews: PreviewProvider {
    static var previews: some View {
        Home(isAuthorized: true)
    }
}
