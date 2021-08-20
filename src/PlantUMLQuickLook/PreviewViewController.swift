//
//  PreviewViewController.swift
//  PlantUMLQuickLookPlugIn
//
//  Created by Tachy_Pochy on 2021/08/15.
//

import Cocoa
import Quartz

class PreviewViewController: NSViewController, QLPreviewingController {
    @IBOutlet weak var imageView: NSImageView!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("PreviewViewController")
    }

    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
    }

    /*
     * Implement this method and set QLSupportsSearchableItems to YES in the Info.plist of the extension if you support CoreSpotlight.
     *
    func preparePreviewOfSearchableItem(identifier: String, queryString: String?, completionHandler handler: @escaping (Error?) -> Void) {
        // Perform any setup necessary in order to prepare the view.
        
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        handler(nil)
    }
     */
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        
        // Supported extensions in the Info.plist of the extension.
        //      item 0 .pu
        //      item 1 .puml
        //      item 2 .plantuml
        //      item 3 .wsd
        //      item 4 .iuml
        
        let serverName: String = MyDefault().plantUmlServer()
        
        if serverName == "" {
            handler(nil)
            return
        }
        
        if serverName.hasPrefix("http") {
            viewImageByHttp(by: url)
        } else {
            viewImageByJar(by: url)
        }
        
        handler(nil)
    }
    
    /// コマンドから png を取得して表示する
    /// - Parameter fileUrl: ファイルの URL
    private func viewImageByJar(by fileUrl: URL)
    {
        // 設定値を取得する
        let conf = MyDefault()
        let cat = conf.catCommandPath()
        let java = conf.javaCommandPath()
        let plantUml = conf.plantUmlServer()
        
        // コマンド実行
        let resultData = (
            Process(cmd: cat, args: [fileUrl.path]) |
            Process(cmd: java, args: ["-jar", plantUml, "-pipe"])
        ).resultData()
        
        // データをビューに設定する
        self.imageView.image = NSImage(data: resultData)
    }
    
    /// PlantUML サーバーから png を取得して表示する
    /// - Parameter url: ファイルの URL
    private func viewImageByHttp(by fileUrl: URL)
    {
        // ファイルを読み込む
        let src = readFile(at: fileUrl)
        
        // 圧縮する
        let comp: String = compress(to: src)

        // PlantUMLサーバーにリクエストを送る
        let url = createUrl(from: comp)
        downloadImage(from: url)
    }
        
    /// QuickLook されたファイル内のテキストデータを読みこむ。
    /// - Parameter url: QuickLook されたファイルの URL
    /// - Returns: ファイル内のテキストデータ
    private func readFile(at url: URL) -> String {
        do {
            let text = try String(contentsOfFile: url.path)
            return text
        } catch {
            print("Error: \(error)")
            return ""
        }
    }
    
    /// テキストデータを圧縮する
    /// - Parameter src: 圧縮対象のテキストデータ
    /// - Returns: 圧縮後のテキストデータ
    private func compress(to src: String) -> String {
        let d: Data? = src.data(using: .utf8)?.deflated
        return d!.encode64
    }
    
    /// PlantUML サーバーへの URL を作成する
    /// - Parameter comp: 圧縮後の文字列
    /// - Returns: 作成した URL
    private func createUrl(from comp:String) -> URL {
        let fullUri = MyDefault().plantUmlServer() + comp
        let url: URL = URL(string: fullUri)!
        return url
    }
    
    // 以下のコードは、下記サイトを参考にしました。
    // 参考：https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
    
    /// サーバーにリクエストを送って、応答を Data で返す。
    /// - Parameters:
    ///   - url: リクエスト送信先 URL
    ///   - completion: すみません。わかりません。
    /// - Returns: レスポンス内容
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    /// サーバーにリクエストを送って、応答のあった png データを表示する。
    /// - Parameter url: リクエスト送信先 URL
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self!.imageView.image = NSImage(data: data)
            }
        }
    }
}
