//
//  request.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/12/24.
//

import Foundation

var url = "localhost:3000"

//public struct ApiResponse: Codable {
//    let bookSearch: String?
//    let uploadTypeID: Int
//    let stackID: String
//    let data: Int
//
//    enum CodingKeys: String, CodingKey {
//        case bookSearch
//        case uploadTypeID = "upload_type_id"
//        case stackID = "stack_id"
//        case data
//    }
//}
//
//func getData() {
//    guard let url = URL(string: "\(url)/book-search?is_prime") else { return }
//    URLSession.shared.dataTask(with: url) { data, _, _ in
//        if let data = data {
//            do {
//                let results = try JSONDecoder().decode(ApiResponse.self, from: data)
//                DispatchQueue.main.async {
//                    // self.datas = results.bookDetails.data
//                    results
//                }
//            }
//            catch {
//                print(error)
//            }
//        }
//    }.resume()
//}
