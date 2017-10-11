//
//  UIView+LoadFromNib.swift
//  LuxejiCustomKeyboard
//
//  Created by GG on 29.04.17.
//  Copyright © 2017 GGiOS
//

import Foundation
import UIKit

extension UIView {
    // 1
    func fromNib<T : UIView>() -> T? {   // 2
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {    // 3
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(view)
        return view
    }
}
