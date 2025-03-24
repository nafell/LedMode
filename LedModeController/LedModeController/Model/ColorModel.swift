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
