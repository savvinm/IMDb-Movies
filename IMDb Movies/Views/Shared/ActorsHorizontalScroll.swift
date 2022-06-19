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
    let filmDetailViewModel: FilmDetailViewModel?
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
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.8)
                }
            }
        }
    }
    
    private func infoView(for filmActor: Film.Actor) -> some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                getImage(for: filmActor)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                actorInfo(for: filmActor)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func getImage(for filmActor: Film.Actor) -> some View {
        GeometryReader { geometry in
            VStack {
                if filmActor.imageURL != nil {
                    ResizableAsyncImage(stringURL: filmActor.imageURL!)
                }
                if
                    let imagePath = filmActor.imagePath,
                    let image = filmDetailViewModel!.getImage(in: imagePath)
                {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .cornerRadius(10)
        }
    }
    
    private func actorInfo(for filmActor: Film.Actor) -> some View {
        VStack(alignment: .center) {
            Text(filmActor.name)
                .multilineTextAlignment(.leading)
        }
    }
}
