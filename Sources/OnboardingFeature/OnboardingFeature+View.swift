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
import WelcomeFeature
import UserInformationFeature
import TermsAndConditionsFeature
import LoginFeature

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
                            state: \.login,
                            action: Action.login),
                                   then:Login.View.init(store:)
                        )

                    case .step1_Welcome:

                            IfLetStore(self.store.scope(
                                state: \.welcome,
                                action: Action.welcome),
                                       then:Welcome.View.init(store:)
                            )
//
                    case .step2_ChooseUserSettings:
                        IfLetStore(self.store.scope(
                            state: \.userInformation,
                            action: Action.userInformation),
                                   then:UserInformation.View.init(store:)
                        )
                    case .step3_TermsAndConditions:
                        
                        TermsAndConditions.View(
                            store: Store(
                                initialState: TermsAndConditions.State.init(),
                                reducer: TermsAndConditions.init()
                            )
                        )
                    }
////                        Welcome.View(
////                            store: Store(
////                                initialState: Welcome.State.init(),
////                                reducer: Welcome.init()
////                            )
////                        )
//
////                        UserInformation.View(
////                            store: Store(
////                                initialState: UserInformation.State.init(),
////                                reducer: UserInformation.init()
////                            )
////                        )
//
                }
            }
        }
    }
}


