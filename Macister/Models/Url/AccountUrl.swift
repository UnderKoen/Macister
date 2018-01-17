//
// Created by Koen van Staveren on 17/01/2018.
// Copyright (c) 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class AccountUrl: NSObject {
    var accountId: Int?

    func setAccountId(accountId: Int) {
        self.accountId = accountId
    }

    func getAccountUrl() -> String {
        return getApiUrl() + "accounts/\(accountId!)"
    }
}
