import AsyncExtensions
import Dependencies
import Foundation
import Product

extension SearchClient: DependencyKey {
    
    public static var liveValue: SearchClient {
        actor SearchHolder {
            
            private let searchChannel: AsyncCurrentValueSubject<String> = .init("")
            
            public init() {}
            
            func emit(_ text: String) {
                searchChannel.send(text)
            }
            
            func observe() -> AnyAsyncSequence<String> {
                searchChannel
                    .share()
                    .eraseToAnyAsyncSequence()
            }
            
        }
        let searchHolder = SearchHolder()
        
        return Self.init(
            sendSearchInput: {
            await searchHolder.emit($0)
        },
            observeSearchInput: {
            await searchHolder.observe()
        })
    }
}
