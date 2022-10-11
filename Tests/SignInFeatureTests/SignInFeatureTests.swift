import XCTest
@testable import SignInFeature
import ComposableArchitecture
import URLRoutingClient
import UserModel
import SiteRouter
import VaporRouting
import Vapor

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
    
    func test__GIVEN__initial_state__WHEN__loginButtonPressed__THEN__set_loginInFlight_true_and_set_User_with_email_and_password_and_then_send_loginRequest_to_server_mock_get_successful_login_back() async throws  {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignIn())
        
        let user = User(email: "test@test", password: "test123", jwt: "")
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        let apiClientTest = URLRoutingClient<SiteRoute>
            .failing
            .override(.login(user),
                      with: {
                try .ok(ResultPayload(forAction: "login", payload: "JWT"))
            }
            )
        
        // WHEN loginButtonPressed
        let task = await store.send(.internal(.loginButtonPressed)) {
            $0.isLoginInFlight = true
            $0.user = User(email: $0.email, password: $0.password, jwt: "")
        }
        
        let request = await store.send(.internal(.loginResponse(
            TaskResult {
                try await apiClientTest.decodedResponse(
                    for: .login(User(email: "test@test", password: "test123", jwt: "")),
                    as:  ResultPayload<String>.self).value.status.get()}))
        ) {
            $0.isLoginInFlight = false
        }
        
        let hasUserJwtBeenSetToJWT = ActorIsolated("")
        store.dependencies.userDefaultsClient.setJWT = { _ , _ in
            await hasUserJwtBeenSetToJWT.setValue("JWT")
            return
        }
        
        _ = await store.send(.delegate(.userLoggedIn(jwt: "JWT")))
        
        //
        await hasUserJwtBeenSetToJWT.withValue {
            XCTAssertEqual($0, "")
        }
        await task.cancel()
        await request.cancel()
    }
    
    func test__GIVEN__initial_state__WHEN__loginButtonPressed__THEN__set_loginInFlight_true_and_set_User_with_email_and_password_and_then_send_loginRequest_to_server_mock_get_failure_back() async throws  {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignIn())
        
        let user = User(email: "test@test", password: "test123", jwt: "")
        store.dependencies.mainQueue = mainQueue.eraseToAnyScheduler()
        let apiClientTest = URLRoutingClient<SiteRoute>
            .failing
            .override(.login(user),
                      with: {
                try .ok(ResultPayload(forAction: "login", payload: "JWT"))
            }
            )
        
        // WHEN loginButtonPressed
        let task = await store.send(.internal(.loginButtonPressed)) {
            $0.isLoginInFlight = true
            $0.user = User(email: $0.email, password: $0.password, jwt: "")
        }
        
        let request = await store.send(.internal(.loginResponse(
            TaskResult {
                try await apiClientTest.decodedResponse(
                    for: .login(User(email: "test@test", password: "test123", jwt: "")),
                    as:  ResultPayload<String>.self).value.status.get()}))
        ) {
            $0.isLoginInFlight = false
        }
        
        let hasUserJwtBeenSetToJWT = ActorIsolated("")
        store.dependencies.userDefaultsClient.setJWT = { _ , _ in
            await hasUserJwtBeenSetToJWT.setValue("")
            return
        }
        
        _ = await store.send(.internal(.loginResponse(.failure(ClientError.failedToLogin("Failed to login"))))) {
            $0.alert = .init(title: TextState("Error"), message: TextState("The operation couldn’t be completed. (UserModel.ClientError error 0.)"), dismissButton: .cancel(TextState("Dismiss"), action: .none))
        }
   
        //
        await hasUserJwtBeenSetToJWT.withValue {
            XCTAssertEqual($0, "")
        }
        await task.cancel()
        await request.cancel()
    }
    
    func test__GIVEN__initial_state__WHEN__signUpButtonIsPressed__THEN___do_nothing() async throws {
        
        let store = TestStore(
            initialState: .init(), //GIVEN initial state
            reducer: SignIn())
        
        _ = await store.send(.internal(.signUpButtonPressed))
        await store.receive(.delegate(.userPressedSignUp))
    }
    
    func test__GIVEN__alert_state__WHEN__signUpButtonIsPressed__THEN___do_nothing() async throws {
        
        let store = TestStore(
            initialState: .init(alert: .init(title: TextState("Error"), message: TextState("The operation couldn’t be completed. (UserModel.ClientError error 0.)"), dismissButton: .cancel(TextState("Dismiss"), action: .none)), //GIVEN initial state
                                reducer: SignIn()))
        
        _ = await store.send(.internal(.signUpButtonPressed))
        await store.receive(.delegate(.userPressedSignUp))
    }
}
