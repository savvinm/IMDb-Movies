//
//  TapShape.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 14.06.2022.
//

import SwiftUI

struct TapShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path(CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
    }
}
