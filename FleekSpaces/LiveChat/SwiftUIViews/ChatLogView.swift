//
//  ChatLogView.swift
//  FleekSpaces
//
//  Created by Mayur P on 07/07/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let email = "email"
    static let uid = "uid"
    static let profileImageUrl = "profileImageUrl"
    static let messages = "messages"
    static let users = "users"
    static let recentMessages = "recent_messages"
}

struct ChatMessage: Identifiable {
    
    var id: String {
        
        documentId
    }
    
    let documentId: String
    let fromId, toId, text: String
    init(documentId: String, data:[String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        
    }
    
}

class ChatLogViewModel: ObservableObject {
    
  
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()

    var chatUser: ChatUser?

    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
        
    }
    
    var firestoreListener: ListenerRegistration?
    
    //MARK: - Fetch messages
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timeStamp")
            .addSnapshotListener { querySnapshot, err in
            if let error = err {
                self.errorMessage = "Failed to listen for messages"
                print("Snapshot Error is here : \(error)")
                return
            }
            //message is recieved here
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                }
                
            })
            
                DispatchQueue.main.async {
                    self.count += 1
                }
               

        }
    }
    
    
    //MARK: - Send Button
    func handleSend() {
        
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        
       let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).document()
        
        let messageData = [FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: self.chatText, "timeStamp": Timestamp()] as [String : Any]
        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore : \(error)"
                return
            }
            
            print("Sucess saved current user sending message")
            
            self.persistRecentMessage()
            //clear chat text
            self.chatText = ""
            //message auto scroll
            self.count += 1
            
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages").document(toId).collection(fromId).document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore : \(error)"
                return
            }
            
            print("Sucess saved recipient user receiving message")

            
        }
    }
    
    //MARK: - Persist Recent Messages
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    @Published var count = 0
    
}


struct ChatLogView: View {

//    let chatUser: ChatUser?
//
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        self.vm = .init(chatUser: chatUser)
//    }
//
    @ObservedObject var vm: ChatLogViewModel

    
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
//        vm.chatUser?.email.
            .navigationTitle(vm.chatUser?.email.components(separatedBy: "@").first ?? "loading...")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .accentColor(Color(.init("BtnGreenColor")))
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }

    static let emptyScrollToString = "empty"
    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    
                    VStack {
                        
                        ForEach(vm.chatMessages) { message in
                                //code comes here
                            MessageView(message: message)
                        }

                        HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        
                    }
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                        
                        
                    }
                    
                   
                     
                }
                
               
            }
            .background(Color(.init("BGColor")))
            .safeAreaInset(edge: .bottom) {
                chatBottomBar.background(Color(.init("BGColor")))
                    .ignoresSafeArea()
        }
        }

    }

    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.3 : 1)
            }
            .frame(height: 40)
            .cornerRadius(12)

            Button {
                //send button comes here
                vm.handleSend()

            } label: {
                Image(systemName: "chevron.forward.square.fill")
                    .font(.system(size: 27))
                    .foregroundColor(Color(.darkGray))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
//            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
//        .background(.ultraThinMaterial)
        .colorScheme(.dark)
        
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    var body: some View {
        
        
        VStack {
            
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(.init("BtnGreenColor")))
                    .cornerRadius(15)
                }
               
                
            } else {
                
                HStack {
                   
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    //BorderColor
                    .background(Color(.init("BorderColor")))
                    .cornerRadius(15)
                    Spacer()
                }
              
                
            }
            
        }  .padding(.horizontal)
            .padding(.top, 8)
        
    }
}
private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Start a conversation...")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }.cornerRadius(12)
            .background(Color(.init("BGColor")))
           
    }
}
