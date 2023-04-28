//
//  ContentView.swift
//  DogPics
//
//  Created by Dilan Luhana on 4/16/23.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @StateObject var newsVM = NewsViewModel()
    @State private var isSheetPresented = false
    @State var keyword = ""
    @State private var textFieldHelp = ""
    @State private var textFieldHelpOn = false
    @State private var textFieldNumHelp = ""
    @State private var textFieldNumHelpOn = false
    @State private var isInfoSheetPresented = false
    @State private var pageSizeTemp = "50"
    @State private var isDilanSheetPresented = false
    
    
    var body: some View {
        NavigationStack {
  
                HStack {
                    Text("Newsphere")
                        .font(Font.custom("Times New Roman", size: 60))
                        .bold()
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Image("globe")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom)
                }
                .padding(.horizontal)
                
                HStack {
                    TextField("Enter a Keyword", text: $keyword)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                    
                    Button {
                        textFieldHelpOn.toggle()
                        textFieldHelp = newsVM.textFieldHelpFunc(on: textFieldHelpOn)
                    } label: {
                        Image(systemName: "questionmark")
                    }
                }
                .padding(.horizontal)
                
                Text(textFieldHelp)
                    .font(.caption)
                    .padding(.horizontal)
                
                HStack {
                    TextField("Enter a page size", text: $pageSizeTemp)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                            
                        }
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    
                    Button {
                        textFieldNumHelpOn.toggle()
                        textFieldNumHelp = newsVM.textFieldNumHelpFunc(on: textFieldNumHelpOn)
                    } label: {
                        Image(systemName: "questionmark")
                    }
                }
                .padding(.horizontal)
                
                Text(textFieldNumHelp)
                    .font(.caption)
                    .padding(.horizontal)
                
                Button("Present Articles") {
                    newsVM.urlString = "https://newsapi.org/v2/everything?q=\(keyword)&pageSize=\(pageSizeTemp)&sortBy=relevancy&apiKey=dccd693b384349c2b0b63517e967da90"
                    Task {
                        await newsVM.getData()
                        isSheetPresented.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("lightBlue"))
                Spacer()
        }
        .background(.thickMaterial)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
