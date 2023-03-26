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
//    [{"_id":"641bb5354912d4030e139493","title":"cgv_01","code":"cgv_01","games":[{"title":"market","url":"https://xingxing.metaful.kr/game-client/xingxing/market/"},{"title":"게임1","url":"https://xingxing.metaful.kr/game-client/xingxing/luckyclawmachine"},{"title":"게임2","url":"https://xingxing.metaful.kr/game-client/xingxing/luckyclawmachine"}],"data":{"id":"cgv_01","app_key":"726064343","video_key":"BvEQaQYhbbieJSJ","banner_key":"F7nr9SMeNcFNrXk"}}]
    
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
                
                // "_id" 키의 값을 가져옵니다.
                guard let id = firstDict["_id"] as? String else {
                    print("Error: Failed to get id from JSON data")
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
                
//                "app_key":"726064343","video_key":"BvEQaQYhbbieJSJ","banner_key"
               
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
                
                // 가져온 값을 출력합니다.
                print("id: \(id)")
                print(" : \(appKey)")
                print(" : \(videoKey)")
                print(": \(bannerKey)")
                print("first game URL: \(firstGameURL)")
 
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    
    @objc public class Game: NSObject {
      // GameSDK 구조체의 인스턴스 생성
        @objc public static func start() {
            // UIViewController와 WKWebView 객체 생성
            guard let viewController = GameSDK.viewController else {
                return
            }
            let webView = WKWebView()

            // UIView 생성
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            containerView.layer.cornerRadius = 8.0
            containerView.layer.masksToBounds = true

            // 닫기 버튼 생성
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("Close", for: .normal)
    //        closeButton.addTarget(self, action: Selector(("closeButtonTapped")), for: .touchUpInside)
            closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

    //        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

            // UIView와 WKWebView를 UIViewController에 추가
            viewController.view.addSubview(containerView)
            containerView.addSubview(webView)
            containerView.addSubview(closeButton)

            // Auto Layout 설정
            containerView.translatesAutoresizingMaskIntoConstraints = false
            webView.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                containerView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
                containerView.widthAnchor.constraint(equalTo: viewController.view.widthAnchor, multiplier: 0.9),
                containerView.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 0.9),

                closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),

                webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
                webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

            // WKWebView 설정
            let request = URLRequest(url: URL(string: GameSDK.gameUrl)!)
            webView.load(request)
        }
          
        @objc private static func closeButtonTapped() {
            // WKWebView 제거
            print("viewController");
            // ViewController 닫기
                guard let viewController = GameSDK.viewController else {
                    return
                }

                viewController.dismiss(animated: true, completion: nil)

                // containerView 제거
                guard let containerView = viewController.view.subviews.last else {
                    return
                }

                containerView.removeFromSuperview()
        }
      
    }
    
    // 광고 호출 (다음버전)
    
}
