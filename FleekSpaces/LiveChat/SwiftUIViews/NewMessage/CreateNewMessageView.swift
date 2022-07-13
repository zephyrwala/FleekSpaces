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
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                    }
                    
                })
            }
        
    }
    
}

struct CreateNewMessageView: View {
    
    let didSelectnewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
//                HStack {
//                    Text(vm.errorMessage)
//                        .font(.system(size: 9))
//                        .padding(.horizontal)
//                    Spacer()
//                }.padding()
                VStack(alignment: .leading, spacing: 9) {
                    
                    Text("Invite friends and start chatting!")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.init("BtnGreenColor")))
                    
                    Text("Geek out about your favourite Movies and TV Shows only on Feek Spaces")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.trailing)
//                        .fontWeight(.light)
//                        .foregroundColor(.lightGray)
                }.padding()
                    .padding(.bottom)
                
                
                ForEach(vm.users) { user in
                    
                    Button{
                        presentationMode.wrappedValue.dismiss()
                        didSelectnewUser(user)
                        
                    } label: {
                        
                        
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.gray),
                                           lineWidth: 1)
                                )
                                
                           
                            Text(user.email)
                                .foregroundColor(Color(.init("CoinMessageColor")))
                            Spacer()
                        }.padding(.horizontal)
     
                        
                    }
                    Divider()
                        .padding(.vertical, 6)
                    
               
                }
            }.navigationTitle("New Message")
                .background(Color(.init("BGColor")))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                                .foregroundColor(Color(.init("BtnGreenColor")))
                        }
                    }
                }
        }
        
    }
}

//struct CreateNewMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewMessageView(didSelectnewUser: {
//
//            _ in
//
//            print("wow")
//        })
//    }
//}
