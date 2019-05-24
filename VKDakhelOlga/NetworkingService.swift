//
//  NetworkingService.swift
//  VKDakhelOlga
//
//  Created by MacBook on 21/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingService{
    
    //MARK: - Session
    static let session: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        let session = SessionManager(configuration: config)
        return session
    }()
    
    //MARK: -List of groups
    func loadGroups(token:String, userId: Int){
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        let params: Parameters = [
            "access_token" : token,
            "user_id" : userId,
            "extended": 1,
            "v":"5.92"]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    
    //MARK: - List of friends
    func loadFriends(token:String, userId: Int){
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token" : token,
            "user_id": userId,
            "order" : "name",
            "extended": 1,
            "v":"5.92"]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    
    //MARK: - Photos of user
    func loadPhotos(token:String, userId: Int ){
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.getAll"
        let params: Parameters = [
            "access_token" : token,
            "owner_id" : userId,
            "extended": 1,
            "v":"5.77"]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    //MARK:
    func loadSearcGroups(token:String, q: String){
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.search"
        let params: Parameters = [
            "access_token" : token,
            "q" : q,
            "v":"5.92"]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    
}
