# EyeControl-iOS

## 概要

JINS MEMEから取得できるデータを元に、視線移動や首振りによって以下の機能をハンズフリーで操作するデモアプリです。
アプリは[JINS MEME Eye Control](https://itunes.apple.com/jp/app/jins-meme-eye-control/id1407318434?mt=8)からダウンロードできます。

ハンズフリー操作のライブラリのみを使用したい場合は以下のレポジトリをご利用ください。
- [視線操作(JinsMemeLib-EyeControl-iOS)](https://github.com/jins-meme/JinsMemeLib-EyeControl-iOS)
- [首振り操作(JinsMemeLib-HeadControl-iOS)](https://github.com/jins-meme/JinsMemeLib-HeadControl-iOS)

## 使い方

### 1.「アプリID」と「アプリSecret」取得し設定する

[JINSMEME DEVELOPER SUPPORT](https://jins-meme.com/ja/developers/)で登録・アプリ作成を行い「アプリID」と「アプリSecret」を取得してください。
取得した「アプリID」と「アプリSecret」は
`Const.h`
の中にある下記の2行に設定してください。

~~~
#define MEME_APP_CLIENT_ID  @"*****"
#define MEME_CLIENT_SECRET  @"*****"
~~~


### 2.パネル機能のテキスト読み上げ機能の設定（任意）

#### 2-1.AWS_POOL_ID の設定

テキスト読み上げ機能はAmazon Pollyを使用しています。利用のための「AWS_POOL_ID」を取得してください。

取得した「AWS_POOL_ID」は
`Const.h`
の中にある下記に設定してください。

~~~
#define AWS_POOL_ID         @"*****"
~~~

#### 2-2.リージョンの変更

`PanelViewController.m`

の中にあるテキスト読み上げ機能のリージョンを変更します。

`- (void)speach:(NSString *)text{}`

上記メソッドの中にある下記2箇所のリージョンを「AWS_POOL_ID」を取得した時に設定したリージョンに変更します。

~~~~
AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionAPNortheast1 ← ここ
                                                                                                    identityPoolId:AWS_POOL_ID];
~~~~

~~~~
AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPNortheast1 ← ここ
                                                                         credentialsProvider:credentialsProvider];
~~~~

## ライセンス

MIT License
