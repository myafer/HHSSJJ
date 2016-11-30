//
//  main.swift
//  HHSSJJ
//
//  Copyright © 2016年 Afer. All rights reserved.
//

import Foundation

let arr = CommandLine.arguments
if arr.count == 2 {
    let str = arr[1]
    if str == "-h" {
        print("输入顺序为 ukey _api_key path")
        
    } else if str == "-v" {
        print("v0.0.1")
    }
    
    exit(0)
}

if CommandLine.arguments.count != 4 {
    print("输入有误！")
    print("输入顺序为 ukey _api_key path")
    exit(0)
}

var path = ""
if CommandLine.arguments.count > 1 {
    path = CommandLine.arguments[3]
}



let manager = AFHTTPSessionManager()
manager.responseSerializer.acceptableContentTypes = NSSet.init(array: ["text/html","text/json","application/json","text/javascript"]) as? Set<String>
manager.requestSerializer = AFJSONRequestSerializer()
manager.post("http://www.pgyer.com/apiv1/app/upload", parameters: ["uKey":CommandLine.arguments[1], "_api_key":CommandLine.arguments[2]], constructingBodyWith: { (formData) in
        let dd:AFMultipartFormData = (formData as AFMultipartFormData)
        var data: NSData? = NSData.init(contentsOfFile: path)
        dd.appendPart(withFileData: data as! Data, name: "file", fileName: "123.ipa", mimeType: "")
    }, progress: { (pro) in
         print((pro as Progress).fractionCompleted)
        
    }, success: { (task, obj) in
        print(obj)
        print("成功")
        exit(0)
    }) { (task, error) in
        print("失败", error)
         exit(0)
    }

RunLoop.current.run()


