@available(iOS 7.0, *)
open class func preferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont

extension UIFont.TextStyle {
    @available(iOS 11.0, *)
    public static let largeTitle: UIFont.TextStyle
    
    @available(iOS 9.0, *)
    public static let title1: UIFont.TextStyle
    
    @available(iOS 9.0, *)
    public static let title2: UIFont.TextStyle
    
    @available(iOS 9.0, *)
    public static let title3: UIFont.TextStyle
    
    @available(iOS 7.0, *)
    public static let headline: UIFont.TextStyle
    
    @available(iOS 7.0, *)
    public static let subheadline: UIFont.TextStyle
    
    @available(iOS 7.0, *)
    public static let body: UIFont.TextStyle
    
    @available(iOS 9.0, *)
    public static let callout: UIFont.TextStyle
    
    @available(iOS 7.0, *)
    public static let footnote: UIFont.TextStyle
    
    @available(iOS 7.0, *)
    public static let caption1: UIFont.TextStyle
    
    @available(iOS 7.0, *)
    public static let caption2: UIFont.TextStyle
}
lable.font = UIFont.preferredFont(forTextStyle: style)


@available(iOS 10.0, *)
open class func preferredFont(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont

