//: Playground - noun: a place where people can play

import UIKit
// NOTE: Uncommment following two lines for use in a Playground
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely()

let url = NSURL(string: "https://api-v2launch.trakt.tv/shows/game-of-thrones")!
let request = NSMutableURLRequest(URL: url)
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue("2", forHTTPHeaderField: "trakt-api-version")
request.addValue("0516d3c5f2d51c241eff969d3aa647e165e69d910090020e8ccc41b5bd02f7a6", forHTTPHeaderField: "trakt-api-key")

let session = NSURLSession.sharedSession()
let task = session.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
    
    if error != nil {
        // Handle error...
        return
    }
    
    println(error)
    println(response)
    println(NSString(data: data, encoding: NSUTF8StringEncoding))
}

task.resume()







struct Identifiers {
    let trakt: Int
    let tvdb: Int?
    let imdb: String?
    let tmdb: Int?
    let tvrage: Int?
    let slug: String?
}


let ids = Identifiers(trakt: 10001,
    tvdb: 100,
    imdb: nil, tmdb: nil, tvrage: nil, slug: "teste")

struct ImagesURLs{
    let full: NSURL?
    let medium: NSURL?
    let thumb : NSURL?
}

//let images = ImagesURLs()
