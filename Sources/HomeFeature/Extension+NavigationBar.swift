import NavigationBar
import Foundation
import ComposableArchitecture

extension NavigationBar {
    static func home(
        viewStore: ViewStoreOf<Home>,
        content: @escaping () -> Content) -> NavigationBar {
        return Self.init(
            isRoot: !viewStore.state.showDetailView,
            
            itemsInCart: viewStore.state.cart?.item.count ?? 0,
            
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
                viewStore.send(.favorite(.favoriteButtonTapped((viewStore.state.product!)))) },
            
            showSettingsSymbol: { viewStore.send(.internal(.settingsButtonTapped)) },
            
            searchableBinding: viewStore.binding(
                get: { $0.searchText },
                send: { .internal(.searchTextReceivingInput(text: $0)) }
            ),
            
            cancelSearch: { viewStore.send(.internal(.cancelSearchTapped),animation: .default) },
            
            previousScreenAction: { viewStore.send(.detailView(.toggleDetailView(nil)), animation: .easeOut) },
            
            content: content
        )
        
    }
}
