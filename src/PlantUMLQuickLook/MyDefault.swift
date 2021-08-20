//
//  MyDefault.swift
//  PlantUMLQuickLook
//
//  Created by Tachy_Pochy on 2021/08/18.
//

import Foundation

class MyDefault {
    
    /// Info.plist から PlantUML サーバーの URI を取得して返す。
    /// 取得に失敗したら、デフォルトで "http://www.plantuml.com/plantuml/png/" を返す。
    /// - Returns: URI 文字列。
    func plantUmlServer() -> (String) {
        let sv = getValue(key: "PlantUmlServer")
        
        if sv == nil {
            // return default uri
            return "http://www.plantuml.com/plantuml/png/";
        }
        
        return sv!
    }
    
    func catCommandPath() -> String {
        return getValue(key: "catCommandPath")!
    }
    
    func javaCommandPath() -> String {
        return getValue(key: "javaCommandPath")!
    }
    
    private func getValue(key k: String) -> String? {
        let dic = Bundle.main.infoDictionary! as Dictionary?
        
        if dic == nil {
            return nil
        }
        
        let v = dic![k] as! String?
        
        if v == nil {
            return nil
        }
        
        return v!
    }
}
