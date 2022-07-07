//
//  ChatLogView.swift
//  FleekSpaces
//
//  Created by Mayur P on 07/07/22.
//

import SwiftUI
import Firebase

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
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

    let chatUser: ChatUser?

    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
        
    }
    
    //MARK: - Fetch messages
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        
        FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).addSnapshotListener { querySnapshot, err in
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
            
            //this was appending repeating messages
            
            
//            querySnapshot?.documents.forEach({ queryDocumentSnapshot in
//
//                let data = queryDocumentSnapshot.data()
//                let docId = queryDocumentSnapshot.documentID
//                let chatMessage = ChatMessage(documentId: docId, data: data)
//                self.chatMessages.append(chatMessage)
//
//            })
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
            self.chatText = ""
            
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
    
}


struct ChatLogView: View {

    let chatUser: ChatUser?

    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    @ObservedObject var vm: ChatLogViewModel

    var body: some View {
        ZStack {
            messagesView
            VStack(spacing: 0) {
                Spacer()
                
               
                chatBottomBar
                    .background(Color.white.ignoresSafeArea())
                    .opacity(0.9)
                  
            }
        }
        //chat user name comes over here
        //TODO: - Add chat user name here
        .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }

    private var messagesView: some View {
        ScrollView {
            
            ForEach(vm.chatMessages) { message in

                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(45)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }

            HStack{ Spacer() }
            .frame(height: 50)
        }
        .background(Color(.init(white: 0.95, alpha: 1)))

    }

    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
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
        .background(.ultraThinMaterial)
        
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
        .background(.ultraThinMaterial)
           
    }
}
