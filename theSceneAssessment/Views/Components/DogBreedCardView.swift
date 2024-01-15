//
//  DogBreedCardView.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/13/24.
//

import SwiftUI

struct DogBreedCardView: View {
    let breed: DogBreed
    
    var body: some View {
        
        VStack {
            dogImage
            dogBreedLabel
        }
        .background(.yellow)
        .cornerRadius(25)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(.yellow, lineWidth: 1)
        )
    }
    
    private var dogImage: some View {
        ZStack {
            Color.white
            AsyncImage(url: URL(string: breed.basicInfo.image.url)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(.systemGray3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .cornerRadius(25, corners: [.topLeft, .topRight])
    }
    
    private var dogBreedLabel: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(breed.basicInfo.name)
                    .font(.title)
                    .bold()
                Text(breed.metaDataInfo.bredFor ?? "N/A")
                    .foregroundColor(.black)
                    .italic()
            }
            .multilineTextAlignment(.leading)

            .padding()
            Spacer()
        }
    }
}


struct DogBreedCardView_Previews: PreviewProvider {
    static var previews: some View {
        DogBreedCardView(breed: DogBreed(basicInfo: DogBreedBasic(id: 0, name: "German Sheperd", origin: "Germany", image: DogBreedImage(id: "134", url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")), metaDataInfo: DogBreedMetaData(id: 0, name: "German Sheperd", lifeSpan: "14-16", bredFor: "Hunting", breedGroup: "Hound")))
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
