//
//  TraktHTTPClient.swift
//  movileup
//
//  Created by iOS on 7/22/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import Foundation
import Alamofire


class TraktHTTPClient {
    
    private lazy var manager: Alamofire.Manager = {
        let configuration: NSURLSessionConfiguration = {
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            var headers = Alamofire.Manager.defaultHTTPHeaders
            headers["Accept-Encoding"] = "gzip"
            headers["Content-Type"] = "application/json"
            headers["trakt-api-version"] = "2"
            headers["trakt-api-key"] = "0516d3c5f2d51c241eff969d3aa647e165e69d910090020e8ccc41b5bd02f7a6"
            configuration.HTTPAdditionalHeaders = headers
            return configuration
            }()
        return Manager(configuration: configuration)
        }()



    internal enum Router: URLRequestConvertible {
        static let baseURLString = "https://api-v2launch.trakt.tv/"
        
        case PopularShows
        case Show(String)
        case Episode(showId: String, season: Int, number:Int)
        case Season(showId: String, season: Int)
        case Episodes(showId: String, season: Int)
        
        // MARK: URLRequestConvertible
        var URLRequest: NSURLRequest {
        let (path: String, parameters: [String: AnyObject]?, method: Alamofire.Method) = {
            
        switch self {
            case .Show(let id): return ("shows/\(id)", ["extended": "images,full"], .GET)
            case .Episode(let id, let season, let episode): return ("shows/\(id)/seasons/\(season)/episodes/\(episode)", ["extended": "images,full"], .GET)
            case .Season(let id, let season): return ("shows/\(id)/seasons/\(season)", ["extended": "images,full"], .GET)
            case .PopularShows: return ("shows/popular", ["limit": 30, "extended": "images"], .GET)
            default: return ("shows/popular", ["extended": "images,full"], .GET)
        }
            }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
    
    
    
    func getJSONElement<T: JSONDecodable>(router: Router, completion: ((Result<T, NSError?>) -> Void)?){
        manager.request(router).validate().responseJSON { (_, _, responseObject, error)  in
        if let json = responseObject as? NSDictionary {
        if let value = T.decode(json) {
        completion?(Result.success(value))
    } else {
        completion?(Result.failure(nil))
        }
    } else {
        completion?(Result.failure(error))
        }
        }
    }
    
    
    
    func getJSONElementArray<T: [JSONDecodable]>(router: Router, completion: ((Result<[T], NSError?>) -> Void)?){
        manager.request(router).validate().responseJSON { (_, _, responseObject, error)  in
        if let jsonArray = responseObject as? [NSDictionary] {
            let values = jsonArray.map { T.decode($0) }.filter { $0 != nil }.map { $0! }
            completion?(Result.success(values))
        } else {
            completion?(Result.failure(error))
        }
        }
    }
    
    
    
    func getShow(id: String, completion: ((Result<Show, NSError?>) -> Void)?) {
            getJSONElement(Router.Show(id), completion: completion)
    }
    
    func getEpisode(showId: String, season: Int, episodeNumber: Int,
            completion: ((Result<Episode, NSError?>) -> Void)?) {
            let router = Router.Episode(showId: showId, season: season,
            number: episodeNumber)
            getJSONElement(router, completion: completion)
    }
    
    func getSeason(showId: String, season: Int, completion: ((Result<Season, NSError?>) -> Void)?) {
        getJSONElement(Router.Season(showId: showId, season: season), completion: completion)
    }
    
    
    
    
    
    
    
    
    
    


   func getPopularShows(completion: ((Result<[Show], NSError?>) -> Void)?) {
        /*var a = [Show]()
        for var i = 0; i < 10; ++i{
            a[i] =
        }
                //let router = Router.PopularShows*/
                getJSONElementArray(Router.PopularShows, completion: completion)
    }
   }

