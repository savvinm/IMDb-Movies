//
//  HorizontallScrollPadding.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 15.07.2022.
//

import SwiftUI

struct HorizontallScrollPadding<T: Identifiable>: ViewModifier {
    let item: T
    let items: [T]
    let padding: CGFloat
    func body(content: Content) -> some View {
        if items.first?.id == item.id {
           content
                .padding(.horizontal, padding)
                .padding(.leading, padding)
        } else if items.last?.id == item.id {
            content
                .padding(.horizontal, padding)
                .padding(.trailing, padding)
        } else {
            content.padding(.horizontal, padding)
        }
    }
}
