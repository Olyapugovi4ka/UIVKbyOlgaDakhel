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
            "v":"5.95"]
        
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
            "v":"5.95"]
        
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
            "v":"5.95"]
        
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
    //MARK:
    func loadSearchGroups (query queryString: String, completion: @escaping (Swift.Result <[Group], Error>) -> Void) {
        guard let token = Account.shared.token else { return }
        activeRequest?.cancel()
        let path = "/method/groups.search"
        let params: Parameters = [
            "access_token" : token,
            "q" : queryString,
            "v":"5.95"]
        
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
    
    func loadNews(completion: @escaping (Swift.Result<NewsResponse,Error>)-> Void) {
        guard let token = Account.shared.token else { return }
        
        let path = "/method/newsfeed.get"
        let params: Parameters = [
            "access_token" : token,
            "fields": "post",
            "extended": 1,
            "v":"5.95"]
        
        NetworkingService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
               // print(json)
           
                let news = json["response"]["items"].arrayValue.map {News($0)}
                print(news.count)
                let groups = json["response"]["groups"].arrayValue.map {Group($0)}
                print(groups.count)
                let users = json["response"]["profiles"].arrayValue.map{User($0)}
                print(users.count)
                let newsResponse = NewsResponse(users: users, groups: groups, news: news)
                completion(.success (newsResponse))
                
            case.failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
