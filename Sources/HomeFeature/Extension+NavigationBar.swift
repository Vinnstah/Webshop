import NavigationBar
import Foundation
import ComposableArchitecture

extension NavigationBar {
    static func homeNavBar(
        viewStore: ViewStoreOf<Home>,
        content: @escaping () -> Content) -> NavigationBar {
        return Self.init(
            isRoot: !viewStore.state.showDetailView,
            isCartPopulated: { viewStore.state.cart == nil },
            showCartQuickView: { viewStore.send(.internal(.toggleCheckoutQuickViewTapped), animation: .default)},
            isFavourite: {
                guard (viewStore.state.product != nil) else {
                    return nil
                }
                return viewStore.state.favoriteProducts.sku.contains(viewStore.state.product!.id) },
            showFavouriteSymbol: {
                guard (viewStore.state.product != nil) else {
                    return
                }
                viewStore.send(.favorite(.favoriteButtonClicked((viewStore.state.product!)))) },
            showSettingsSymbol: { viewStore.send(.internal(.settingsButtonTapped)) },
            searchableBinding: viewStore.binding(
                get: { $0.searchText },
                send: { .internal(.searchTextReceivingInput(text: $0)) }).animation(),
            cancelSearch: { viewStore.send(.internal(.cancelSearchTapped)) },
            previousScreenAction: { viewStore.send(.detailView(.toggleDetailView(nil)), animation: .easeOut) },
            content: content
        )
        
    }
}
