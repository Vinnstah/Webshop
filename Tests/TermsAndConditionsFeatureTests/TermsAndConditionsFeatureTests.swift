import XCTest
@testable import TermsAndConditionsFeature
import ComposableArchitecture
import UserModel


@MainActor
final class TermsAndConditionsFeatureTests: XCTestCase {
    
    let mainQueue = DispatchQueue.test
    
    func testTrivial() throws {
        XCTAssert(true)
    }
    //
    func test__GIVEN__initial_state__WHEN__finishSignUpButtonPressed__THEN__send_createUserRequest() async throws {
        
        
        let store = TestStore(
            initialState: .init(user: User(email: "test@test.se", password: "test123", jwt: "")), //GIVEN initial state
            reducer: TermsAndConditions())
        
        
        _ = await store.send(.internal(.finishSignUpButtonPressed))
        await store.receive(.internal(.finishSignUp))
        
        await store.receive(.internal(.createUserRequest(store.state.user)))
        
//        await store.receive(.internal(.createUserRequest(store.state.user)))
        await store.finish()
        }
}
