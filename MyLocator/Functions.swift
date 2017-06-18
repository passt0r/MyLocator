//
//  Functions.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 18.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import Dispatch

func afterDelay(_ seconds: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now()+seconds, execute: closure)
}
