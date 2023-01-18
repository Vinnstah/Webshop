import SwiftUI
import Foundation
import ComposableArchitecture
import Boardgame

public extension Home.View {
    //Temporary struct for logout button. Will create entire feature later on.
    struct Settings: View {
        public let action: () -> Void
        
        public init(action: @escaping () -> Void) { self.action = action}
        
        public var body: some View {
            Button("Log out user") {
                action()
            }
            .buttonStyle(.primary)
            .padding()
        }
    }
}
