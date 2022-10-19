//
//  PushNotificationConfig.swift
//  FleekSpaces
//
//  Created by Mayur P on 18/10/22.
//

import Foundation
import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAelMd8yo:APA91bGRWJS-07pIqvlSRZCCrXpqOAwSI5CY0JZxgo48IP8ml9kuzda1aJG9b68QuJQjaXbYuIYBfEYfL3blEzWNd9M_7Sx2H56KGnGjaXrWAhuQCYHgFUXRjAF2XocdblyAub5NAbfn", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            print("Data is here push\(data)")
            print(String(data: data!, encoding: .utf8)!)
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
                print("Error in notification send \(err)")
            }
        }
        task.resume()
    }
}
