import SwiftUI
import Foundation

public extension Home.View {
    
    func gridColumnControl(
        increaseColumns: @escaping () -> Void,
        decreaseColumns: @escaping () -> Void,
        numberOfColumnsInGrid: Int
    ) -> some View {
        
        HStack {
            Spacer()
            
            Text("Columns")
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(alignment: .trailing)
            
            Button(action: { decreaseColumns()  },
                   label: {
                Image(systemName: "minus")
                    .font(.footnote)
                    .foregroundColor(Color("Secondary"))
            })
            Text(String("\(numberOfColumnsInGrid)"))
                .font(.subheadline)
                .foregroundColor(Color("Secondary"))
            
            Button(action: { increaseColumns()  },
                   label: {
                Image(systemName: "plus")
                    .font(.footnote)
                    .foregroundColor(Color("Secondary"))
            })
        }
        .padding(.horizontal)
    }
}

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
