import Foundation
import SwiftUI

struct ColorButton: View {
    var color: ColorModel
    var action: (ColorModel) -> Void
    var isSelected: Bool
    
    var body: some View {
        Button(action: {
            action(color)
        }) {
            Text(color.label)
                .foregroundColor(
                    isSelected ? Color.white : Color.black
                )
                .frame(width: 170, height: 80)
                .font(
                    .system(size: 24, weight: isSelected ? .black : .regular, design:.rounded)
                )

        }
        .background(
            isSelected ? Color(red: Double(color.red)/255, green: Double(color.green)/255, blue: Double(color.blue)/255) : Color.white
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(lineWidth: 4)
                .fill(
                    isSelected ? Color.white : Color(red: Double(color.red)/255, green: Double(color.green)/255, blue: Double(color.blue)/255)
                )
        }
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .padding([.leading, .trailing], 6)
        .padding([.top, .bottom], 6)
        .onHover(perform: { isHovered in
            if (isHovered) {
                print("Hover/Gaze:", color.label)
                action(color)
            }
        })
            
    }
}
