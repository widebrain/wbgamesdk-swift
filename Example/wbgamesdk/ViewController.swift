//
//  ViewController.swift
//  wbgamesdk
//
//  Created by hyunsu on 03/25/2023.
//  Copyright (c) 2023 hyunsu. All rights reserved.
//

import UIKit
import wbgamesdk
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GameSDK.setProductKey(with: "cgv_01")
        GameSDK.initialize(in: self)
         
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // 2초 후에 실행될 코드
            print(GameSDK.getGameUrl())
            self.start()
        }
    }
    
    @objc public func start() {
        // UIViewController와 WKWebView 객체 생성
         
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
        self.view.addSubview(containerView)
        containerView.addSubview(webView)
        containerView.addSubview(closeButton)

        // Auto Layout 설정
        containerView.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9),

            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),

            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        // WKWebView 설정
        let request = URLRequest(url: URL(string: GameSDK.getGameUrl())!)
        webView.load(request)
    }
      
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)

        // containerView 제거
        guard let containerView = self.view.subviews.last else {
            return
        }

        containerView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

