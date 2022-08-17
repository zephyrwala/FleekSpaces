//
//  CreateNewMessageView.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/07/22.
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    //published var for users array
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    //this fetches the users from Firebase
    init() {
        fetchAllUsers()
    }
    
    //users fetch
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
    //define colums grid item size
    let columns = [
          GridItem(.fixed(170)),
          GridItem(.fixed(170)),
//          GridItem(.fixed(120))
         
      ]
    @Environment(\.presentationMode) var presentationMode
    
    //observed object for the new message view model
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
                //lazy grid setup
                
                LazyVGrid(columns: columns, spacing: 18) {
                    //over here vm.users will fetch the users dynamically via the
                ForEach(vm.users) { user in
                    
                    Button{
                        presentationMode.wrappedValue.dismiss()
                        didSelectnewUser(user)
                        
                    } label: {
                        
                        
                        VStack(spacing: 20) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 66, height: 66)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.gray),
                                           lineWidth: 1)
                                )
                                
                           
                            Text(user.email.components(separatedBy: "@").first ?? "loading...")
                            //vm.chatUser?.email.components(separatedBy: "@").first ?? "loading..."
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(.init("CoinMessageColor")))
                            Spacer()
                        }.padding(.horizontal)
     
                        
                    }
//                    Divider()
//                        .padding(.vertical, 6)
                    
               
                }
                .frame(height: 120)
                }
                //ends here
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
