import Foundation
import SwiftUI

struct ColorMatrixControllerView: View {
    @ObservedObject var viewModel: AppViewModel
    
    private var anshin: ColorModel = ColorModel(id: "Orange", label: "安心", red: 251, green: 173, blue: 55)
    private var ureshii: ColorModel = ColorModel(id: "Yellow", label: "嬉しい", red: 247, green: 225, blue: 45)
    private var hottosuru: ColorModel = ColorModel(id: "PaleOrange", label: "ホッとする", red: 237, green: 129, blue: 70)
    private var tanoshii: ColorModel = ColorModel(id: "PaleYellow", label: "楽しい", red: 250, green: 244, blue: 144)
    
    private var iraira: ColorModel = ColorModel(id: "Pink", label: "イライラ", red: 251, green: 114, blue: 131)
    private var hazukashii: ColorModel = ColorModel(id: "Purple", label: "恥ずかしい", red: 156, green: 40, blue: 251)
    private var ikari: ColorModel = ColorModel(id: "Red", label: "怒り", red: 255, green: 59, blue: 55)
    private var yuutsu: ColorModel = ColorModel(id: "DeepPurple", label: "憂鬱", red: 136, green: 35, blue: 251)

    private var suki: ColorModel = ColorModel(id: "Lime", label: "好き", red: 81, green: 251, blue: 40)
    private var odayaka: ColorModel = ColorModel(id: "Green", label: "穏やか", red: 61, green: 241, blue: 113)
    private var hokorashii: ColorModel = ColorModel(id: "PaleLime", label: "誇らしい", red: 144, green: 251, blue: 108)
    private var shinrai: ColorModel = ColorModel(id: "PaleGreen", label: "信頼", red: 97, green: 241, blue: 172)

    private var sabishii: ColorModel = ColorModel(id: "Blue", label: "寂しい", red: 43, green: 149, blue: 249)
    private var fuan: ColorModel = ColorModel(id: "SkyBlue", label: "不安", red: 100, green: 218, blue: 251)
    private var kanashii: ColorModel = ColorModel(id: "DarkBlue", label: "悲しい", red: 86, green: 60, blue: 251)
    private var kowai: ColorModel = ColorModel(id: "DeeoBlue", label: "怖い", red: 55, green: 151, blue: 251)
    
    private var off: ColorModel = ColorModel(id: "Black", label: "オフ", red: 0, green: 0, blue: 0)
    private var on: ColorModel = ColorModel(id: "White", label: "オン", red: 240, green: 240, blue: 240)
    
    private var colorArrays: [ColorQuad]
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        self.colorArrays = [
            ColorQuad(anshin, ureshii, suki, odayaka),
            ColorQuad(hottosuru, tanoshii, hokorashii, shinrai),
            ColorQuad(iraira, hazukashii, sabishii, fuan),
            ColorQuad(ikari, yuutsu, kanashii, kowai),
        ]
    }
    
    var body: some View {
        VStack{
            HStack {
                Circle()
                    .fill(Color(red: Double(viewModel.selectedColor.red)/255, green: Double(viewModel.selectedColor.green)/255, blue: Double(viewModel.selectedColor.blue)/255))
                    .frame(width:30, height: 30)
                Text(viewModel.selectedColor.label)
                    .font(.title3)
            }.padding(.bottom, 8)
            // 通常ボタン
            ForEach(self.colorArrays) { colorArray in
                HStack{
                    ColorButton(color:colorArray.color1, action:viewModel.sendColor, isSelected: viewModel.selectedColor.id == colorArray.color1.id, isThin: true)
                    ColorButton(color:colorArray.color2, action:viewModel.sendColor, isSelected: viewModel.selectedColor.id == colorArray.color2.id, isThin: true)
                    ColorButton(color:colorArray.color3, action:viewModel.sendColor, isSelected: viewModel.selectedColor.id == colorArray.color3.id, isThin: true)
                    ColorButton(color:colorArray.color4, action:viewModel.sendColor, isSelected: viewModel.selectedColor.id == colorArray.color4.id, isThin: true)
                }
   
            }
            HStack{
                ColorButton(color:off, action:viewModel.sendColor, isSelected: viewModel.selectedColor.id == off.id)
                ColorButton(color:on, action:viewModel.sendColor, isSelected: viewModel.selectedColor.id == on.id)
            }
            
        }
    }
}

#Preview {
    ColorMatrixControllerView(viewModel: AppViewModel(bleService: BleService()))
}
