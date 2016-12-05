//
//  main.swift
//  HHSSJJ
//
//  Copyright © 2016年 Afer. All rights reserved.
//

import Foundation


let args = CommandLine.arguments


print(args)
let projectPath = "/Users/koudaiwang/Desktop/TTTT"


if args.count < 2 {
    print("Input error!")
    exit(0)
}

let one = args[1]

if one == "init" {
    JSONFileManager().initAJSONFile(path: projectPath)
}






let appfile = projectPath + "/build/Release-iphoneos"
let archivepath = projectPath + "/123.xcarchive"
let ipapath = projectPath + "/123.ipa"
let cerName = "com.*"
run(bash: "cd " + projectPath + "; rm 123.ipa;")
run(bash: "cd " + projectPath + "; rm 123.xcarchive;")
try runAndPrint(bash: "cd " + projectPath + ";xcodebuild clean")

try runAndPrint(bash: "cd " + projectPath + ";xcodebuild archive -scheme \"TTTT\" -configuration \"Release\" -archivePath " + archivepath)
try runAndPrint(bash: "cd " + projectPath + ";xcodebuild -exportArchive -archivePath " + archivepath + " -exportPath " + ipapath + " -exportFormat IPA -exportProvisioningProfile" + "\"" + cerName + "\"")
print("打包成功----" + ipapath)

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


var count = 3
let data: NSData? = NSData.init(contentsOfFile: ipapath)
func upload() {
    let manager = AFHTTPSessionManager()
    manager.responseSerializer.acceptableContentTypes = NSSet.init(array: ["text/html","text/json","application/json","text/javascript"]) as? Set<String>
    manager.requestSerializer = AFJSONRequestSerializer()
    manager.post("http://www.pgyer.com/apiv1/app/upload", parameters: ["uKey": uKey, "_api_key":api_key], constructingBodyWith: { (formData) in
        let dd:AFMultipartFormData = (formData as AFMultipartFormData)
        if data != nil {
            dd.appendPart(withFileData: data as! Data, name: "file", fileName: "123.ipa", mimeType: "")
        } else {
            print("没有有效的ipa文件")
            exit(0)
        }
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
        if count > 0 {
            print("失败", error)
            print("-------------正在重新上传-------------")
            upload()
            count = count - 1
        } else {
            exit(0)
        }
    }
}

upload()


RunLoop.current.run()


