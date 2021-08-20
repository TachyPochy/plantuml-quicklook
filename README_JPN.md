# PlantUMLQuickLook

　PlantUML を QuickLook で表示するアプリケーションプラグインです。

　PlantUML は、編集中こそ Visual Studio Code などを使用して同時プレビューしながら作業が簡単です。しかし編集後は、ちょっと確認するためにエディタを起動するなど面倒です。QuickLook を使えるようにしたいです。

## Environment

　開発に使用した環境は以下の通りです。

- macOS Catalina 10.15.7
- XCode 12.4(12D4e)
- Swift 5.3.2

　これ以上の環境なら、おそらく動作するでしょう。

## 対応する拡張子

以下のファイル拡張子を PlantUML ファイルとして扱います。

- pu
- puml
- plantuml
- wsd
- iuml

## 設定

　`src/PlantUMLQuickLook/Info.plist` にて、下記の設定を変更できます。

### PlantUmlServer

　現在の設定は以下です。

```
http://www.plantuml.com/plantuml/png/
```

　ご自身で PlantUML サーバーを建てていたら、変更できます。その際は `/png/` まで指定してください。`/png/` しか対応していません。`/svg/` としてもうまくいきません。

　またローカルコマンドを使用したい場合、ここに `plantuml.jar` へのフルパスを設定することもできます。例えば以下のように。

```
/Applications/plantuml.jar
```

### javaCommandPath

　上記 `PlantUmlServer` 設定で、ローカルの `.jar` ファイルを選択した場合に使用します。

### catCommandPath

　上記 `PlantUmlServer` 設定で、ローカルの `.jar` ファイルを選択した場合に使用します。

## インストール？方法

　Xcode でビルドすると、上記拡張子が PlantUML として QuickLook できます。

## TODO

- APPEX だけ配布するにはどうすればいいのでしょう？
- 設定を `defaults write` コマンドで書き換えられるようにするには？
- キャッシュを、QuickLook 標準の場所にしたい。`qlmanage -r cache` で削除されて欲しい。

## 参考 <!--Reference-->

- [Xcode 12でmacOS用のQuick Look機能拡張を作成する](https://zenn.dev/paraches/articles/xcode12-quicklook-appex)
- [Golang and pure Swift Compression and Decompression | Splinter Software](http://www.splinter.com.au/2019/07/28/go-and-pure-swift-compression-decompression/)
- [mdlsコマンドで アプリケーションのCFBundleIdentifier ( bundle Identifier )の文字列を探す - それマグで！](https://takuya-1st.hatenablog.jp/entry/2018/09/01/191512)
