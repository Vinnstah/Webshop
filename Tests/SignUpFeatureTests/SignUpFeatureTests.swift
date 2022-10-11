import XCTest
@testable import SignUpFeature
import ComposableArchitecture
import UserModel


@MainActor
final class SignUpFeatureTests: XCTestCase {
    
    let mainQueue = DispatchQueue.test
    
    func testTrivial() throws {
        XCTAssert(true)
    }
    //
    func test__GIVEN__initial_state__WHEN__emailAddressFieldReceivesInput__THEN__state_email_updates() async throws {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignUp())
        
        //         WHEN emailAddressFieldReceivingInput
        //        // THEN state.email is updated
        _ = await store.send(.internal(.emailAddressFieldReceivingInput(text: "test123"))) {
            $0.email = "test123"
        }
    }
    
    func test__GIVEN__initial_state__WHEN__passwordFieldReceivesInput__THEN__state_password_updates() async throws {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignUp())
        
        //         WHEN passwordFieldReceivingInput
        //         THEN state.password is updated
        _ = await store.send(.internal(.passwordFieldReceivingInput(text: "test123"))) {
            $0.password = "test123"
        }
    }
    
    func test__GIVEN__email_and_password_filled_in__WHEN__nextStep_button_pressed__THEN__state_user_is_set_with_email_and_password() async throws {
        
        let store = TestStore(
            initialState: .init(email: "test@test.se", password: "test123"), //GIVEN email and password set
            reducer: SignUp())
        
        //WHEN nextStep is pressed
        _ = await store.send(.internal(.nextStep)) {
            //THEN set state.user with email and password and then delegate action
            $0.user = User(email: "test@test.se", password: "test123", jwt: "")
        }
        
        await store.receive(.delegate(.goToNextStep(store.state.user!)))
    }
}
