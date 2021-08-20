import Foundation
import Compression

// 以下のコードは、下記サイトを参考にしました。
// http://www.splinter.com.au/2019/07/28/go-and-pure-swift-compression-decompression/

extension Data {
    func compression(isEncode: Bool, algorithm: compression_algorithm) -> Data? {
        return withUnsafeBytes { (urbp: UnsafeRawBufferPointer) in
            let ubp: UnsafeBufferPointer<UInt8> = urbp.bindMemory(to: UInt8.self)
            let up: UnsafePointer<UInt8> = ubp.baseAddress!
            let destCapacity = 1_000_000 // Note: Increase/decrease as you require.
            let destBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity:
                destCapacity)
            defer { destBuffer.deallocate() }
            let destBytes = isEncode ?
                compression_encode_buffer(destBuffer, destCapacity, up, count, nil,
                    algorithm) :
                compression_decode_buffer(destBuffer, destCapacity, up, count, nil,
                    algorithm)
            guard destBytes != 0 else { return nil } // Error, or not enough size.
            return Data(bytes: destBuffer, count: destBytes)
        }
    }
    var deflated: Data? {
        // ZLIB has no headers, so it is effectively DEFLATE.
        return compression(isEncode: true, algorithm: COMPRESSION_ZLIB)
    }
    var inflated: Data? {
        return compression(isEncode: false, algorithm: COMPRESSION_ZLIB)
    }
}
