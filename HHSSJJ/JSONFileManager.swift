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
        let configStr = "{ \n\n" +
        " \"proPath\"  : \"Your project path!\", \n" +
        " \"cerName\"  : \"Your cer name\", \n" +
        " \"uKey\"     : \"Your pgyer uKey\", \n" +
        " \"_api_key\" : \"Your pgyer _api_key \" \n" +
        " \n}"
        do {
            try configStr.write(toFile: path! + "/HHSSJJ.json", atomically: true, encoding: .utf8)
            print("init successful")
        } catch {
            print(error)
        }
        getPgyerModel(path: path)
        exit(0)
    }
    
    func getPgyerModel(path: String?) -> PgyerModel {
        
//        NSData *data=[NSData dataWithContentsOfFile:Json_path];
//        //==JsonObject
//        
//        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
//            options:NSJSONReadingAllowFragments
        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!))
        let modelDic = BaseModel.jsonDataToDic(data: data)
        print(modelDic)
        return PgyerModel(info: modelDic as NSDictionary?)
    }
}

class PgyerModel: BaseModel {
    var proPath:  String?
    var cerName:  String?
    var uKey:     String?
    var _api_key: String?
}

extension BaseModel {
    static func jsonDataToDic(data: Data?) -> NSDictionary {
        if let jsonData = data {
            let dic = try? JSONSerialization.jsonObject(with: jsonData, options: [])
            return dic as! NSDictionary
        } else {
            return NSDictionary()
        }
    }
}

class BaseModel: NSObject {
    
    var selfDic: NSDictionary?
    
    //    lazy var mirror: Mirror = {Mirror(reflecting: self)}()
    
    init(info: NSDictionary?) {
        super.init()
        selfDic = info
        
        if info == nil {
            return
        }
        
        var count: UInt32 = 0
        let properties = class_copyPropertyList(object_getClass(self), &count)
        
        for i in 0...(count-1) {
            let aPro: objc_property_t = properties![Int(i)]!
            let proName:String! = String(describing: property_getName(aPro));
            let va = info![proName]
            let ke = proName
            
            if (va is NSArray || va is NSMutableArray) {
                self.setValue(va, forKeyPath: ke!)
            } else if (va is NSDictionary || va is NSMutableDictionary) {
                //                self.setValue(QdaiBaseModel.init(info: va as? NSDictionary), forKeyPath: ke)
            } else {
                self.setValue(BaseModel.anyObjectToString(any: ((va == nil ? "" : va) as AnyObject?)!), forKeyPath: ke!)
            }
        }
    }
    
    override var description: String {
        //        var count: UInt32 = 0
        //        let properties = class_copyPropertyList(object_getClass(self), &count)
        //        var restr =     "\n---------------------------  \(self.dynamicType) description \n"
        //        for p in properties {
        //            restr = restr + "\(p.label!)    = \(unwrap(p.value))\n"
        //        }
        //        restr = restr.stringByReplacingOccurrencesOfString("Optional(", withString: "")
        //        restr = restr.stringByReplacingOccurrencesOfString(")", withString: "")
        //        restr = restr + "---------------------------  \(self.dynamicType) end "
        return "\(type(of: self))"
    }
    
    class func anyObjectToString(any: AnyObject?) -> String {
        
        if any is NSNumber {
            return NSString(format: "%@", any as! NSNumber) as String
        } else if any is String {
            return any as! String
        } else if any is NSString {
            return any as! String
        } else {
            print("ERROR: Type is error")
            return ""
        }
    }
}












