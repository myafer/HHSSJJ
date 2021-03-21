//
//  JSONFileManager.swift
//  HHSSJJ
//
//  Created by Afer on 16/12/5.
//  Copyright © 2016年 Afer. All rights reserved.
//
import Cocoa


class JSONFileManager: NSObject {
    
    static func initAJSONFile(path: String?) {
        print(path ?? "")
        run(bash: "cd " + path! + "; touch HHSSJJ.json")
        initJSONDataString(path: path!)
    }
    
    static func initJSONDataString(path: String?) {
        let configStr = "{ \n\n" +
            " \"proPath\"  : \"Your project path!\", \n" +
            " \"scheme\"   : \"Your project scheme \", \n" +
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
        exit(0)
    }
    
    static func getPgyerModel(path: String?) -> PgyerModel {
        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!))
        let modelDic = BaseModel.jsonDataToDic(data: data)
        return PgyerModel(info: modelDic as NSDictionary?)
    }
}

class PgyerModel: BaseModel {
    var proPath:  String?
    var scheme:   String?
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
    
    lazy var mirror: Mirror = {Mirror(reflecting: self)}()
    
    init(info: NSDictionary?) {
        super.init()
        for p in mirror.children {
            
            let va = info![p.label!]
            let ke = p.label!
            
            if (va is NSArray || va is NSMutableArray) {
                self.setValue(va, forKeyPath: ke)
            } else {
                self.setValue(BaseModel.anyObjectToString(any: (va as AnyObject?)!), forKeyPath: ke)
            }
            
        }
    }
    
    func toDictionary() -> NSMutableDictionary {
        let mdic: NSMutableDictionary = NSMutableDictionary()
        for p in mirror.children {
            mdic.setValue( self.value(forKeyPath: p.label!) , forKeyPath:  p.label!)
        }
        
        return mdic
    }
    
    override var description: String {
        var restr =     "##############  \(type(of: self)) description ###############\n"
        for p in mirror.children {
            restr = restr + "\(p.label!)    = \(p.value)\n"    + "----------------------\n"
        }
        restr = restr + "######################## description end #######################\n"
        return restr
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
    }}
