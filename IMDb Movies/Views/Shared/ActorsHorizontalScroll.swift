//
//  ActorsHorizontalScroll.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 03.06.2022.
//

import SwiftUI

struct ActorsHorizontalScroll: View {
    let title: String
    let items: [Film.Actor]
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fontWeight(Font.Weight.semibold)
                horizontalList(in: geometry)
            }
        }
    }
    
    private func horizontalList(in geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(items) { filmActor in
                    infoView(for: filmActor)
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.85)
                }
            }
        }
    }
    
    private func infoView(for filmActor: Film.Actor) -> some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                image(imageURL: URL(string: filmActor.imageURL))
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                actorInfo(for: filmActor)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            /*.background {
                Rectangle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(.secondary)
                    .cornerRadius(5)
            }*/
        }
    }
    
    private func image(imageURL: URL?) -> some View {
        GeometryReader { geometry in
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func actorInfo(for filmActor: Film.Actor) -> some View {
        VStack(alignment: .center) {
            Text(filmActor.name)
                .multilineTextAlignment(.leading)
            /*Text("as")
            Text(filmActor.asCharacter)
                .multilineTextAlignment(.center)*/
        }
    }
}
