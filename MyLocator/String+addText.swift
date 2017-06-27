//
//  String+addText.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 27.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation

extension String {
    mutating  func add(text: String?, separatedBy separator: String = ""){
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
