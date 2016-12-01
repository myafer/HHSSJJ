//
//  main.swift
//  HHSSJJ
//
//  Copyright © 2016年 Afer. All rights reserved.
//

import Foundation
import SwiftShell


let args = CommandLine.arguments
//if args.count == 2 {
//    let str = args[1]
//    if str == "-h" {
//        print("输入顺序为 ukey _api_key path")
//        
//    } else if str == "-v" {
//        print("v0.0.1")
//    }
//    
//    exit(0)
//}

try runAndPrint(bash: "open /usr")

let user: UserDefaults = UserDefaults.standard


if CommandLine.arguments.count < 4 && (user.object(forKey: "uKey") == nil) {
    print("uKey _api_key 为空，上传一次之后会自动记录uKey _api_key。")
    print("输入顺序为 ukey _api_key path。")
    exit(0)
}

var path = ""
if CommandLine.arguments.count > 1 {
    if user.object(forKey: "uKey") == nil {
        path = CommandLine.arguments[3]
    } else {
        path = CommandLine.arguments[1]
    }
    
}

var uKey = ""
var api_key = ""
if user.object(forKey: "uKey") == nil {
    uKey = args[1]
    api_key = args[2]
} else {
    uKey = user.object(forKey: "uKey") as! String
    api_key = user.object(forKey: "_api_key") as! String
}

let manager = AFHTTPSessionManager()
manager.responseSerializer.acceptableContentTypes = NSSet.init(array: ["text/html","text/json","application/json","text/javascript"]) as? Set<String>
manager.requestSerializer = AFJSONRequestSerializer()
manager.post("http://www.pgyer.com/apiv1/app/upload", parameters: ["uKey": uKey, "_api_key":api_key], constructingBodyWith: { (formData) in
        let dd:AFMultipartFormData = (formData as AFMultipartFormData)
        var data: NSData? = NSData.init(contentsOfFile: path)
        dd.appendPart(withFileData: data as! Data, name: "file", fileName: "123.ipa", mimeType: "")
    }, progress: { (pro) in
         print((pro as Progress).fractionCompleted)
        
    }, success: { (task, obj) in
        print(obj)
        print("成功")
        user.set(uKey, forKey: "uKey")
        user.set(api_key, forKey: "_api_key")
        user.synchronize()
        exit(0)
    }) { (task, error) in
        print("失败", error)
         exit(0)
    }

RunLoop.current.run()


