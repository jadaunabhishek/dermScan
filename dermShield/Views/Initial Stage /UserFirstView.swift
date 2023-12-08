//
//  UserFirstView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 10/12/23.
//

import SwiftUI

struct UserFirstView: View {
    
    @State private var isProfileSheetPresented = false
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            TabView() {
                DiscoverView()
                    .tabItem {
                        Image(systemName: "books.vertical.fill")
                        Text("Explore")
                    }
                
                ScanView()
                    .tabItem {
                        Image(systemName: "mail.and.text.magnifyingglass")
                            .font(.title)
                        Text("Diagnose")
                    }
                
                MessageView()
                    .tabItem {
                        Image(systemName: "envelope.badge.shield.half.filled")
                        Text("dermChat")
                    }
            }
            .accentColor(Color("PrimaryColor"))
            .onAppear{
                isProfileSheetPresented = false
            }
            .sheet(isPresented: $isProfileSheetPresented, content: {
                ProfileView()
            })
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    UserFirstView()
}
