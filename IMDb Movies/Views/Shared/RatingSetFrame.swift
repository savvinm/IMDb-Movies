//
//  RatingSetFrame.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 09.06.2022.
//

import SwiftUI

struct RatingSetFrame: View {
    let geometry: GeometryProxy
    let filmDetailViewModel: FilmDetailViewModel
    @Binding var showingRatingFrame: Bool
    @State var rating: Int?
    
    var body: some View {
        VStack(alignment: .center) {
            Text(filmDetailViewModel.film?.title ?? "")
                .padding()
                .multilineTextAlignment(.center)
            ratingStars
                .font(.headline)
            saveButton
                .padding()
        }
        .overlay(alignment: .topTrailing, content: { closeButton })
        .font(.headline)
        .padding()
        .background(.thickMaterial)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.secondary, lineWidth: 4)
        }
        .cornerRadius(15)
    }
    
    private var closeButton: some View {
        Button(action: {
            showingRatingFrame = false
        }, label: {
            Image(systemName: "x.circle")
                .font(.system(size: 23))
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    private var saveButton: some View {
        Button(action: {
            if rating != nil {
                filmDetailViewModel.rateFilm(rating: rating!)
            }
            showingRatingFrame = false
        },label: {
            Text("Save")
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    private var ratingStars: some View {
        HStack {
            ForEach(1..<filmDetailViewModel.maximumRating + 1, id: \.self) { number in
                Image(systemName: "star.fill")
                    .foregroundColor(starColor(for: number))
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    private func starColor(for number: Int) -> Color {
        guard let rating = rating else {
            return .gray
        }
        return number > rating ? .gray : .yellow
    }
}
