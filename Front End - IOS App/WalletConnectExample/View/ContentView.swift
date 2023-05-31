//
//  ContentView.swift
//  WalletConnectExample
//
//  Created by Lev Baklanov on 12.06.2022.
//

       


import SwiftUI
var connection = false

//struct ContentView: View {
//    @State private var selectedTab: Tab = .house
//
//    let titleColor = UIColor(red: 220, green: 0, blue: 20, alpha: 1.0)
//
//
//    init() {
//
//        UITabBar.appearance().isHidden = true
//    }
//    var body: some View {
//        ZStack {
//            VStack {
//                VStack{
//                    TabView(selection: $selectedTab){
//                        if(selectedTab == .house){
//
////                            HomePage()
//
//                        }else if(selectedTab == .person){
////                            PersonView()
//
//                        }else if(selectedTab == .chart){
//                            Text("Settings")
//
//                        }
//
//
//
//                    }
//
//
//                }
//                Spacer()
//
//                CustomTabBar(selectedTab: $selectedTab)
//            }
//        }
//
//    }
//}
struct HomePage: View {
    var viewModel: ExampleViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("RapOff")
                        .foregroundColor(Color.red)
                        .font(.custom("Molend-Regular", size: 36))
                        .padding(.trailing)
                        .frame(width: 236.843, height: 72.842)
                        .shadow(color: .black, radius: 3)
                    Spacer()
                }

                ZStack {
                    Color(.secondarySystemBackground)

                    ScrollView(.vertical) {
                        VStack {
                            Image("TopPic")
                                .resizable()
                                .frame(height: 300.0)

                            Spacer()
                            RapperPost()
                            RapperPost()
                            RapperPost()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct RapperPost: View {
    @State private var showBetSheet = false
    @State private var selectedRapper = "J-king" // Selected rapper

    @State private var showWatchView = false
    @State private var betAmount = ""


    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image("rapper1")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(100)
                        .aspectRatio(contentMode: .fill)
                        .padding(.horizontal)
                    Text("J-king")
                }

                VStack {
                    Spacer().padding(.top)
                    Text("Fliptop")
                        .font(.system(size: 20, weight: .heavy))
                    Text("12 Aug 2023")
                    Text("1:30pm")
                    Spacer()

                    NavigationLink(destination: WatchView(), isActive: $showWatchView) {
                        Text("Watch")
                            .frame(width: 100.0, height: 50.0)
                            .foregroundColor(Color.white)
                            .background(Color.red)
                            .cornerRadius(6)
                    }
                    .isDetailLink(false)
                }

                VStack {
                    Image("rapper2")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(100)
                        .aspectRatio(contentMode: .fill)
                        .padding(.horizontal)
                    Text("Apoc")
                }
            }

            HStack {
                Spacer()
                Label("2.5", systemImage: "")
                    .padding(.trailing, 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 70, height: 40)
                    )
                Spacer()

                Button("BET NOW") {
                    showBetSheet = true
                }
                .frame(width: 120.0, height: 50.0)
                .foregroundColor(Color.white)
                .background(Color.black)
                .cornerRadius(6)

                Spacer()
                Label("3.5", systemImage: "")
                    .padding(.trailing, 2.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 70, height: 40)
                    )
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(7)
        .sheet(isPresented: $showBetSheet) {
                    betSheet
                }
    }
    private var betSheet: some View {
            VStack {
                Text("Place Your Bet")
                    .font(.title)
                    .padding()
                    .foregroundColor(.black)
                
                Picker(selection: $selectedRapper, label: Text("Select a rapper")) {
                    Text("J-king").tag("J-king")
                    Text("Apoc").tag("Apoc")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical)

                TextField("Enter bet amount", text: $betAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(.black) // Set the text color to black
                    .background(Color.white) // Add a white background
                    .cornerRadius(10) // Add rounded corners
                    .padding(.horizontal, 20) // Adjust horizontal padding
                
                HStack {
                    Spacer()

                    Button(action: {
                        if let amount = Double(betAmount) {
                            // Perform the bet confirmation action
                            print("Bet amount: \(amount)")
                        }
                        showBetSheet = false
                        betAmount = "" // Reset the betAmount to clear the text
                    }) {
                        Text("Confirm")
                            .frame(width: 100, height: 40)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.black)
                            )
                    }
                    .padding()
                    .background(Color.white) // Add a white background
                    .cornerRadius(20) // Add rounded corners

                    Button(action: {
                        showBetSheet = false
                    }) {
                        Text("Cancel")
                            .frame(width: 100, height: 40)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.black)
                            )
                    }
                    .padding()
                    .background(Color.white) // Add a white background
                    .cornerRadius(20) // Add rounded corners

                    Spacer()
                }
                .padding(.top, 20) // Add top padding
            }
            .padding()
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            ) // Add a white background with rounded corners
            .padding(.horizontal, 40) // Adjust horizontal padding
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.black]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }

    




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(viewModel: ExampleViewModel())
    }
}
