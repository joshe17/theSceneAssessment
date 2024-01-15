//
//  UpgradeTiersView.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/14/24.
//

import SwiftUI

struct UpgradeTiersView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.4)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isShowing = false
                    }
                }
            VStack {
                exitButton
                descriptionText
                tierTabView
            }
            .padding()
            .background(.yellow)
            .cornerRadius(25)
            .padding()
        }
    }
    
    private var exitButton: some View {
        HStack {
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowing = false
                }
            } label: {
                Image(systemName: "multiply")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .foregroundColor(.black)
        }
    }
    
    private var descriptionText: some View {
        VStack(spacing: 15) {
            Text("Please select from the upgrade tiers below")
                .font(.title2).bold()
            Text("Upgrade tiers are charged on a monthly basis and allow for more advanced features. You can use the app for free and still view images of dogs!")
        }
        .multilineTextAlignment(.center)
        .padding([.horizontal, .top])
    }
    
    private var tierTabView: some View {
        VStack {
            TabView {
                ForEach(UpgradeTiers.allCases, id: \.self) { tier in
                    VStack(alignment: .center, spacing: 15) {
                        Text("\(tier.rawValue) Tier")
                            .font(.largeTitle)
                        Text("This plan includes all these amazing features and exclusive access to bonus content!")
                            .multilineTextAlignment(.center)
                        Text(tier.paymentCost())
                            .font(.system(size: 80)).bold()
                        Button {
                            print("You chose the \(tier.rawValue) plan")
                        } label: {
                            Text("Get Plan")
                                .foregroundColor(.black)
                                .font(.title3)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.yellow, lineWidth: 2)
                                )
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 2)
                    )
                }
                .padding()
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 450)
        }
    }
}

struct UpgradeTiersView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeTiersView(isShowing: .constant(true))
    }
}
