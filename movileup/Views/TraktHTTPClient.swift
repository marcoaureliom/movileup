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



    private enum Router: URLRequestConvertible {
        static let baseURLString = "https://api-v2launch.trakt.tv/"
        case Show(String)
        // MARK: URLRequestConvertible
        var URLRequest: NSURLRequest {
        let (path: String, parameters: [String: AnyObject]?, method: Alamofire.Method) = {
        switch self {
    case .Show(let id):
        return ("shows/\(id)", ["extended": "images,full"], .GET)
            }
            }()
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: parameters).0
        }
    
    }
    
    
    
    /*func getShow(id: String, completion: ((Result<Show, NSError?>) -> Void)?){
        manager.request(Router.Show(id)).validate().responseJSON { (_, _, responseObject, error) in
            if let json = responseObject as? NSDictionary {
                if let show = Show.decode(json) {
                    completion?(Result.success(show))
                } else {
                    completion?(Result.failure(nil))
                }
            } else {
                completion?(Result.failure(error))
            }
        }
    }
    
    
      func getEpisode(showId: String, season: Int, episodeNumber: Int, completion: ((Result<Episode, NSError?>) -> Void)?){
            manager.request(router).validate().responseJSON{ (_,_, responseObject, error) in
            if let json = responseObject as? NSDictionary {
                    if let episode = Episode.decode(json){
                        completion?(Result.sucess(episode))
                    } else {
                    completion?(Result.failure(nil))
                    }
                } else {
                    completion?(Result.failure(error))
                }
            }
      }*/
    
    


}