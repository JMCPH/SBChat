//
//  DispatchQueue+Extensions.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 6/24/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import Foundation

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

    static func main(delay: Double = 0.0, main: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            main?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
