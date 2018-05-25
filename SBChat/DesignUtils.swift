//
//  DesignUtil.swift
//  SecondBook
//
//  Created by Jakob Mikkelsen on 6/12/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

import UIKit

class DesignUtils {

    var mainColorHex: String = "339999"//"04C8A8"
    var mainColorDarkHex: String = "04957d"
    var mainBackgroundHex: String = "F6F6F6"
    static let shared = DesignUtils()

    static func mainFontMedium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }

    static func mainFontRegular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }

    static func mainFontThin(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.thin)
    }

    static func mainFontBold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }

    func mainColor() -> UIColor {
        return UIColorFromRGB(mainColorHex, alpha: 1.0)
    }
    
    func mainColorAlpha(_ alpha: Double) -> UIColor {
        return UIColorFromRGB(mainColorHex, alpha: alpha)
    }

    func mainColorDark() -> UIColor {
        return UIColorFromRGB(mainColorDarkHex, alpha: 1.0)
    }

    //Main color for alertView
    func mainColorAlertView() -> UInt {
        return mainColor().rgb()!
    }

    //Main color for background (CollectionViews + TableViews
    func mainBackgroundColor() -> UIColor {
        return UIColor(netHex: 0xF6F6F6)
    }

    //Get shadow for UIButton
    func buttonWith(_ button: UIButton, setCorner cornerSize: CGFloat) -> UIButton {
        let newButton: UIButton = button
        newButton.layer.cornerRadius = 5.0
        newButton.layer.borderColor = UIColor.clear.cgColor
        newButton.clipsToBounds = true
        return newButton
    }
    
    //Get color from RGB
    func UIColorFromRGB(_ color: String, alpha: Double) -> UIColor {
        assert(alpha <= 1.0, "The alpha channel cannot be above 1")
        assert(alpha >= 0, "The alpha channel cannot be below 0")
        var rgbValue: UInt32 = 0
        let scanner = Scanner(string: color)
        scanner.scanLocation = 1
        if scanner.scanHexInt32(&rgbValue) {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0xFF) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
        }
        return UIColor.black
    }

}

// Extension for UIColor (Hex+RGB)
extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }

    func rgb() -> UInt? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return UInt(rgb)
        } else {
            // Could not extract RGBA components
            return nil
        }
    }
}
