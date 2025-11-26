import UIKit

extension UIColor {
   
    // Primary Colors
    static let primary = UIColor(resource: .blackAdaptive)

    // Secondary Colors
    static let secondary = UIColor(resource: .lightGrayAdaptive)

    // Background Colors
    static let backgroundPrimary = UIColor(resource: .whiteAdaptive)
    static let backgroundSecondary = UIColor(resource: .lightGrayAdaptive)

    //Accent Color
    static let accentColor = UIColor(resource: .blueUniversal)
    
    // Text Colors
    static let textPrimary = UIColor(resource: .blackAdaptive)
    static let textSecondary = UIColor.gray
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black

    private static let blackAdaptive = UIColor(resource: .blackAdaptive)
    private static let whiteAdaptive = UIColor(resource: .whiteAdaptive)
    private static let lightGrayAdaptive = UIColor(resource: .lightGrayAdaptive)
    
    // Semantic Colors
    static let semanticGreen = UIColor(resource: .greenUniversal)
    static let semanticRed = UIColor(resource: .redUniversal)
    static let semanticYellow = UIColor(resource: .yellowUniversal)
    
    // Base Colors
    static let baseBlack = UIColor(resource: .blackUniversal)
    static let baseWhite = UIColor(resource: .whiteUniversal)
    static let neutralGray = UIColor(resource: .grayUniversal)
    
}
