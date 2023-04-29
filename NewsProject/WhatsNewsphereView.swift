//
//  WhatsNewsphereView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/24/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        if currentPage > totalPages{
            ButtonView()
        } else {
            WhatsNewsphereView()
        }
    }
}

struct WhatsNewsphereView: View {
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        ZStack {
            
            if currentPage == 1 {
                ScreenView(image: "news", title: "What is Newsphere", detail: "Newsphere is an app that allows users to search a large database of articles and save them to use later for their school projects.", bgColor: Color("brown1"))
                    .transition(.scale)
            }
            if currentPage == 2 {
                ScreenView(image: "search", title: "The Search", detail: "Students can use the home page to search using a keyword function as well as sort the articles by their preferred method.", bgColor: Color("brown2"))
                    .transition(.scale)
            }
            if currentPage == 3 {
                ScreenView(image: "folder", title: "Saving Articles", detail: "While viewing an article a user can save the article and then access these saved articles in the folder when they need them later.", bgColor: Color("brown3"))
                    .transition(.scale)
            }
        }
        .overlay(alignment: .bottom) {
            Button {
                withAnimation(.easeInOut) {
                    if currentPage <= 2 {
                        currentPage += 1
                    } else {
                        currentPage = 1
                    }
                    
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(.white)
                    .clipShape(Circle())
                    .overlay() {
                        ZStack {
                            Circle()
                                .stroke(.black.opacity(0.04), lineWidth: 4)
                                .padding(-15)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(.white, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    }
                    .padding(.bottom,20)
            }
        }
    }
}

struct WhatsNewsphereView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewsphereView()
    }
}

struct ScreenView: View {
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                
                if currentPage == 1{
                    Text("Hello Member!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                } else {
                    Button {
                        withAnimation(.easeInOut) {
                            currentPage -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(.black.opacity(0.4))
                            .cornerRadius(10)
                    }

                }
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut) {
                        currentPage = 1
                    }
                } label: {
                    Text("Restart")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                }
                
            }
            .foregroundColor(.black)
            .padding()
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .scaledToFit()
            
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.black)
                .padding(.top)
            
            Text(detail)
                .fontWeight(.semibold)
                .kerning(1.3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer(minLength: 120)
        }
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}

var totalPages = 3
