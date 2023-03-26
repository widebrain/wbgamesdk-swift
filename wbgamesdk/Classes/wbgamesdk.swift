import Foundation
import UIKit
import WebKit

 
public struct GameSDK {
    
    static var companyCode = "";
    
    // api에서 받는 주소
    static var gameUrl = "";
    static var video_key = "";
    static var banner_key = "";
    static var app_key = "";
    static var viewController: UIViewController?
    static var frame: CGRect?

    public static func getGameUrl() -> String {
        return gameUrl
    }

    public static func setProductKey(with key:String) {
        companyCode = key
    }
    
    public static func initialize(in viewController: UIViewController, frame: CGRect? = nil) {
        GameSDK.viewController = viewController
        GameSDK.frame = frame
        
        fetchPosts()
    }

    //api 호출
    static func fetchPosts() {
        guard let url = URL(string: "https://www.metaful.kr/api/company?code=" + companyCode) else {
                print("Error: Invalid URL")
                return
            }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: No data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                print("Error: Invalid response")
                return
            }
            do {
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Error: Failed to parse JSON data as array")
                    return
                }
                
                // 데이터는 배열 안에 하나의 딕셔너리로 이루어져 있으므로 첫 번째 딕셔너리를 가져옵니다.
                guard let firstDict = jsonArray.first else {
                    print("Error: No data in JSON array")
                    return
                }
                
                // "games" 키의 값은 또 다시 배열 형태이므로, 해당 배열을 가져옵니다.
                guard let gamesArray = firstDict["games"] as? [[String: Any]] else {
                    print("Error: Failed to get games from JSON data")
                    return
                }
                
                guard let dataObject = firstDict["data"] as? [String: Any] else {
                        print("Error: Failed to get data from JSON data")
                        return
                }
               
                guard let appKey = dataObject["app_key"] as? String else {
                    print("Error: Failed to get first game URL from JSON data")
                    return
                }
                
                guard let videoKey = dataObject["video_key"] as? String else {
                    print("Error: Failed to get first videoKey from JSON data")
                    return
                }
                
                guard let bannerKey = dataObject["banner_key"] as? String else {
                    print("Error: Failed to get first bannerKey from JSON data")
                    return
                }
                
                guard let firstGameURL = gamesArray.first?["url"] as? String else {
                    print("Error: Failed to get first game URL from JSON data")
                    return
                }
                
                GameSDK.gameUrl = firstGameURL;
                GameSDK.app_key = appKey;
                GameSDK.video_key = videoKey;
                GameSDK.banner_key = bannerKey;
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    // 광고 호출 (다음버전)
    
}
