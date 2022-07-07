//
//  MessageInCenter.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 07.07.2022.
//

import SwiftUI

struct MessageInCenter: View {
    let message: LocalizedStringKey
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
        .padding()
    }
}
