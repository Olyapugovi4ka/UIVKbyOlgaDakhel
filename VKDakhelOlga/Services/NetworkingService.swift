//
//  NetworkingService.swift
//  VKDakhelOlga
//
//  Created by MacBook on 21/05/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import Foundation
import Alamofire
import  SwiftyJSON

class NetworkingService{
    
    //MARK: - Session
    static let session: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        let session = SessionManager(configuration: config)
        return session
    }()
    
    private let baseUrl = "https://api.vk.com"
    private let token: String
    private var activeRequest: DataRequest?
    private let vkVersion: String = "5.101"
    
    init(token:String) {
        self.token = token
    }
    
    //MARK: - List of groups
    func loadGroups(completion: @escaping (Swift.Result<[Group], Error>) -> Void){
        guard let token = Account.shared.token else { return }
        
        let path = "/method/groups.get"
        let params: Parameters = [
            "access_token" : token,
            "extended": 1,
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result{
            case.success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue.map {Group($0)}
                completion(.success(groups))
            case.failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    //MARK: - List of friends
    func loadFriends(completion: @escaping (Swift.Result<[User],Error>) -> Void) {
        guard let token = Account.shared.token else { return }
        
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token" : token,
            "fields": "nickname, photo_200_orig",
            "extended": 1,
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let users = json["response"]["items"].arrayValue.map {User($0)}
                completion(.success (users))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Photos of user
    func loadPhotos(_ userId: Int, completion: ((Swift.Result <[Photo], Error>) -> Void)? = nil){
        //guard let token = Account.shared.token else { return }
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "access_token" : token,
            "owner_id" : userId,
            "extended": 1,
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let photos = json["response"]["items"].arrayValue.map {Photo ($0)}
                completion?(.success(photos))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Searching of groups
    func loadSearchGroups (query queryString: String, completion: @escaping (Swift.Result <[Group], Error>) -> Void) {
        guard let token = Account.shared.token else { return }
        activeRequest?.cancel()
        let path = "/method/groups.search"
        let params: Parameters = [
            "access_token" : token,
            "q" : queryString,
            "v": vkVersion]
        
        activeRequest = NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result{
            case.success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue.map {Group($0)}
                completion(.success(groups))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Fetching of news
    func loadNews(startFrom: String ,completion: @escaping (Swift.Result<NewsResponse,Error>)-> Void) {
        guard let token = Account.shared.token else { return }
        
        let path = "/method/newsfeed.get"
        let params: Parameters = [
            "access_token" : token,
            "startFrom": startFrom,
            "fields": "post",
            "extended": 1,
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                var news = [News]()
                var users = [User]()
                var groups = [Group]()
                var nextFrom = ""
                let newsResponse = NewsResponse(users: users, groups: groups, news: news, nextFrom: nextFrom)
                let dispatchGroup = DispatchGroup()
                DispatchQueue.global().async(group: dispatchGroup) {
                
                 news = json["response"]["items"].arrayValue.map {News($0)}
                }
                DispatchQueue.global().async(group: dispatchGroup) {
                groups = json["response"]["groups"].arrayValue.map {Group($0)}
                }
                DispatchQueue.global().async(group: dispatchGroup) {
                    users = json["response"]["profiles"].arrayValue.map{User($0)}
                }
                DispatchQueue.global().async(group: dispatchGroup) {
                   nextFrom = json["response"]["next_from"].stringValue
                }
                
                dispatchGroup.notify(queue: .main){
                completion(.success (newsResponse))
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    //MARK: - Request for operations
    func friendsRequest() -> DataRequest {
        let token = Account.shared.token!
        
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token" : token,
            "fields": "nickname, photo_200_orig",
            "extended": 1,
            "v": vkVersion ]
        
        return NetworkingService.session.request(baseUrl + path, method: .get, parameters: params)
    }
    
    //MARK: - Fetching chats
    func getConversations (completion: @escaping (Swift.Result <[Chat],Error>)-> Void){
        guard let token = Account.shared.token else { return }
        
        let path = "/method/messages.getConversations"
        let params: Parameters = [
            "access_token" : token,
            "extended": 1,
            "v": vkVersion ]
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                print(json)
                var chats = [Chat]()
                
                let dispatchGroup = DispatchGroup()
                DispatchQueue.global().async(group: dispatchGroup) {
                    chats = json["response"]["items"].arrayValue.map { Chat($0) }
                }
                print(chats)
                DispatchQueue.global().async(group: dispatchGroup) {
                    let users = json["response"]["profiles"].arrayValue.map { User($0) }
                    print(users)
                    let _ = try? RealmProvider.save(items: users)
                }
                DispatchQueue.global().async(group: dispatchGroup) {
                    let groups = json["response"]["groups"].arrayValue.map { Group($0) }
                    print(groups)
                    let _ = try? RealmProvider.save(items: groups)
                }
                dispatchGroup.notify(queue: .main){
                    completion(.success(chats))
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMessages(chatId: Int, completion: @escaping (Swift.Result<[Message],Error>)-> Void){
        guard let token = Account.shared.token else { return }
        let path = "/method/messages.getHistory"
        let params: Parameters = [
            "access_token" : token,
            "extended": 1,
            "peer_id": chatId,
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let messages = json["response"]["items"].arrayValue
                    .filter {$0["action"].isEmpty}
                    .map {Message($0)}
                
                DispatchQueue.main.async {
                    completion(.success(messages))
                }
                
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func send(text: String, to chatId: Int, completion: ((Error?) -> Void)? = nil) {
        guard let token = Account.shared.token else { return }
        let path = "/method/messages.send"
        let params: Parameters = [
            "access_token" : token,
            "extended": 1,
            "peer_id": chatId,
            "message": text,
            "random_id": Int.random(in: 0...1000_000),
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .post, parameters: params).responseJSON(queue: .global()) { response in

            completion?(response.error)
        }
    }
    
    public func getLongPollServer() {
        
        guard let token = Account.shared.token else { return }
        let path = "/method/messages.getLongPollServer"
        let params: Parameters = [
            "access_token" : token,
            "need_pts": 1,
            "lp_version": 3,
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result{
            case.success(let value):
                let json = JSON(value)
               Account.shared.longPoll.server = json["response"]["server"].stringValue
               Account.shared.longPoll.ts = json["response"]["ts"].doubleValue
               Account.shared.longPoll.pts = json["response"]["pts"].intValue
               Account.shared.longPoll.key = json["response"]["key"].stringValue
            case .failure:
                break
                
            }
        }
    }
    
    public func receiveUpdates(for chatId:Int, completion : @escaping (Result<Message>) -> Void){
       // guard let token = Account.shared.token else { return }
        let url = "https://\(Account.shared.longPoll.server)"
        
        let params: Parameters = [
            "act" : "a_check",
            "key" : Account.shared.longPoll.key,
            "ts" : Account.shared.longPoll.ts,
            "wait" : 25,
            "mode" : 2,
            "version" : 3
            
        ]
        
        NetworkingService.session.request(url, method: .get, parameters: params).responseJSON { response in
            switch response.result{
            case.success(let value):
                let json = JSON(value)
                Account.shared.longPoll.ts = json["ts"].doubleValue
                let messageIds = json["updates"].arrayValue
                    .filter { $0[0].intValue == 4 }
                    .filter { $0[3].intValue == chatId }
                    .map ({ $0[1].intValue })
                messageIds.forEach { self.getMessage(by: $0, completion: completion) }
                 print(messageIds)  
            case.failure:
                break
    }
}
}
    public func getMessage(by id: Int, completion : @escaping (Result<Message>)-> Void) {
        guard let token = Account.shared.token else { return }
        let path = "/method/messages.getById"
        let params: Parameters = [
            "access_token" : token,
            "message_ids": id,
            "v": vkVersion ]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result{
            case.success(let value):
                let json = JSON(value)
                guard let message = json["response"]["items"].arrayValue.map ({Message($0)}).first else { return }
                //DispatchQueue.main.async {
                    completion(.success(message))
               // }
            case.failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}
