//
//  DataSource.swift
//  Todo
//
//  Created by 尹久盼 on 06/09/2017.
//  Copyright © 2017 尹久盼. All rights reserved.
//

import Foundation

struct DataStore {
    static public let shared = DataStore()
    
    private init() {
    }
    
    let items = ["fix bugs", "test bugs"]
    
    public func fetchItems(completionHandler: (([String]) -> Void)?)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler?(self.items)
        }
    }
}
