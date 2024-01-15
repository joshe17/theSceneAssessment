//
//  HomePage.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/13/24.
//

import SwiftUI

struct HomePage: View {
    @StateObject var viewModel = DogsViewModel()
    @Binding var navigationPath: [HomeNavigation]
    @Binding var scrollToTop: Bool
    @State private var isShowingTiers = false
    @State private var showErrorAlert = false
    @State private var degreesRotating = 0.0
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            homePageViews
        }
    }
    
    private var homePageViews: some View {
        ZStack {
            screenContents
                .navigationDestination(for: HomeNavigation.self) { page in
                    switch page {
                    case .child(let breed): DogBreedDescriptionView(breed: breed, path: $navigationPath)
                    }
                }
            
            UpgradeTiersView(isShowing: $isShowingTiers)
                .opacity(isShowingTiers ? 1 : 0)
                .transition(.opacity)
                .zIndex(1)
            
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            // Alert for when we reach an api error after the first load
            Alert(
                title: Text("Error getting more results"),
                message: Text("Can't get more dogs please try again.")
            )
        }
        .onAppear {
            // Only load dogBreeds if we haven't already, otherwise representing the view doesn't load more.
            if viewModel.dogBreeds == [] {
                viewModel.getDogs()
            }
        }
    }
    
    private var screenContents: some View {
        VStack {
            TopNavBar(path: $navigationPath, hasBackButton: false)
            
            // if first loading page, returning corresponding view based on status
            if viewModel.currentPage == 1 {
                switch viewModel.status {
                case .loaded:
                    loadedContents
                case .error:
                    errorContents
                case .loading:
                    loadingContents
                case .initial:
                    initialContents
                }
            } else { //Otherwise we want to show loadedContents, and handle status changes within loadedContents view
                loadedContents
            }
        }
    }
    
    // main view once dogBreeds is loaded
    private var loadedContents: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                dogScrollView
                    .onChange(of: scrollToTop) { _ in
                        withAnimation {
                            proxy.scrollTo("Header", anchor: .top)
                        }
                        scrollToTop = false
                    }
            }
        }
    }
    
    // Error view for first time loading
    private var errorContents: some View {
        VStack {
            Spacer()
            
            Text("Error getting dogs, please try again")
            
            Button {
                viewModel.getDogs()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 2)
                )
            }
            
            Spacer()
        }
    }
    
    // Intermediate view for initial loading of dog breeds
    private var loadingContents: some View {
        VStack {
            Spacer()
            
            Text("Loading...")
            
            Spacer()
        }
    }
    
    // Default state before we load breeds for first time
    private var initialContents: some View {
        VStack {
            Spacer()
            
            Text("Waiting to load...")
            
            Spacer()
        }
    }
    
    private var title: some View {
        HStack {
            Text("Dog Breeds")
                .font(.largeTitle).bold()
            
            Spacer()
            
            //Upgrade button
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowingTiers = true
                }
            } label: {
                HStack {
                    Image(systemName: "wand.and.stars")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 18, maxHeight: 18)
                    Text("Upgrade")
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 1)
                )
            }
            .foregroundColor(.purple)
        }
        .padding()
    }
    
    private var dogScrollView: some View {
        LazyVStack {
            title
                .id("Header")
            
            ForEach(viewModel.dogBreeds, id: \.self.id) { breed in
                NavigationLink(value: HomeNavigation.child(breed)) {
                    DogBreedCardView(breed: breed)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 5)
                }
                .foregroundColor(.black)
            }
            
            // We place a view at the bottom of LazyVStack to know what to do next based on status
            if viewModel.status == .error   { //If there was an error, we will show a button on bottom of loadedContents to try again
                loadMoreButton
            } else if viewModel.haveReachedEnd == true { //If we've reached an end of api results
                Text("You have reached the end.")
                    .padding()
            } else { //Otherwise we show a progress view that loads more dogs once you scroll to bottom
                loadingTicker
            }
        }
    }
    
    private var loadingTicker: some View {
        ProgressView()
            .frame(width: 50, height: 50)
            .foregroundColor(Color(.systemGray3))
            .padding([.top, .horizontal])
            .onAppear {
                viewModel.getDogs()
            }
    }
    
    private var loadMoreButton: some View {
        Button {
            viewModel.status = .loaded
        } label: {
            Text("Try again")
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
        }
        .padding()
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(navigationPath: .constant([]), scrollToTop: .constant(false))
    }
}
