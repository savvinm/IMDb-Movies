//
//  ActorsHorizontalScroll.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 03.06.2022.
//

import SwiftUI

struct ActorsHorizontalScroll: View {
    let title: String
    let actors: [Film.Actor]
    let filmDetailViewModel: FilmDetailViewModel?
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(Font.Weight.semibold)
                .padding(.leading)
            GeometryReader { geometry in
                horizontalList(in: geometry)
            }
        }
    }
    
    private func horizontalList(in geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(actors) { filmActor in
                    infoView(for: filmActor)
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height)
                        .modifier(HorizontallScrollPadding(item: filmActor, items: actors, padding: 5))
                }
            }
        }
    }
    
    private func infoView(for filmActor: Film.Actor) -> some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                image(for: filmActor)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                actorInfo(for: filmActor)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func image(for filmActor: Film.Actor) -> some View {
        GeometryReader { geometry in
            VStack {
                if filmActor.imageURL != nil {
                    ResizableAsyncImage(stringURL: filmActor.imageURL!)
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
