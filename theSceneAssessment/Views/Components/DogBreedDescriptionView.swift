//
//  DogBreedDescriptionView.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/13/24.
//

import SwiftUI

struct DogBreedDescriptionView: View {
    let breed: DogBreed
    @Binding var path: [HomeNavigation]
    
    var body: some View {
        VStack {
            TopNavBar(path: $path, hasBackButton: true)
            screenContents
        }
        .navigationBarHidden(true)
    }
    
    private var screenContents: some View {
        ScrollView {
            VStack {
                dogImage
                title
                HStack {
                    textDetails
                    Spacer()
                }
            }
        }
    }
    
    private var dogImage: some View {
        AsyncImage(url: URL(string: breed.basicInfo.image.url)) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } placeholder: {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(.systemGray3))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        }
        .padding(.bottom)
    }
    
    private var title: some View {
        Text(breed.metaDataInfo.name)
            .font(.largeTitle).bold()
            .padding()
    }
    
    private var textDetails: some View {
        VStack(alignment: .leading) {
            Text("Details")
                .font(.title2).bold()
            
            Divider()
                .padding(.bottom)
            
            Group {
                Text("Bred For:")
                    .font(.title3).bold()
                Text(breed.metaDataInfo.bredFor ?? "N/A")
                    .italic()
            }
            
            Divider()
                .padding(.vertical)
            
            Group {
                Text("Expected life span:")
                    .font(.title3).bold()
                Text("\(breed.metaDataInfo.lifeSpan) years")
                    .italic()
            }
           
            Divider()
                .padding(.vertical)

            Group {
                Text("Country of Origin:")
                    .font(.title3).bold()
                Text(breed.basicInfo.origin ?? "Unknown origin")
                    .italic()
            }
            
            Divider()
                .padding(.vertical)

            Group {
                Text("Breed Group:")
                    .font(.title3).bold()
                Text(breed.metaDataInfo.breedGroup ?? "No breed group")
                    .italic()
            }
        }
        .multilineTextAlignment(.leading)
        .padding()
    }
}

struct DogBreedDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DogBreedDescriptionView(breed: DogBreed(basicInfo: DogBreedBasic(id: 0, name: "German Sheperd", origin: "Germany", image: DogBreedImage(id: "134", url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")), metaDataInfo: DogBreedMetaData(id: 0, name: "German Sheperd", lifeSpan: "14-16", bredFor: "Hunting", breedGroup: "Hound")), path: .constant([]))
    }
}

//- name
//- breed_group
//- bred_for
//- iife_span
//- Origin
//
