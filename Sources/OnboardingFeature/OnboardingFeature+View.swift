//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-25.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient
import UserModel
import SignUpFeature
import UserInformationFeature
import TermsAndConditionsFeature
import SignInFeature

public extension Onboarding {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Group {
                    switch viewStore.step {
                        
                    case .step0_LoginOrCreateUser:
                        IfLetStore(self.store.scope(
                            state: \.signIn,
                            action: Action.signIn),
                                   then:SignIn.View.init(store:)
                        )

                    case .step1_Welcome:
                            IfLetStore(self.store.scope(
                                state: \.signUp,
                                action: Action.signUp),
                                       then:SignUp.View.init(store:)
                            )

                    case .step2_ChooseUserSettings:
                        IfLetStore(self.store.scope(
                            state: \.userInformation,
                            action: Action.userInformation),
                                   then:UserInformation.View.init(store:)
                        )
                        
                    case .step3_TermsAndConditions:
                        IfLetStore(self.store.scope(
                            state: \.termsAndConditions,
                            action: Action.termsAndConditions),
                                   then:TermsAndConditions.View.init(store:)
                        )
                    }
                }
            }
        }
    }
}


