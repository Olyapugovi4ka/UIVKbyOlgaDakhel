//
//  FetchData.swift
//  VKDakhelOlga
//
//  Created by MacBook on 14/07/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import Alamofire

class FetchDataOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Data?
    
    init(request: DataRequest) {
        self.request = request
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.data = data
            case.failure(let error):
                print(error.localizedDescription)
            }
            self?.state = .finished
        }
    }
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
}
