import Foundation
import SwiftUI

extension Color{
    
    init(hex: UInt, alpha: Double = 1) {
            self.init(
                .sRGB,
                red: Double((hex >> 16) & 0xff) / 255,
                green: Double((hex >> 08) & 0xff) / 255,
                blue: Double((hex >> 00) & 0xff) / 255,
                opacity: alpha
            )
        }
        

    public static let primaryWhite = Color(hex: 0xFFFFFF)
    public static let primaryTeal = Color(hex: 0x1CDBBC)
    public static let primaryBlack = Color(hex: 0x000000)
    
    public static let secondaryLightTeal = Color(hex: 0x8BF5E3)
    public static let secondaryMedTeal = Color(hex: 0x0A838A)
    public static let secondaryDarkTeal = Color(hex: 0x063636)
    
    public static let tertiaryBlue = Color(hex: 0x1D6FED)
    public static let tertiaryLightBlue = Color(hex: 0x7AC6FF)
    public static let tertiaryDarkBlue = Color(hex: 0x123B97)
    
    public static let statusRed1 = Color(hex: 0xFFEFEF)
    public static let statusRed3 = Color(hex: 0xE5484D)
    public static let statusRed4 = Color(hex: 0xCD2B31)
    
    public static let statusBlue = Color(hex: 0x0091FF)
    public static let statusBlue1 = Color(hex: 0xEDF6FF)
    public static let statusBlue2 = Color(hex: 0x96C7F2)
    public static let statusBlue4 = Color(hex: 0x006ADC)
    
    public static let yellow1 = Color(hex: 0xFFFBD1)
    public static let yellow2 = Color(hex: 0xEFD36C)
    public static let yellow3 = Color(hex: 0xF7D90A)
    public static let yellow4 = Color(hex: 0x946800)
    
    public static let statusGreen1 = Color(hex: 0xEBF9EB)
    public static let statusGreen2 = Color(hex: 0x97CF9C)
    public static let statusGreen3 = Color(hex: 0x46A758)
    public static let statusGreen4 = Color(hex: 0x297C3B)
    public static let statusGreen5 = Color(hex: 0x00624F)
    
    public static let gray1 = Color(hex: 0xF7F5F5)
    public static let gray2 = Color(hex: 0xEAE9E8)
    public static let gray3 = Color(hex: 0xD5D5D5)
    public static let gray4 = Color(hex: 0xC2C2C2)
    public static let gray5 = Color(hex: 0x8F8F8F)
    public static let gray6 = Color(hex: 0x6F6F6F)
    public static let gray7 = Color(hex: 0x1C1C1E)
    public static let darkGray = Color(hex: 0x393939)
    
    public static let bGBlack = Color(hex: 0x171717)
    
    public static let darkGray1 = Color(hex: 0x262626)
    public static let darkGray2 = Color(hex: 0x404040)
    public static let darkGray3 = Color(hex: 0x212020)
    public static let darkGray4 = Color(hex: 0x353535)
    public static let darkGray5 = Color(hex: 0xD9D9D9)
    
    public static let tertiaryPurple = Color(hex: 0x5C229C)
    public static let tertiaryLightPurple = Color(hex: 0xBA8CFF)
    
    public static let tertiaryPink = Color(hex: 0xE74595)
    public static let tertiaryLitePink = Color(hex: 0xFF80C1)
    public static let primaryDarkTeal = Color(hex: 0x16BF9F)
    public static let primaryLightTeal = Color(hex: 0x77E8D2)
    public static let statusBlue3 = Color(hex: 0x0091FF)
}
