import XCTest
@testable import AppFeature
@testable import SplashFeature
import ComposableArchitecture

@MainActor
final class TestsOfSplashScopeInAppFeature: XCTestCase {
    func testTrivial() throws {
        XCTAssert(true)
    }
    
    func test__GIVEN__initial_state__WHEN__splash_delegate_receives_action__THEN__send_userIsLoggedIn() async {
        
        let store = TestStore(initialState: App.State(), reducer: App())
        
        let splashStore = TestStore(initialState: .init(), reducer: Splash())
        
        await splashStore.send(.delegate(.loadIsLoggedInResult(.isLoggedIn)))
        
        await store.send(.userIsLoggedIn(.SEK)) {
            $0 = .main(.init(defaultCurrency: "SEK", token: "IMPLEMENT THIS"))
        }
    }
    
    func test__GIVEN__initial_state__WHEN__splash_delegate_receives_action__THEN__send_notLoggedin() async {
        
        let store = TestStore(initialState: App.State(), reducer: App())
        
        let splashStore = TestStore(initialState: .init(), reducer: Splash())
        
        await splashStore.receive(.delegate(.loadIsLoggedInResult(.notLoggedIn)))
//        await store.receive(.onboarding(.internal(.)))
//
//        await splashStore.send(.delegate(.loadIsLoggedInResult(.notLoggedIn))) {
//            $0 = .onboarding(.init(step: .step0_LoginOrCreateUser))
//        }
        
//        }
    }
}
