//
//  Home.swift
//  NoteApp-MultiPlatform (iOS)
//
//  Created by GOURAVM on 24/08/22.
//

import SwiftUI

struct Home: View {
    
    @State var showColors:Bool = false
    
    @State var animateButton:Bool = false
    
    var body: some View {
        HStack(spacing:0){
            if isMacOS() {
                Group {
                    SideBar()
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width:1)
                    
                }
            }
            MainContent()
        }
        #if os(macOS)
        
        .ignoresSafeArea()
        #endif
        .frame(width: isMacOS() ? getRect().width / 1.7 : nil, height: isMacOS() ? getRect().height - 180 : nil,alignment: .leading)
        .background(Color("Background").ignoresSafeArea())
        #if os(iOS)
        .overlay(SideBar())
        #endif
        .preferredColorScheme(.light)
    }
    @ViewBuilder
    func SideBar()->some View {
        VStack{
            if isMacOS() {
                Text("Notes")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
          
            if isMacOS() {
                AddButton()
                    .zIndex(1)
            }
            
            VStack(spacing:15){
                let colors = [Color("Skin"),Color("Orange"),Color("Purple"),Color("Blue"),Color("Green")]
                
                ForEach(colors,id:\.self) { color in
                     Circle()
                        .fill(color)
                        .frame(width: isMacOS() ? 20 : 25, height: isMacOS() ? 20 : 25)
                        
                }
            }
            .padding(.top,20)
            .frame(height:showColors ? nil : 0)
            .opacity(showColors ? 1 : 0)
            .zIndex(0)
            
            if !isMacOS() {
                AddButton()
                    .zIndex(1)
            }
        }
        #if os(macOS)
        .frame(maxHeight:.infinity,alignment: .top)
        .padding(.vertical)
        .padding(.horizontal,22)
        .padding(.top,36)
        #else
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .bottomTrailing)
        .padding()
        .background {
            BlurView(style: .systemUltraThinMaterialDark)
                .opacity(showColors ? 1 : 0)
                .ignoresSafeArea()
        }
        #endif
        
    }
    
    @ViewBuilder
    func MainContent()->some View {
        VStack(spacing:6){
            HStack(spacing:8){
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundColor(.gray)
                TextField("Search", text: .constant(""))
                
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            .padding(.bottom,isMacOS() ? 0 : 10)
            .overlay(
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                #if os(iOS)
                    .frame(height:1)
                #else
                    .frame(height:0)
                #endif
                    .padding(.horizontal,-25)
                    .offset(y:6)
                
                , alignment: .bottom)

            ScrollView(.vertical,showsIndicators: false) {
                VStack(spacing:15) {
                    Text("Notes")
                        .font(isMacOS() ?.system(size: 33,weight: .bold) : .largeTitle.bold())
                        .frame(maxWidth:.infinity,alignment: .leading)
                    let columns = Array(repeating: GridItem(.flexible(),spacing: isMacOS() ? 20 : 15), count: isMacOS() ? 3 : 1)
                    
                    LazyVGrid(columns: columns,spacing:20) {
                        ForEach(notes) { note in
                            CardView(note: note)
                        }
                    }
                }
                .padding(.top,isMacOS() ? 45 : 30)
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
        .padding(.top,isMacOS() ? 40 : 15)
        .padding(.horizontal,25)
    }
    
    @ViewBuilder
    func CardView(note:Note)->some View {
        VStack{
            Text(note.note)
                .font(isMacOS() ? .title2 : .body)
                .multilineTextAlignment(.leading)
                
                .frame(maxWidth:.infinity,alignment:.leading)
            HStack{
                Text(note.date,style: .date)
                    .foregroundColor(.black)
                    .opacity(0.8)
                Spacer(minLength: 0)
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 15,weight: .bold))
                        .padding(8)
                        .foregroundColor(.white)
                        .background(.black)
                        .clipShape(Circle())
                }
            }
            .padding(.top,55)
        }
        .padding()
        .background(note.cardColor)
        .cornerRadius(18)
        .border(.black.opacity(0.2), width: 0.1)
    }
    
    func AddButton()->some View {
        
        Button {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                showColors.toggle()
                animateButton.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()) {
                    animateButton.toggle()
                }
            }
            
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.white)
                .scaleEffect(animateButton ? 1.1 : 1)
                .padding(isMacOS() ? 12 : 15)
                .background(.black)
                .clipShape(Circle())
                .rotationEffect(.degrees(showColors ? 45 : 0))
        }
        .scaleEffect(animateButton ? 1.1 : 1)
        .padding(.top,30)

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View {
    func getRect()-> CGRect {
        #if os(iOS)
        return UIScreen.main.bounds
        #else
        return NSScreen.main!.visibleFrame
        #endif
    }
    
    func isMacOS()->Bool {
        #if os(iOS)
        return false
        #endif
        return true
    }
}

#if os(macOS)
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
#endif
