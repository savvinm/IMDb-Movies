//
//  RatingIcon.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 16.06.2022.
//

import SwiftUI

struct RatingIcon: View {
    let value: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.85)
            Text(value)
                .foregroundColor(.black)
                .fontWeight(Font.Weight.medium)
        }
        .cornerRadius(5)
    }
}
