import XCTest
@testable import SignInFeature
import ComposableArchitecture
import URLRoutingClient
import UserModel

fileprivate extension DependencyValues {
    mutating func setUpDefaults() {
        self.urlRoutingClient = .failing
    }
}

@MainActor
final class SignInFeatureTests: XCTestCase {
    
    let mainQueue = DispatchQueue.test
    
    func testTrivial() throws {
        XCTAssert(true)
    }
//
    func test__GIVEN__initial_state__WHEN__emailAddressFieldReceivesInput__THEN__state_email_updates() async throws {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignIn())
        
        //         WHEN emailAddressFieldReceivingInput
        //        // THEN state.email is updated
        _ = await store.send(.internal(.emailAddressFieldReceivingInput(text: "test123"))) {
            $0.email = "test123"
        }
    }
    
    func test__GIVEN__initial_state__WHEN__passwordFieldReceivesInput__THEN__state_password_updates() async throws {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignIn())
        
        //         WHEN passwordFieldReceivingInput
        //        // THEN state.password is updated
        _ = await store.send(.internal(.passwordFieldReceivingInput(text: "test123"))) {
            $0.password = "test123"
        }
    }


    func test__GIVEN__initial_state__WHEN__loginButtonPressed__THEN__set_loginInFlight_true_and_set_User_with_email_and_password_and_then_send_loginRequest_to_server() async throws  {
        //
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignIn())
        //
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        
        let user = User(email: "test@test", password: "test123", jwt: "")
        
        store.dependencies.urlRoutingClient.override(.login(user), with: {
            return Result(data: Data(), URLResponse)
        }
                                                     )
        
        await store.send(.internal(.loginButtonPressed)) {
            $0.isLoginInFlight = true
            $0.user = User(email: $0.email, password: $0.password, jwt: "")
        }
        await mainQueue.advance()
        
       _ = await store.send(.internal(.loginResponse(
            TaskResult {
                try await store.dependencies.urlRoutingClient.decodedResponse(for: .login(store.state.user!)).value
            }
            )
            )
            )
    }
//
//        let hasIsLoggedInBeenCalled = ActorIsolated(false)
//        store.dependencies.userDefaultsClient.boolForKey = { _ in
//            await hasIsLoggedInBeenCalled.setValue(true)
//            return false
//        }
//
//        // WHEN onAppear
//        _ = await store.send(.internal(.onAppear))
//        await self.mainQueue.advance(by: .seconds(1))
//        await store.receive(.delegate(.loadIsLoggedInResult(.notLoggedIn)))
//
//        // THEN calls isLoggedIn
//        await hasIsLoggedInBeenCalled.withValue({
//            XCTAssertTrue($0)
//        })
//    }
//
//    func test__GIVEN__delegate_action_is_sent__WHEN__delegate_action_is_handled__THEN__do_nothing() async {
//
//
//        let store = TestStore(initialState: .init(), reducer: Splash())
//        
//        //GIVEN delegate action is sent
//        //WHEN received
//        _ = await store.send(.delegate(.loadIsLoggedInResult(.isLoggedIn)))
//
//        // THEN do nothing
//
//    }
//
}
