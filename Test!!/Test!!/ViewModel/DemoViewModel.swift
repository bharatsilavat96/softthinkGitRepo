//
//  DemoViewModel.swift
//  Test!!
//
//  Created by Bharat Shilavat on 03/03/25.
//

import Foundation
import UIKit


class DemoViewModel {
    
    // MARK: - Constants -
    private let urlString = DemoViewControllerContent.Content.urlStr
    var integrationList: DataHanlderBox<MealsResponse> = DataHanlderBox(MealsResponse())

    
    // MARK: - API Calling here -
    func fetchData() {
        NetworkManager.shared.request(
            urlString: urlString,
            method: "GET"
        ) { (result: Result<MealsResponse, NetworkError>) in
            switch result {
            case .success(let data):
                self.integrationList.value = data
               // print("Data received: \(data)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    //MARK: - Downloading Image here -
    func downloadImage(usingUrl urlString: String, completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.downloadImage(from: urlString) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print("Failed to load image: \(error)")
                completion(nil)
            }
        }
    }
    
}
