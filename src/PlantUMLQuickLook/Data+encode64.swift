//
//  Data+encode64.swift
//  PlantUMLQuickLook
//
//  Created by Tachy_Pochy on 2021/08/18.
//

import Foundation

extension Data {
    var encode64: String {
        var str: String = ""
        let array = [UInt8](self)
        for i in stride(from: 0, to: array.count, by: 3) {
            if (i + 2) == array.count {
                str.append(append3bytes(array[i], array[i+1], 0))
            } else if (i + 1) == array.count {
                str.append(append3bytes(array[i], 0, 0))
            } else {
                str.append(append3bytes(array[i], array[i+1], array[i+2]))
            }
        }
        return str
    }
    
    private func chr(_ i: UInt8) -> (String)
    {
        var r: String = ""
        r.append(Character(UnicodeScalar(i)))
        return r
    }
    
    private func encode6bit(_ src: UInt8) -> (String)
    {
        var b = src
        if b < 10 {
            return chr(48 + b)
        }
        
        b -= 10
        if b < 26 {
            return chr(65 + b)
        }
        
        b -= 26
        if b < 26 {
            return chr(97 + b)
        }
        
        b -= 26
        if b == 0 {
            return "-"
        }
        
        if b == 1 {
            return "_"
        }
        
        return "?"
    }
    
    private func append3bytes(_ b1: UInt8, _ b2: UInt8, _ b3: UInt8) -> (String)
    {
        let c1 = b1 >> 2;
        let c2 = ((b1 & 0x3) << 4) | (b2 >> 4)
        let c3 = ((b2 & 0xF) << 2) | (b3 >> 6)
        let c4 = b3 & 0x3F;
        var r: String = ""
        r.append(encode6bit(c1 & 0x3F))
        r.append(encode6bit(c2 & 0x3F))
        r.append(encode6bit(c3 & 0x3F))
        r.append(encode6bit(c4 & 0x3F))
        return r
    }
}
