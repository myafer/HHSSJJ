//
//  JSONFileManager.swift
//  HHSSJJ
//
//  Created by Afer on 16/12/5.
//  Copyright © 2016年 Afer. All rights reserved.
//

import Cocoa


class JSONFileManager: NSObject {
    
    func initAJSONFile(path: String?) {
        print(path)
        run(bash: "cd " + path! + "; touch HHSSJJ.json")
        initJSONDataString(path: path)
    }
    
     func initJSONDataString(path: String?) {
        let configStr = "{ \n\n \"proPath\" : \"Your project path!\" \n \"cerName\" : \"Your cer name\" \n\n}"
        do {
            try configStr.write(toFile: path! + "/HHSSJJ.json", atomically: true, encoding: .utf8)
            print("init successful")
        } catch {
            print(error)
        }
        exit(0)
    }
}
