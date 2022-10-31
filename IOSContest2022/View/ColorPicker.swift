//
//  ColorPicker.swift
//  IOSContest2022
//
//  Created by Maksim Zykin on 31.10.2022.
//

import SwiftUI

enum ColorOptions: String, CaseIterable, Identifiable {
    case grid
    case spectrum
    case sliders
    
    var id: Self {
        self
    }
    
    var title: String {
        switch self {
        case .grid:
            return "Grid"
        case .spectrum:
            return "Spectrum"
        case .sliders:
            return "Sliders"
        }
    }
}

struct ColorPicker: View {
    @EnvironmentObject var model: DrawingViewModel
    
    @State var selectedOption: ColorOptions = .grid
    
    @Binding var selectedColor: Color?
    @Binding var selectedOpacity: Double
    
    @Binding var show: Bool
    
    let colors = ["turquoise", "blue", "plum", "violet",
                  "pink", "red", "orange", "bronze",
                  "golden", "yellow", "olive", "green"]
    let index = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button {
                        model.unavailableAlert()
                    } label: {
                        Image(systemName: "eyedropper")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(12)
                    }
                    Spacer()
                    Text("Colors")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                    Button {
                        show = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(12)
                    }
                }
                
                Picker("Picker", selection: $selectedOption.onChange({ option in
                    switch option {
                    case .grid:
                        break
                    case .spectrum:
                        selectedOption = .grid
                        model.unavailableAlert()
                    case .sliders:
                        selectedOption = .grid
                        model.unavailableAlert()
                    }
                })) {
                    ForEach(ColorOptions.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                
                switch selectedOption {
                case .grid:
                    VStack(spacing: 0) {
                        ForEach(index, id: \.self) { id in
                            HStack(spacing: 0) {
                                ForEach(colors, id: \.self) { color in
                                    Rectangle()
                                        .strokeBorder(
                                            .white,
                                            lineWidth:
                                                selectedColor == Color("\(color).\(id)") ? 3 : 0
                                        )
                                        .background(Rectangle().fill(Color("\(color).\(id)")))
                                        .frame(height: 30)
                                        .onTapGesture {
                                            selectedColor = Color("\(color).\(id)")
                                        }
                                }
                            }
                        }
                    }
                    .cornerRadius(8)
                    .padding(.vertical, 16)
                case .spectrum:
                    EmptyView()
                case .sliders:
                    EmptyView()
                }
                
                HStack {
                    Text("OPACITY")
                        .foregroundColor(.secondary)
                        .font(.system(size: 13, weight: .semibold))
                    Spacer()
                }
                
                HStack {
                    CustomSlider(
                        value: $selectedOpacity,
                        in: 0...1,
                        step: 0.01,
                        onEditingChanged: { value in
                            
                        },
                        track: {
                            ZStack {
                                Image("transparent")
                                Capsule()
                                    .fill(LinearGradient(colors: [.clear, selectedColor!], startPoint: .leading, endPoint: .trailing))
                            }
                        },
                        fill: {
                            EmptyView()
                        },
                        thumb: {
                            ZStack {
                                Circle()
                                    .fill(selectedColor!)
                                    .padding(3.5)
                                Circle()
                                    .stroke(.white, lineWidth: 3)
                                    .foregroundColor(.white)
                                    .padding(3.5)
                            }
                        },
                        thumbSize: CGSize(width: 36, height: 36)
                    )
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(.black)
                            .frame(width: 90, height: 36)
                            .cornerRadius(8)
                        Text(String(Int(selectedOpacity * 100)) + "%")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
                
                Rectangle()
                    .fill(.gray.opacity(0.5))
                    .frame(height: 1)
                    .padding(.vertical, 22)
                
                HStack {
                    ZStack {
                        Rectangle()
                            .rotation(.degrees(45), anchor: .bottomLeading)
                            .scale(sqrt(2), anchor: .bottomLeading)
                            .frame(width: 82, height: 82)
                            .background(Color.black)
                            .foregroundColor(Color.white)
                            .clipped()
                            .cornerRadius(10)
                        
                        Rectangle()
                            .fill(selectedColor!.opacity(selectedOpacity))
                            .frame(width: 82, height: 82)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            .padding(16)
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(selectedColor: .constant(.white), selectedOpacity: .constant(1.0), show: .constant(true))
    }
}
