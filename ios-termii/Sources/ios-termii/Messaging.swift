//
//  File.swift
//  termii-ios
//
//  Created by Samson Awu on 05/09/2023.
//

import Foundation

@available(iOS 15.0, *)
public class Messaging {
    
    public init()
    {
        
    }
  
    
    func sendMessage(request: RequestModel) async throws -> ResponseModel? {
        
        let jsonEncoder = JSONEncoder()
        
        let jsonData = try! jsonEncoder.encode(request)
        let body = String(data: jsonData, encoding: String.Encoding.utf8)
        
        guard let url = URL(string: "https://api.ng.termii.com/api/sms/send") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body!.data(using: String.Encoding.utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, [200].contains(response.statusCode) else {
                return nil
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                return try decoder.decode(ResponseModel.self, from: data)
            } catch {
                print(error.localizedDescription)
                return nil
            }
    }

}

public class RequestModel: Encodable {
    
    let to: String = ""
    let from: String = ""
    let sms: String = ""
    let type: String = ""
    let channel: String = ""
    let api_key: String = ""
}

public class ResponseModel: Codable{
    let code: String
    let message_id: String
    let message_id_str: String
    let message: String
    let balance: Double
    let user: String
}
