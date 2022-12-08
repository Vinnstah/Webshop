import IdentifiedCollections
import Foundation
import SwiftUI

public struct StaggeredGrid<Content: View,T: Identifiable>: View where T: Hashable {
    
    public var list: IdentifiedArrayOf<T>
    public let columns: Int
    public let content: (T) -> Content
    
    public init(
        list: IdentifiedArrayOf<T>,
        columns: Int,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.list = list
        self.columns = columns
        self.content = content
    }
    
    func setupGrid() -> [IdentifiedArrayOf<T>] {
        var gridArray: [IdentifiedArrayOf<T>] = Array(repeating: [], count: columns)
        var currentIndex = 0
        
        for object in list {
            gridArray[currentIndex].append(object)
            
            if currentIndex == (columns - 1){
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        return gridArray
    }
    
    public var body: some View {
        
        ScrollView(.vertical) {
            
            HStack(alignment: .top) {
                
                ForEach(setupGrid(), id: \.self) { columns in
                    LazyVStack(spacing: 10) {
                        ForEach(columns, id:\.self) { object in
                            content(object)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

