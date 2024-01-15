//
//  TabBarView.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/13/24.
//

import SwiftUI

enum Tab {
  case home
 }

enum HomeNavigation: Hashable {
    case child(DogBreed)
}

struct TabBarView: View {
    @State private var selectedTab: Tab = .home
    @State private var homeNavigationPath = [HomeNavigation]()
    @State private var scrollToTopOfHome: Bool = false
    
    var body: some View {
        TabView(selection: tabSelection()) {
            HomePage(navigationPath: $homeNavigationPath, scrollToTop: $scrollToTopOfHome)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .toolbarBackground(Color(.systemGray6), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .tag(Tab.home)
        }
    }
}

extension TabBarView {
    
    // helper function to track tab selection
    private func tabSelection() -> Binding<Tab> {
        Binding {
            self.selectedTab
        } set: {
            if $0 == self.selectedTab {
                
                // if user is already on the home tab, we will scroll to top of page, otherwise we will pop to home
                if homeNavigationPath.isEmpty {
                    scrollToTopOfHome = true
                } else {
                    homeNavigationPath = []
                }
            }
            
            //Set the tab to the selected tab
            self.selectedTab = $0
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
