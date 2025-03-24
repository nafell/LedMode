import Foundation
import SwiftUI

struct ColorControllerView: View {
    @ObservedObject var vm: AppViewModel
    
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
    
    private var colorArrays: [ColorPair]
    
    init(vm: AppViewModel) {
        self.vm = vm
        colorArrays = [ColorPair(anshin, tanoshii), ColorPair(hazukashii, ikari), ColorPair(suki, odayaka), ColorPair(kanashii, kowai), ColorPair(off, on)]
    }
    
    var body: some View {
        VStack{
            HStack {
                Circle()
                    .fill(Color(red: Double(vm.selectedColor.red)/255, green: Double(vm.selectedColor.green)/255, blue: Double(vm.selectedColor.blue)/255))
                    .frame(width:30, height: 30)
                Text(vm.selectedColor.label)
                    .font(.title3)
            }.padding(.bottom, 8)
            ForEach(self.colorArrays) { colorArray in
                HStack{
                    ColorButton(color:colorArray.colorLeft, action:vm.sendColor, isSelected: vm.selectedColor.id == colorArray.colorLeft.id)
                    ColorButton(color:colorArray.colorRight, action:vm.sendColor, isSelected: vm.selectedColor.id == colorArray.colorRight.id)
                }
            }
            
        }
    }
}

#Preview {
    ColorControllerView(vm: AppViewModel(bleService: BleService()))
}
