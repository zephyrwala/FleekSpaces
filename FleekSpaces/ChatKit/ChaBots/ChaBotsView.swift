//
//  ChaBotsView.swift
//  FleekSpaces
//
//  Created by Mayur P on 25/02/23.
//

import SwiftUI
import OpenAISwift
import IQKeyboardManagerSwift

//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


private var client: OpenAISwift?

final class ViewModel: ObservableObject {
    init() {}
    
    func setup() {
        
        client = OpenAISwift(authToken: "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")
        
    }
    
    
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 100, completionHandler: { result in
            switch result {
                
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
                
            case .failure(let err):
                print("error in decoding \(err)")
                break
                
            }
        })
    }
    
    
}



struct ChaBotsView: View {
    
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var sending = "send"
    @State var models = [String]()
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10){
            ScrollView{
                ForEach(models, id: \.self) { strings in
                    
                    Text(strings)
                        .foregroundColor(.gray)
                    
                }
            }
            Spacer()
            
            HStack {
                TextField("Ask Spaces bot...", text: $text)
                Button(sending){
                    sends()
                }.foregroundColor(.teal)
            }
            
        }
        .padding()
        .onAppear{
            viewModel.setup()
         
        }
       
        
    }
    
    
    
    func sends() {
//        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
//            return
//        }
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {return}
        guard let safeEmail = userName.components(separatedBy: "@").first else {return}
        
        models.append("-------------------------------------------")
        models.append("\(safeEmail): \(text)")
        models.append("-------------------------------------------")
//        models.append(" ")
        viewModel.send(text: text) { response in
            
            DispatchQueue.main.async {
                
                self.sending = "Sending..."
                self.models.append("🤖 Spaces Bot: \(response)")
                
                self.text = ""
                self.sending = "Send"
            }
            
        }
        
    }
}

struct ChaBotsView_Previews: PreviewProvider {
    static var previews: some View {
        ChaBotsView()
    }
}
