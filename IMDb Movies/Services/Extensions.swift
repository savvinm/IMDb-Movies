//
//  Extensions.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 09.06.2022.
//

import SwiftUI

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize:25)]
        UINavigationBar.appearance().largeTitleTextAttributes = attr
    }
}
