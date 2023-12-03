//
//  APIServices.swift
//  Munch
//
//  Created by Koji Kimura on 10/28/23.
//

import Foundation
import SwiftUI


let LOCALHOST_URL_BASE = "http://127.0.0.1:5000"
let ENDPOINT_IMAGE_UPLOAD = "/img_upload"
let ENDPOINT_MODEL = "/model"


class APIServices {
    static let shared = APIServices()
    
    func loadResources<T:Decodable>(from path: String, onSuccess: @escaping (T)->Void, onError: @escaping (APIError)-> Void) {

        DispatchQueue.global().async {
            guard let url = URL(string: path) else {
                onError(APIError.invalidURL(path))
                return
            }
 
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        onError(APIError.taskFailed(error.localizedDescription))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        onError(APIError.invalidData)
                    }
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        onError(APIError.invalidResponse)
                    }
                    return
                }
                
                
                do {
                    if response.statusCode >= 200 && response.statusCode < 300 {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            onSuccess(decodedData)
                        }
                    } else {
                        onError(APIError.responseError(response.statusCode))
                    }
                }
                catch let error {
                    switch error {
                    case DecodingError.typeMismatch(let key, let value):
                        print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case DecodingError.valueNotFound(let key, let value):
                        print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case DecodingError.keyNotFound(let key, let value):
                        print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                    case DecodingError.dataCorrupted(let key):
                        print("error \(key), and ERROR: \(error.localizedDescription)")
                    default:
                        onError(APIError.unknown(error.localizedDescription))
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func loadNutrients(food: String, onSuccess: @escaping (Nutrients)->Void){
        
        loadResources(from: "\(URL_NUTRIENTS)?food=\(food)", onSuccess: onSuccess) { error in
            debugPrint(error.errorMessage)
        }
        
    }
    
    func runModel(food_id: String, onSuccess: @escaping (Food_Name)->Void){
        
        loadResources(from: "\(LOCALHOST_URL_BASE)\(ENDPOINT_MODEL)/\(food_id)", onSuccess: onSuccess) { error in
            debugPrint(error.errorMessage)
        }
        
    }
    
    func postImage(image: Image, onSuccess: @escaping (Food_Id)->Void){
        
        debugPrint("Posting")
        let uiImage: UIImage = image.asUIImage()
           
        var request = URLRequest(url: URL(string: "\(LOCALHOST_URL_BASE)\(ENDPOINT_IMAGE_UPLOAD)")!)
        request.httpMethod = "POST"

        // Generate a boundary string for the multi-part form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create a data object for the multi-part form body
        var bodyData = Data()

        // Add the image file data to the request body
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)

        if let imageData = uiImage.jpegData(compressionQuality: 0.9) {
            bodyData.append(imageData)
        }

        bodyData.append("\r\n".data(using: .utf8)!)

        // Add the closing boundary
        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)

        // Set the request body
        request.httpBody = bodyData
        
           URLSession.shared.dataTask(with: request) { data, response, error in
               // Handle the response from the server
               if let error = error {
                   print("Error: \(error)")
               } else if let data = data {
                   // Process the response data if needed
                   print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                   do {
                       let decoder = JSONDecoder()
                       let decodedData = try decoder.decode(Food_Id.self, from: data)
                       DispatchQueue.main.async {
                           onSuccess(decodedData)
                       } }
                   catch {

                   }
               }

           }.resume()
           
       }


}
