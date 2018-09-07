//
// Created by Koen van Staveren on 17/01/2018.
// Copyright (c) 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class AccountUrl: NSObject {
    var account: Account
    var schoolUrl: SchoolUrl

    init(account: Account, schoolUrl: SchoolUrl) {
        self.account = account
        self.schoolUrl = schoolUrl
    }

    func getAccountUrl() -> String {
        return schoolUrl.getApiUrl() + "accounts/\(account.id!)/"
    }
}
