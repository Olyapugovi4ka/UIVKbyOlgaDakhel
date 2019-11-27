//
//  NetworkingServiceProxy.swift
//  VKDakhelOlga
//
//  Created by Olga Melnik on 26.11.2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import Alamofire
import  SwiftyJSON

class NetworkingServiceProxy: NetworkingServiceProtocol {
    
    lazy private var networkingService = NetworkingService(token: Account.shared.token!)
    
    func friendsRequest() -> DataRequest {
        print("friends was used")
        return self.networkingService.friendsRequest()
        
    }
    func loadGroups(completion: @escaping (Swift.Result<[Group], Error>) -> Void) {
        self.networkingService.loadGroups(completion: completion)
        print("LoadGroups was used")
        
    }
    func loadFriends(completion: @escaping (Swift.Result<[User],Error>) -> Void){
        self.networkingService.loadFriends(completion: completion)
        print("LoadFriends was used")
    }
    func loadPhotos(_ userId: Int, completion: ((Swift.Result <[Photo], Error>) -> Void)?) {
        self.networkingService.loadPhotos(userId)
        print("LoadPhotos was used")
    }
    func loadSearchGroups (query queryString: String, completion: @escaping (Swift.Result <[Group], Error>) -> Void) {
        self.networkingService.loadSearchGroups(query: queryString, completion: completion)
        print("LoadSearchGroups was used")
    }
    func loadNews(startFrom: String ,completion: @escaping (Swift.Result<NewsResponse,Error>)-> Void){
        self.networkingService.loadNews(startFrom: startFrom, completion: completion)
        print("LoadNews was used")
    }
   
    func getConversations (completion: @escaping (Swift.Result <[Chat],Error>)-> Void){
        self.networkingService.getConversations(completion: completion)
        print("GetConversations was used")
    }
    
    func getMessages(chatId: Int, completion: @escaping (Swift.Result<[Message],Error>)-> Void){
        self.networkingService.getMessages(chatId: chatId, completion: completion)
        print("GetMessages was used")
    }

    
}
