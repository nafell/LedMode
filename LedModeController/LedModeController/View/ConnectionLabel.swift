import Foundation
import SwiftUI

struct ConnectionLabel: View {
    var name: String
    var isConnected: Bool
    
    var body: some View {
        VStack{
            Text(name)
            Text(isConnected ? "接続済み" : "未接続")
                .foregroundColor(isConnected ? .blue : .red)
        }
    }
}
