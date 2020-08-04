//
//  RickAndMortyClient.swift
//  RickAndMorty
//
//  Created by Paul Cristian Percca Julca on 7/29/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation
import UIKit

class RickAndMortyClient {
    
    enum Endpoints {
        static let base = "https://rickandmortyapi.com/api"
        
        case getCharacters(Int)
        case getCharacter(Int)
        case getEpisodes(Int)
        case getEpisode(Int)
        case getLocations(Int)
        case getLocation(Int)

        var stringValue: String {
            switch self {
            case .getCharacters(let page): return Endpoints.base + "/character/" + "?page=\(page)"
            case .getCharacter(let id): return Endpoints.base + "/character/\(id)"
            case .getEpisodes(let page): return Endpoints.base + "/episode/" + "?page=\(page)"
            case .getEpisode(let id): return Endpoints.base + "/episode/\(id)"
            case .getLocations(let page): return Endpoints.base + "/location/" + "?page=\(page)"
            case .getLocation(let id): return Endpoints.base + "/location/\(id)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getCharacters(page: Int, completion: @escaping (CharactersResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getCharacters(page).url, responseType: CharactersResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getCharacter(id: Int?, urlPath: String?, index: Int?, completion: @escaping (CharacterResponse?, Error?, Int?) -> Void) {
        let url: URL
        if let urlPath = urlPath {
            url =  URL(string: urlPath)!
        } else {
            url = Endpoints.getCharacter(id!).url
        }
        taskForGETRequest(url: url, responseType: CharacterResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil, index)
            } else {
                completion(nil, error, nil)
            }
        }
    }
    
    class func getEpisodes(page: Int, completion: @escaping (EpisodesResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getEpisodes(page).url, responseType: EpisodesResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
                
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getEpisode(id: Int?, urlPath: String?, completion: @escaping (EpisodeResponse?, Error?) -> Void) {
        let url: URL
        if let urlPath = urlPath {
            url =  URL(string: urlPath)!
        } else {
            url = Endpoints.getEpisode(id!).url
        }
        taskForGETRequest(url: url, responseType: EpisodeResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getLocations(page: Int, completion: @escaping (LocationsResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getLocations(page).url, responseType: LocationsResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
//    class func search(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionTask {
//        let task = taskForGETRequest(url: Endpoints.search(query).url, responseType: MovieResults.self) { (response, error) in
//            if let response = response {
//                completion(response.results, nil)
//            } else {
//                completion([], error)
//            }
//        }
//        return task
//    }
    
    class func getImage(path: String, index: Int, completionHandler: @escaping (UIImage?, Error?, Int) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: path)!, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error, index)
                return
            }
            let downloadImage = UIImage(data: data)
            completionHandler(downloadImage, nil, index)
        })
        task.resume()
    }
    
    class func getImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: path)!) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
//        print(url.absoluteString)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
}
