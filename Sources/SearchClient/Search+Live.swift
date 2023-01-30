@preconcurrency import AsyncExtensions
import Dependencies
import Foundation
import Product

extension SearchClient: DependencyKey {
    
    public static var liveValue: SearchClient {
        actor SearchHolder {
            
            private let searchChannel: AsyncThrowingBufferedChannel<String, Swift.Error> = .init()
            private let replaySubject: AsyncThrowingReplaySubject<String, Swift.Error> = .init(bufferSize: 1)
            
            public init() {}
            
            func emit(_ text: String) {
                searchChannel.send(text)
            }
            
            func observe() -> AnyAsyncSequence<String> {
                searchChannel
                    .multicast(replaySubject)
                    .autoconnect()
                    .eraseToAnyAsyncSequence()
            }
            
        }
        let searchHolder = SearchHolder()
        
        return Self.init(
            sendSearchInput: {
            await searchHolder.emit($0)
        },
            observeSearchInput: {
                print("OBserving search")
            return await searchHolder.observe()
        })
    }
}
