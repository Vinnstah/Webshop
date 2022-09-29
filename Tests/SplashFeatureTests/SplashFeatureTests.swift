import XCTest
@testable import SplashFeature
import ComposableArchitecture

@MainActor
final class SplashFeatureTests: XCTestCase {
    
    let mainQueue = DispatchQueue.test
    
    func testTrivial() throws {
        XCTAssert(true)
    }
    
    func test__GIVEN__initial_state__WHEN__onAppear__THEN__userDefaults_calls_isLoggedIn_mock_isLoggedIn() async throws {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: Splash())
        
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        let hasIsLoggedInBeenCalled = ActorIsolated(false)
        store.dependencies.userDefaultsClient.boolForKey = { _ in
            await hasIsLoggedInBeenCalled.setValue(true)
            return true
        }
        
        // WHEN onAppear
        _ = await store.send(.internal(.onAppear))
        await self.mainQueue.advance(by: .seconds(1))
        await store.receive(.delegate(.loadIsLoggedInResult(.isLoggedIn)))
        
        // THEN calls isLoggedIn
        await hasIsLoggedInBeenCalled.withValue {
            XCTAssertTrue($0)
        }
    }
    
    func test__GIVEN__initial_state__WHEN__onAppear__THEN__userDefaults_calls_isLoggedIn_mock_isNotLoggedIn() async throws {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: Splash())
        
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        let hasIsLoggedInBeenCalled = ActorIsolated(false)
        store.dependencies.userDefaultsClient.boolForKey = { _ in
            await hasIsLoggedInBeenCalled.setValue(true)
            return false
        }
        
        // WHEN onAppear
        _ = await store.send(.internal(.onAppear))
        await self.mainQueue.advance(by: .seconds(1))
        await store.receive(.delegate(.loadIsLoggedInResult(.notLoggedIn)))
        
        // THEN calls isLoggedIn
        await hasIsLoggedInBeenCalled.withValue({
            XCTAssertTrue($0)
        })
    }
    
    func test__GIVEN__delegate_action_is_sent__WHEN__delegate_action_is_handled__THEN__do_nothing() async {
        
        
        let store = TestStore(initialState: .init(), reducer: Splash())
        
        //GIVEN delegate action is sent
        //WHEN received
        _ = await store.send(.delegate(.loadIsLoggedInResult(.isLoggedIn)))
        
        // THEN do nothing
        
    }
    
}
