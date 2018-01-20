//
//  Repository.swift
//  trending-repos
//
//  Created by nabila on 1/20/18.
//  Copyright © 2018 nabila. All rights reserved.
//

import Foundation

class Repository {
    
    var name: String?
    var desc: String?
    var ownerAvatarUrl: String?
    var ownerName: String?
    var stars: Int?
    
    
    init(name: String?, desc: String?, ownerAvatarUrl: String?, ownerName: String?, stars: Int?) {
        self.name = name
        self.desc = desc
        self.ownerAvatarUrl = ownerAvatarUrl
        self.ownerName = ownerName
        self.stars = stars
    }
}
