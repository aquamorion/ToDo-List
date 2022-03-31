//
//  API.swift
//  ToDo-List
//
//  Created by student on 2022/3/31.
//

import Foundation

protocol APIDelegate: AnyObject {
    func circularLoadingAnimation()
    func itemOfToDoListSubmited()
}

class API {
    
    weak var delegate: APIDelegate?
    
    static let shared = API()
    
    private init() {}
    
    func callAPI() {
        delegate?.circularLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            if let url = URL(string: "https://reqres.in/api/users/2") {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    print("Call API success")
                    DispatchQueue.main.async {
                        self.delegate?.itemOfToDoListSubmited()
                    }
                }.resume()
            }
        }
    }
}
