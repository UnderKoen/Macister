//
//  Asset.swift
//  Macister
//
//  Created by Koen van Staveren on 20/03/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class Asset: NSObject {
    let name:String;
    let parrent:URL;
    let selfUrl:URL;
    private var fileManager:FileManager;
    
    init(name:String, parrent:URL) {
        self.name = name;
        self.parrent = parrent;
        self.selfUrl = parrent.appendingPathComponent(name);
        self.fileManager = FileManager.default;
    }
    
    func exists() -> Bool {
        return fileManager.fileExists(atPath: selfUrl.path);
    }
    
    func create() {
        fileManager.createFile(atPath: selfUrl.path, contents: nil, attributes: nil);
    }
    
    func remove() {
        do {
            try fileManager.removeItem(at: selfUrl);
        } catch {}
    }
    
    func getData() -> Data? {
        return fileManager.contents(atPath: selfUrl.path);
    }
    
    func setData(data:Data?) {
        do {
            try data?.write(to: selfUrl);
        } catch {}
    }
}
