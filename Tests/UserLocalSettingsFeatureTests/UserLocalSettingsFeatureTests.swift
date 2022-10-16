import XCTest
@testable import UserLocalSettingsFeature
import ComposableArchitecture
import UserModel


@MainActor
final class UserLocalSettingsFeatureTests: XCTestCase {
    
    let mainQueue = DispatchQueue.test
    
    func testTrivial() throws {
        XCTAssert(true)
    }
    //
    func test__GIVEN__initial_state__WHEN__nextStepButtonIsPressed__THEN__delegate_user_to_next_step() async throws {
        
        let store = TestStore(
            initialState: .init(user: User(email: "test@test.se", password: "test123", jwt: "")), //GIVEN initial state
            reducer: UserLocalSettings())
        
        _ = await store.send(.internal(.nextStep))
        await store.receive(.delegate(.nextStep(store.state.user)))
        }
}
