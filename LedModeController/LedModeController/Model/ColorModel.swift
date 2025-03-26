import Foundation

struct ColorModel : Identifiable {
    var id: String
    var label: String
    var red: UInt8
    var green: UInt8
    var blue: UInt8
}

struct ColorPair : Identifiable {
    var id: UUID
    var colorLeft : ColorModel
    var colorRight : ColorModel
    
    init(_ colorLeft: ColorModel, _ colorRight: ColorModel) {
        self.id = UUID()
        self.colorLeft = colorLeft
        self.colorRight = colorRight
    }
}

struct ColorQuad : Identifiable {
    var id: UUID
    var color1 : ColorModel
    var color2 : ColorModel
    var color3 : ColorModel
    var color4 : ColorModel
    
    init(_ color1: ColorModel, _ color2: ColorModel, _ color3: ColorModel, _ color4: ColorModel) {
        self.id = UUID()
        self.color1 = color1
        self.color2 = color2
        self.color3 = color3
        self.color4 = color4
    }
}
