//
//  main.swift
//  HHSSJJ
//
//  Copyright © 2016年 Afer. All rights reserved.
//

import Foundation


let args = CommandLine.arguments


print(args)
//let projectPath = "/Users/koudaiwang/Desktop/TTTT"


if args.count < 2 {
    print("Input error!")
    exit(0)
}

let one = args[1]

func exitAndWaring(message: String) {
    print(message)
    exit(0)
}

func upload(ukey: String, api_key: String, data: NSData?) {
    let manager = AFHTTPSessionManager()
    manager.responseSerializer.acceptableContentTypes = NSSet.init(array: ["text/html","text/json","application/json","text/javascript"]) as? Set<String>
    manager.requestSerializer = AFJSONRequestSerializer()
    manager.post("http://www.pgyer.com/apiv1/app/upload", parameters: ["uKey": ukey, "_api_key":api_key], constructingBodyWith: { (formData) in
        let dd:AFMultipartFormData = (formData as AFMultipartFormData)
        if data != nil {
            dd.appendPart(withFileData: data as! Data, name: "file", fileName: "123.ipa", mimeType: "")
        } else {
            print("Can not find ipa!")
            exit(0)
        }
        }, progress: { (pro) in
            print((pro as Progress).fractionCompleted)
            
        }, success: { (task, obj) in
            print(obj)
            print("Successful upload to pgyer!")
            
            exit(0)
    }) { (task, error) in
        print("Failure ", error)
        exit(0)
    }
}



func buildAndUpload(projectPath: String) {
    
    let pgyerModel = JSONFileManager.getPgyerModel(path: projectPath + "/HHSSJJ.json")
    let archivepath = projectPath + "/123.xcarchive"
    let ipapath = projectPath + "/123.ipa"
    let cerName = "com.*"
    run(bash: "cd " + projectPath + "; rm 123.ipa;")
    run(bash: "cd " + projectPath + "; rm 123.xcarchive;")
    do {
        try runAndPrint(bash: "cd " + projectPath + ";xcodebuild clean")
        try runAndPrint(bash: "cd " + projectPath + ";xcodebuild archive -scheme \"\(pgyerModel.scheme!)\" -configuration \"Release\" -archivePath " + archivepath)
        try runAndPrint(bash: "cd " + projectPath + ";xcodebuild -exportArchive -archivePath " + archivepath + " -exportPath " + ipapath + " -exportFormat IPA -exportProvisioningProfile" + " \"" + cerName + "\"")
        print("Package successful ---- " + ipapath)
        let data: NSData? = NSData.init(contentsOfFile: ipapath)
        upload(ukey: pgyerModel.uKey!, api_key: pgyerModel._api_key!, data: data)
    } catch {
        print("Clean failure!")
        exit(0)
    }
}


func upload(projectPath: String) {
    let pgyerModel = JSONFileManager.getPgyerModel(path: projectPath + "/HHSSJJ.json")
    let ipapath = projectPath + "/123.ipa"
    let data: NSData? = NSData.init(contentsOfFile: ipapath)
    upload(ukey: pgyerModel.uKey!, api_key: pgyerModel._api_key!, data: data)
}

switch one {
    case "-init":
        JSONFileManager.initAJSONFile(path: args[2])
    case "-bu":
        buildAndUpload(projectPath: args[2])
    case "-up":
        print("---- uploading ---")
        upload(projectPath: args[2])
    
    default:
        exitAndWaring(message: "输入有误")
}


RunLoop.current.run()


