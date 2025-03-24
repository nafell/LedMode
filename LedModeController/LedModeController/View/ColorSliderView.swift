import Foundation
import SwiftUI

struct ColorSliderView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ColorControllerView(vm: viewModel)

            ColorPreview(red: viewModel.redValue, green: viewModel.greenValue, blue: viewModel.blueValue)
                .frame(height: 100)
                .cornerRadius(10)
                .padding(.horizontal)

            ColorSlider(value: $viewModel.redValue, color: .red, label: "赤")
            ColorSlider(value: $viewModel.greenValue, color: .green, label: "緑")
            ColorSlider(value: $viewModel.blueValue, color: .blue, label: "青")

            Button(action: {
                viewModel.sendColor()
            }) {
                Text("色を送信")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
