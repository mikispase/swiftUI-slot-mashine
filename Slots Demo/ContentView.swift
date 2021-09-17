//
//  ContentView.swift
//  Slots Demo
//
//  Created by Dimitar Spasovski on 9/17/21.
//

import SwiftUI

struct ContentView: View {
    @State private var symbols = ["apple", "star" , "cherry"]
    @State private var numbers = Array(repeating: 0, count: 9)
    @State private var background = Array(repeating: Color.white, count: 9)
    @State private var credits:Int = 1000
    
    
    private var betAmount =  5
    
    var body: some View {
     
        ZStack {
           // Background
            Rectangle()
                .foregroundColor(Color(red: 200/255, green: 143/255, blue: 32/255))
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .foregroundColor(Color(red: 228/255, green: 195/255, blue: 76/255))
                .rotationEffect(Angle(degrees: 45))
                .edgesIgnoringSafeArea(.all)
            
           
            VStack {
                Spacer()

                // Title
                HStack {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("SwiftUI Slots")
                        .bold()
                        .foregroundColor(.white)
                    
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                } //End HStack
                .scaleEffect(1.5)
                
                Spacer()
                
                //Credit counter
                Text("Credits: \(String(credits))")
                    .padding(.all, 10)
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                
                Spacer()

                VStack{
                    //Cards 1
                    HStack {
                        Spacer()
                   
                        CardView(symbol: $symbols[numbers[0]], background: $background[0])
                            .animation(.easeInOut(duration: 0.25))    // animatable fade in/out

                            
                        CardView(symbol: $symbols[numbers[1]], background: $background[1])
                            .animation(.easeInOut(duration: 0.25))    // animatable fade in/out

                        
                        CardView(symbol: $symbols[numbers[2]], background: $background[2])
                            .animation(.easeInOut(duration: 0.25))    // animatable fade in/out

                        
                        Spacer()
                    } .animation(.easeInOut(duration: 0.25))
                    //Cards 2
                    HStack {
                        Spacer()
                   
                        CardView(symbol: $symbols[numbers[3]], background: $background[3])
                            
                        CardView(symbol: $symbols[numbers[4]], background: $background[4])
                        
                        CardView(symbol: $symbols[numbers[5]], background: $background[5])
                        
                        Spacer()
                    }
                    
                    //Cards 3
                    HStack {
                        Spacer()
                   
                        CardView(symbol: $symbols[numbers[6]], background: $background[6])
                            
                        CardView(symbol: $symbols[numbers[7]], background: $background[7])
                        
                        CardView(symbol: $symbols[numbers[8]], background: $background[8])
                        
                        Spacer()
                    }
                }
                Spacer()
                
                HStack {
                    VStack {
                        // Buuton
                        Button(action:{
                            // process a sigle spin
                            self.processResult()
                            
                         }, label: {
                            Text("Spin")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .padding([.leading,.trailing], 30)

                                .background(Color.pink)
                                .cornerRadius(20)
                                
                        })
                        
                        Text("\(betAmount) credits").padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/).font(.footnote)
                    }
                    
                    VStack {
                        
                        // Buuton
                        Button(action:{
                            // process a sigle spin
                            self.processResult(ismax: true)
                            
                         }, label: {
                            Text("Max Spin")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .padding([.leading,.trailing], 30)

                                .background(Color.pink)
                                .cornerRadius(20)
                                
                        })
                        
                        Text("\(betAmount * 5) credits").padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/).font(.footnote)
                    }// end Vstack
                }
                
                Spacer()
            }
            .frame(
                        maxWidth: 600,
                        maxHeight: 800,
                        alignment: .center
                    )
            
        }// End Zstak
    }
    
    func processResult(ismax:Bool = false){
        
        // set baground to white
        self.background = self.background.map { _ in
            Color.white
        }
        
        if ismax {
            // spin all the cards
            self.numbers = self.numbers.map({ _ in
                Int.random(in: 0...self.symbols.count - 1)
            })
        }else {
            //spin the middle row
            self.numbers[3] = Int.random(in: 0...symbols.count - 1)
            
            self.numbers[4] = Int.random(in: 0...symbols.count - 1)
            
            self.numbers[5] = Int.random(in: 0...symbols.count - 1)
        }
        
        processWin(isMax: ismax)
    }
    
    func processWin(isMax:Bool  = false){
        
        var matches = 0
        
        if !isMax {
            // Proccesing single spin
            // Middle row
            if isMatch(3, 4, 5) { matches += 1 }
        
        }else {
            // Proccesing max spin ////
            //// / / / / / / / / / / / / / / / / / / / / / / / /
            // Top row
            if isMatch(0, 1, 2) { matches += 1 }

            // Middle row
            if isMatch(3, 4, 5) { matches += 1 }

            // Bottom.  row
            if isMatch(6, 7, 8) { matches += 1 }

            //Diagonal top lefr to bottom right
            if isMatch(0, 4, 8) { matches += 1 }

            //Diagonal top roght to bottom left
            if isMatch(2, 4, 6) { matches += 1 }
            
            if isMatch(1, 4, 7) { matches += 1}
        }
        
        if matches > 0 {
            self.credits += matches * betAmount * 2
        }else if !isMax {
            // 0 wins , singlespin
            self.credits -= betAmount
        }else {
            //0 wins max spin
            self.credits -= betAmount * 5
        }

    }
    
    func isMatch(_ index1:Int,_ index2:Int,_ index3:Int) -> Bool{
        if self.numbers[index1] == self.numbers[index2] &&
            self.numbers[index2] == self.numbers[index3] {
            self.background[index1] = Color.green
            self.background[index2] = Color.green
            self.background[index3] = Color.green
            return true
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
