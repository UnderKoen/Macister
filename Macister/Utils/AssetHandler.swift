//
//  AssetHandler.swift
//  Macister
//
//  Created by Koen van Staveren on 20/03/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class AssetHandler: NSObject {
    static func createAsset(name: String) -> Asset {
        let asset = Asset(name: name, parrent: FileUtil.getApplicationFolder());
        if !asset.exists() {
            asset.create();
        }
        return asset;
    }

    static func getAsset(name: String) -> Asset {
        return Asset(name: name, parrent: FileUtil.getApplicationFolder());
    }

}
