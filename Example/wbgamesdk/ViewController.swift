//
//  ViewController.swift
//  wbgamesdk
//
//  Created by hyunsu on 03/25/2023.
//  Copyright (c) 2023 hyunsu. All rights reserved.
//

import UIKit
import wbgamesdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GameSDK.setProductKey(with: "cgv_01")
        GameSDK.initialize(in: self)
         
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // 2초 후에 실행될 코드
            GameSDK.Game.start()
        }
         
        // GameSDK 라이브러리의 showWebView 함수를 호출하여 웹 뷰를 추가합니다.
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

