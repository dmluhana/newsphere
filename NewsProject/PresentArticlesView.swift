//
//  PresentArticlesView.swift
//  NewsProject
//
//  Created by Dilan Luhana on 4/26/23.
//

import SwiftUI
import AVFAudio

struct PresentArticlesView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @StateObject var newsVM = NewsViewModel()
    @State private var isSheetPresented = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brown
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    
                    HStack {
                        Image("newsphere")
                            .resizable()
                            .scaledToFit()
                            .padding(.bottom)
                    }
                    .padding(.horizontal)
                    
                    Button {
                        isSheetPresented.toggle()
                        Task {
                            await newsVM.getData()
                        }
                    } label: {
                        Text("Present Articles")
                            .font(.custom("Times New Roman", size: 40))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.brown)
                }
            }
        }
        .fullScreenCover(isPresented: $isSheetPresented) {
            ArticleListView()
        }
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audio")
        }
    }
}

struct PresentArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        PresentArticlesView()
    }
}
