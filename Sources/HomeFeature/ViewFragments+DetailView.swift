import SwiftUI
import Kingfisher
import Foundation

public extension Home.DetailView {
    func image(
        url: String,
        animationID: Namespace.ID
    ) -> some View {
        KFImage(URL(string: url))
            .resizable()
            .padding([.horizontal, .top])
            .frame(maxWidth: .infinity)
            .frame(height: 350)
            .clipShape(Rectangle())
            .cornerRadius(40)
            .ignoresSafeArea()
            .matchedGeometryEffect(id: url, in: animationID)
    }
}
public extension Home.DetailView {
    func title(_ title: String) -> some View {
        
        HStack {
            Text(title)
                .font(.largeTitle)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .frame(width: 350)
                .frame(alignment: .leading)
        }
    }
}

public extension Home.DetailView {
    func priceAndCategory(
        category: String,
        price: Int
    ) -> some View {
        
        HStack {
            VStack {
                Text(category)
                    .font(.system(size: 10))
                    .foregroundColor(Color("Secondary"))
                    .frame(alignment:.leading)
            }
            .padding(.leading, 30)
            
            Spacer()
            
            Text("\(price) kr")
                .font(.title)
                .bold()
                .foregroundColor(Color("Primary"))
                .frame(alignment: .center)
                .padding(.trailing, 50)
        }
    }
}

public extension Home.DetailView {
    func quantityModule(
        decreaseQuantity: @escaping () -> Void,
        increaseQuantity: @escaping () -> Void,
        quantity: Int
    ) -> some View {
        HStack {
            Button(action: { decreaseQuantity() },
                   label: {
                Image(systemName: "minus")
                    .foregroundColor(Color("Secondary"))
            })
            if quantity < 10 {
                Text(String("0" + "\(quantity)"))
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color("Secondary"))
                    .animation(.default, value: quantity)
            } else {
                Text(String("\(quantity)"))
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color("Secondary"))
            }
            Button(action: { increaseQuantity() },
                   label: {
                Image(systemName: "plus")
                    .foregroundColor(Color("Secondary"))
            })
        }
        .fixedSize()
        .padding(.horizontal)
    }
}

public extension Home.DetailView {
    func descriptionText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color("Secondary"))
            .padding(.horizontal)
    }
}
