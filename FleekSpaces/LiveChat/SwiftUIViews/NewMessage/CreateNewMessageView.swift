//
//  CreateNewMessageView.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/07/22.
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                
                if let error = error {
                    
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                self.errorMessage = "Fetched users succesfully"
                
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    
                    let data = snapshot.data()
                    self.users.append(.init(data: data))
                    
                })
            }
        
    }
    
}

struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text(vm.errorMessage)
                        .font(.system(size: 9))
                        .padding(.horizontal)
                    Spacer()
                }
                
                
                ForEach(vm.users) { user in
                    HStack {
                        WebImage(url: URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.label),
                                       lineWidth: 1)
                            )
                            
                       
                        Text(user.email)
                        Spacer()
                    }.padding(.horizontal)
                    Divider()
                        .padding(.vertical, 6)
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.blue)
                        }
                    }
                }
        }
        
    }
}

//struct CreateNewMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewMessageView()
//    }
//}
