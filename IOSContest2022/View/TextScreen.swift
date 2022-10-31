//
//  TextScreen.swift
//  IOSContest2022
//
//  Created by Maksim Zykin on 30.10.2022.
//

import SwiftUI

struct TextScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
            if model.addNewBox {
                HStack {
                    CustomSlider(
                        value: $model.textBoxes[model.currentIndex].fontSize,
                        in: 10...50,
                        track: {
                            SliderBack()
                                .foregroundColor(.white.opacity(0.2))
                                .frame(width: 240, height: 24)
                        },
                        fill: {
                            EmptyView()
                        },
                        thumb: {
                            Circle()
                                .foregroundColor(.white)
                                .shadow(radius: 33 / 1)
                        },
                        thumbSize: CGSize(width: 33, height: 33)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 33, height: 240)
                    .offset(CGSize(width: -16, height: 0))
                    .transition(.move(edge: .leading))
                    
                    TextField("Type here", text: $model.textBoxes[model.currentIndex].text)
                        .font(.system(size: model.textBoxes[model.currentIndex].fontSize, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                        .foregroundColor(model.textBoxes[model.currentIndex].textColor?.opacity(model.textBoxes[model.currentIndex].textOpacity))
                        .padding()
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

struct TextScreen_Previews: PreviewProvider {
    static var previews: some View {
        Home(isAuthorized: true)
    }
}
