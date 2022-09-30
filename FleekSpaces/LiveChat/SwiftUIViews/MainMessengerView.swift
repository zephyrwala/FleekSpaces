//
//  MainMessengerView.swift
//  FleekSpaces
//
//  Created by Mayur P on 05/07/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift




struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}


class MainMessageViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isCurrentlyLoggedOut = false
   
    
    
    
    init() {

        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
           
        }
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    //MARK: - Fetch recent Messages
     func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
         firestoreListener?.remove()
         self.recentMessages.removeAll()
        
       firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    print("failed to listen to recent messages \(error)")
                    self.errorMessage = "failed to listen to recent messages \(error)"
                    return
                }
                
                
                querySnapshot?.documentChanges.forEach({ change in
                    

                        let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        
                        return rm.id == docId
                    })
                    {
                        self.recentMessages.remove(at: index)
                    }
                   
                    
                    do {
                        
                        let rm = try change.document.data(as: RecentMessage.self)
                        self.recentMessages.insert(rm, at: 0)
                        
                    } catch {
                        
                        print(error)
                    }
                  
                    
                    
                    
                    
               
                })
            }
        
    }
   
    
    //MARK: - Fetch Current user
    func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
        }
    }
   
    
    //MARK: - Handle sign out here
    func handleSignOut() {
        NotificationCenter.default.post(name: NSNotification.Name("dismissSwiftUI"), object: nil)
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
        
        
       
        
    }
    
}


struct MainMessagesView: View {

    @State var shouldShowNewMessageScreen = false
    @State var shouldShowLogOutOptions = false
  

    @ObservedObject private var vm = MainMessageViewModel()
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    
    var body: some View {
        NavigationView {

            VStack {
                customNavBar
                messagesView
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {

                    ChatLogView(vm: chatLogViewModel)
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
            .background(Color(.init("BGColor")))
            //BtnGreenColor
        }.accentColor(Color(.init("BtnGreenColor")))
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {

            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? "")).resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.init("CoinMessageColor")), lineWidth: 1.2)
                )
                .shadow(radius: 5)
        


            VStack(alignment: .leading, spacing: 4) {
                let email = vm.chatUser?.email.components(separatedBy: "@").first ?? "loading..."
                Text(email)
                    .font(.system(size: 21, weight: .bold))
                    .foregroundColor(Color(.init("BtnGreenColor")))


                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 9, height: 9)
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
                    .foregroundColor(Color(.darkGray))
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
            
            //TODO: - Main login process
            
            
//            LoginView {
//                self.vm.isCurrentlyLoggedOut = false
//                self.vm.fetchCurrentUser()
//                self.vm.fetchRecentMessages()
//            }
            
            
           
            
            
            
        }
    }
    
    @State var shouldNavigateToChatLogView = false
   


    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                        
                        self.chatUser = .init(id: uid, uid: uid, email: recentMessage.email, profileImageUrl: recentMessage.profileImageUrl)
                        
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color(.init("CoinMessageColor")), lineWidth: 1))
                                .shadow(radius: 5)
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.username)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.init("CoinMessageColor")))
                                    .multilineTextAlignment(.leading)
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            
                            Text(recentMessage.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.init("BtnGreenColor")))
                               
                        }
                    }


                    
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                    .background(Color(.init("BGColor")))
                
            }.padding(.bottom, 50)
                .background(Color(.init("BGColor")))
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
            .background(Color(.init("BtnGreenColor")))
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
                self.chatLogViewModel.chatUser = user
                self.chatLogViewModel.fetchMessages()
                
                
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
