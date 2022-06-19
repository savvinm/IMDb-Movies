//
//  ResizableAsyncImage.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 19.06.2022.
//

import SwiftUI

struct ResizableAsyncImage: View {
    let stringURL: String
    var body: some View {
        AsyncImage(url: URL(string: stringURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
    }
}
