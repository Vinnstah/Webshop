import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
//    @Environment(\.isEnabled) var isEnabled
        
    public static let defaultCornerRadius: CGFloat = 8
    private let cornerRadius: CGFloat
    private var isDisabled: Bool
    private let alternativeColor: Color?

    public init(
        isDisabled: Bool = false,
        cornerRadius: CGFloat = Self.defaultCornerRadius,
        alternativeColor: Color? = nil
    ) {
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
        self.alternativeColor = alternativeColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Group {
                configuration.label
                .font(.body)
                .foregroundColor(isDisabled ? Color.white : .white)

            }
        .frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isDisabled ? .gray : alternativeColor == nil ? Color("Primary") : alternativeColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}


public struct SecondaryButtonStyle: ButtonStyle {
//    @Environment(\.isEnabled) var isEnabled
        
    public static let defaultCornerRadius: CGFloat = 8
    private let cornerRadius: CGFloat
    private var isDisabled: Bool

    public init(
        isDisabled: Bool = false,
        cornerRadius: CGFloat = Self.defaultCornerRadius
    ) {
        self.isDisabled = isDisabled
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Group {
                configuration.label
                .font(.body)
                .foregroundColor(isDisabled ? Color.white : .white)

            }
        .frame(maxWidth: .infinity, idealHeight: 50)
            .padding()
            .background(isDisabled ? .gray : Color("Secondary"))
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
        isDisabled: Bool = false,
        cornerRadius: CGFloat = PrimaryButtonStyle.defaultCornerRadius,
        alternativeColor: Color? = nil
    ) -> PrimaryButtonStyle {
        .init(isDisabled: isDisabled, cornerRadius: cornerRadius, alternativeColor: alternativeColor)
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
    static func secondary(
        isDisabled: Bool = false,
                          cornerRadius: CGFloat = SecondaryButtonStyle.defaultCornerRadius
    ) -> SecondaryButtonStyle {
        .init(isDisabled: isDisabled, cornerRadius: cornerRadius)
    }
    
}
