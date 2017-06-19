//
//  Functions.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 18.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import Dispatch

let applicationDocumentDirectory: URL = {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
}()

let MyMannagedObjectContextSaveDidFailNotification = Notification.Name(rawValue: "MyMannagedObjectContextSaveDidFailNotification")

func fatalCoreDataError(_ error: Error) {
    print("***Fatal error: \(error)")
    NotificationCenter.default.post(name: MyMannagedObjectContextSaveDidFailNotification, object: nil)
}

func afterDelay(_ seconds: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now()+seconds, execute: closure)
}


