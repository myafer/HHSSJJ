//
//  main.swift
//  HHSSJJ
//
//  Copyright © 2016年 Afer. All rights reserved.
//
import Foundation


let args = CommandLine.arguments


//print(main.arguments)


func help() {
    print("")
    print("|---- Usage: ----------------------------|")
    print("|                                        |")
    print("| 1. Use -init to creat json file.       |")
    print("| 2. Modify json file to you config.     |")
    print("|                                        |")
    print("|---- Commands: -------------------------|")
    print("|                                        |")
    print("| -init  init json file.                 |")
    print("| -bu    build and upload to pgyer.      |")
    print("| -b     build.                          |")
    print("| -up    upload to pgyer.                |")
    print("| -h     print help.                     |")
    print("|________________________________________|")
    print("")
    exit(0)
}


if args.count < 2 {
    print("Input error!")
    help()
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



func buildAndUpload(projectPath: String, isUpload: Bool) {
    
    let pgyerModel = JSONFileManager.getPgyerModel(path: projectPath + "/HHSSJJ.json")
    let archivepath = projectPath + "/123.xcarchive"
    let ipapath = projectPath + "/123.ipa"
    run(bash: "cd " + projectPath + "; rm 123.ipa;")
    run(bash: "cd " + projectPath + "; rm 123.xcarchive;")
    do {
        try runAndPrint(bash: "cd " + projectPath + ";xcodebuild clean")
        try runAndPrint(bash: "cd " + projectPath + ";xcodebuild archive -scheme \"\(pgyerModel.scheme!)\" -configuration \"Release\" -archivePath " + archivepath)
        try runAndPrint(bash: "cd " + projectPath + ";xcodebuild -exportArchive -archivePath " + archivepath + " -exportPath " + ipapath + " -exportFormat IPA -exportProvisioningProfile " + " \"" + pgyerModel.cerName! + "\"")
        print("Package successful ---- " + ipapath)
        let data: NSData? = NSData.init(contentsOfFile: ipapath)
        if isUpload {
            upload(ukey: pgyerModel.uKey!, api_key: pgyerModel._api_key!, data: data)
        } else {
            exit(0)
        }
    } catch {
        print("Failure: ", error)
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
    buildAndUpload(projectPath: args[2], isUpload: true)
case "-b":
    buildAndUpload(projectPath: args[2], isUpload: false)
case "-up":
    print("---- uploading ---")
    upload(projectPath: args[2])
case "-h":
    help()
default:
    help()
}


RunLoop.current.run()
