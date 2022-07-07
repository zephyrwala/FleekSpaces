//
//  MainMessengerView.swift
//  FleekSpaces
//
//  Created by Mayur P on 05/07/22.
//

import SwiftUI
import SDWebImageSwiftUI



class MainMessageViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isCurrentlyLoggedOut = false
   
    
    
    
    init() {

        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
    }
    
    
    func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("could not find firebase uid")
            return
        }
        
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, err in
            if let error = err {
                
                print("failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            print(data)
          
            
            self.chatUser = .init(data: data)
            
            
            
          
        }
    }
    
   
    func handleSignOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
       
        
    }
    
}


struct MainMessagesView: View {

    @State var shouldShowNewMessageScreen = false
    @State var shouldShowLogOutOptions = false

    @ObservedObject private var vm = MainMessageViewModel()
    
    private var customNavBar: some View {
        HStack(spacing: 16) {

            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? "")).resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
        


            VStack(alignment: .leading, spacing: 4) {
                Text("\(vm.chatUser?.email ?? "")")
                    .font(.system(size: 24, weight: .bold))

                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }

            }

            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                    .cancel()
            ])
        }
        .fullScreenCover(isPresented:
                            $vm.isCurrentlyLoggedOut, onDismiss: nil) {
            LoginView {
                self.vm.isCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            }       }
    }
    
    @State var shouldNavigateToChatLogView = false

    var body: some View {
        NavigationView {

            VStack {
                customNavBar
                messagesView
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }

    private var messagesView: some View {
        
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    NavigationLink {
                        Text("Destination")
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1)
                                )


                            VStack(alignment: .leading) {
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()

                            Text("22d")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                  
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)

            }.padding(.bottom, 50)
        }
    }

    private var newMessageButton: some View {
        Button {

            shouldShowNewMessageScreen.toggle()
            
        } label: {
            HStack {
                Spacer()
                Text(" + New Chat ")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.teal)
                .frame(width: 150, height: 50, alignment: .trailing)
                .cornerRadius(32)
                .padding(.horizontal)
                .padding(.vertical)
                .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            
            CreateNewMessageView(didSelectnewUser:{ user in
            
                self.shouldNavigateToChatLogView.toggle()
                print(user.email)
                self.chatUser = user
                
                
            })
        }
    }
    
    @State var chatUser: ChatUser?
}



//struct MainMessengerView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMessengerView()
//    }
//}
