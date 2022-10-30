//
//  TextScreen.swift
//  IOSContest2022
//
//  Created by Aleksey Novikov on 30.10.2022.
//

import SwiftUI

struct TextScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        Color.black.opacity(0.75)
            .edgesIgnoringSafeArea(.all)
        if model.addNewBox {
            HStack {
                CustomSlider(
                    value: $model.textBoxes[model.currentIndex].fontSize,
                    in: 10...50,
                    onEditingChanged: { flag in
                        
                    },
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
                .transition(.move(edge: .leading))
                .zIndex(1.1)
                
                TextField("Type here", text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: model.textBoxes[model.currentIndex].fontSize, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.textBoxes[model.currentIndex].textColor)
                    .padding()
            }
            .frame(alignment: .leading)
        }
        
//        HStack {
            
            //                    Button {
            //                        model.textBoxes[model.currentIndex].isBold.toggle()
            //                    } label: {
            //                        Text(model.textBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
            //                            .fontWeight(.bold)
            //                            .foregroundColor(.white)
            //                    }
            
//            Button {
//                model.cancelTextView()
//            } label: {
//                Text("Cancel")
//                    .font(.system(size: 17, weight: .regular))
//                    .foregroundColor(.white)
//                    .padding()
//            }
//            Spacer()
//            Button {
//                model.textBoxes[model.currentIndex].isAdded = true
//                // TODO: show ToolPicker
//                withAnimation {
//                    model.addNewBox = false
//                }
//            } label: {
//                Text("Done")
//                    .font(.system(size: 17, weight: .semibold))
//                    .foregroundColor(.white)
//                    .padding()
//            }
//        }
        // TODO: ColorPicker
//        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct TextScreen_Previews: PreviewProvider {
    static var previews: some View {
        TextScreen()
    }
}
