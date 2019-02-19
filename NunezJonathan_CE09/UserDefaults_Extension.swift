//
//  UserDefaults_Extension.swift
//  NunezJonathan_CE09
//
//  Created by Jonathan Nunez on 12/13/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    // Save  UIColor as a data object
    func setColor(color: UIColor, forKey key: String) {
        // Convert the UIColor object into a Data object by archiving
        do {
            let binaryData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            // Save binary data to user defaults
            self.set(binaryData, forKey: key)
        }
        catch {
            print("Can't create UserDefaults")
        }
    }
    
    // Get UIColor from the saved Defaults with a key
    func getColor(forKey key: String) -> UIColor? {
        // Check for valid data
        if let binaryData = data(forKey: key) {
            // Is the data a UIColor
            do {
                let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(binaryData) as? UIColor
                return color
            }
            catch {
                print("Can't retrieve data")
            }
        }
        // If we didn't make it to the return color, then there is something wrong with the data
        return nil
    }
}
