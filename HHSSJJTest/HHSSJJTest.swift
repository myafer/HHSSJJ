//
//  HHSSJJTest.swift
//  HHSSJJTest
//
//  Created by 口贷网 on 16/12/6.
//  Copyright © 2016年 Afer. All rights reserved.
//

import XCTest
@testable import HHSSJJ

class HHSSJJTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        upload(projectPath: "/Users/koudaiwang/Desktop/TTTT")


//        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath:  "/Users/koudaiwang/Desktop/TTTT/HHSSJJ.json"))
        
//        let modelDic = BaseModel.jsonDataToDic(data: data)
//        print(data)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
