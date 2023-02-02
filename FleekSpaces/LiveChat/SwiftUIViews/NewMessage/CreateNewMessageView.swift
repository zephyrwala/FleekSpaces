//
//  CreateNewMessageView.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/07/22.
//

import SwiftUI
import SDWebImageSwiftUI
import ActivityView

class CreateNewMessageViewModel: ObservableObject {
    
    //published var for users array
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    //this fetches the users from Firebase
    init() {
        fetchAllUsers()
    }
    
    func shareto() {
        
        let shareText = "👋🏻 Hey there! Let's discover some cool movies & TV shows on Fleek Spaces 🍿 on https://getfleek.app/"
        let textShare = [shareText]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.view
//            self.present(activityViewController, animated: true, completion: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true)
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


//struct ActivityView: UIViewControllerRepresentable {
//    var url: String
//    @Binding var showing: Bool
//
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        let vc = UIActivityViewController(
//            activityItems: [NSURL(string: url)!],
//            applicationActivities: nil
//        )
//        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
//            self.showing = false
//        }
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
//    }
//}

struct CreateNewMessageView: View {
    
    @State private var item: ActivityItem?
    @State var showSheet = false
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
    
    func shareto() {
        
        let shareText = "👋🏻 Hey Bro! I'm inviting you to chat 💬 with me on Fleek Spaces 🍿 on https://getfleek.app/"
        let textShare = [shareText]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)

    }
    
    
    let link = URL(string: "https://www.hackingwithswift.com")!
    
    
    
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
                    Button {

                        item = ActivityItem(
                                   items: "👋🏻 Hey there! I'm inviting you to chat 💬 with me on Fleek Spaces 🍿 on https://apps.apple.com/in/app/fleekspaces/id1631251801"
                               )
                     

                    } label: {
                        HStack{
                            Image(systemName: "person.crop.circle.badge.plus")
                                .foregroundColor(Color("CoinMessageColor"))
                            Text("Invite Friends")
                                .foregroundColor(Color("CoinMessageColor"))
                        }
                        
                    }.activitySheet($item)

                        .padding(.bottom)
                    
                    Text("Start chatting with \(vm.users.count) friends!")
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
                
//                LazyVGrid(columns: columns, spacing: 18) {
                    //over here vm.users will fetch the users dynamically via the
                ForEach(vm.users) { user in
                    
                    Button{
                        presentationMode.wrappedValue.dismiss()
                        didSelectnewUser(user)
                        
                    } label: {
                        
                        
                        HStack(spacing: 20) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 42, height: 42)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.gray),
                                           lineWidth: 1)
                                )
                                
                           
                            Text(user.email.components(separatedBy: "@").first ?? "loading...")
                            //vm.chatUser?.email.components(separatedBy: "@").first ?? "loading..."
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                                .foregroundColor(Color(.init("CoinMessageColor")))
                            Spacer()
                        }.padding(.horizontal)
     
                        
                    }
//                    Divider()
//                        .padding(.vertical, 6)
                    
               
                }
                .frame(height: 50)
                
                //ends here
            }.navigationTitle("New Message 💬 ")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(.init("BGColor")))
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                           Image(systemName: "chevron.left")
                                .foregroundColor(Color(.init("CoinMessageColor")))
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
