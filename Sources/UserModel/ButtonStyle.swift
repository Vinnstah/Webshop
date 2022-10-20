import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
        
    public static let defaultCornerRadius: CGFloat = 8
    private let cornerRadius: CGFloat
    private var isLoading: Bool

    public init(
        isLoading: Bool = false,
        cornerRadius: CGFloat = Self.defaultCornerRadius
    ) {
        self.isLoading = isLoading
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Group {
                configuration.label
                .font(.body)
                .foregroundColor(isEnabled ? Color.white : .gray)

            }
        .frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isEnabled ? Color("ButtonColor") : .gray)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}


public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
        
    private let cornerRadius: CGFloat
    
    public init(cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius) {
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isEnabled ? Color("ButtonColor") : .gray)
            .foregroundColor(isEnabled ? Color.white : .gray)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {

    /// A button style that applies the call to the **primary** action of the
    /// current screen, rounded with the default corner radious.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
    static var primary: PrimaryButtonStyle {
        Self.primary(cornerRadius: PrimaryButtonStyle.defaultCornerRadius)
    }
    
    /// A button style that applies the call to the **primary** action of the
    /// current screen.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
    static func primary(
        isLoading: Bool = false,
        cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius
    ) -> PrimaryButtonStyle {
        .init(isLoading: isLoading, cornerRadius: cornerRadius)
    }
}

public extension ButtonStyle where Self == SecondaryButtonStyle {
    
    /// A button style that applies the call to the **secondary** action of the
    /// current screen, rounded with the default corner radious.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
    static var secondary: SecondaryButtonStyle {
        Self.secondary(cornerRadius: PrimaryButtonStyle.defaultCornerRadius)
    }
    
    /// A button style that applies the call to the **secondary** action of the
    /// current screen.
    ///
    /// To apply this style to a button, or to a view that contains buttons, use
    /// the ``View.buttonStyle(_:)`` modifier.
    static func secondary(cornerRadius: CGFloat) -> Self {
        .init(cornerRadius: cornerRadius)
    }
    
}
