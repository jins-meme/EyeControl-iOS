# EyeControl-iOS

## 概要

JINS MEMEから取得できるデータを元に、視線移動や首振りによってアプリを操作することを可能にしたアプリです。


## 使い方

### 1.「アプリID」と「アプリSecret」取得し設定する

[JIN MEME DEVELOPPER](https://jins-meme.com/ja/developers/)に登録し、アプリ作成を行い「アプリID」と「アプリSecret」を取得してください。
取得した「アプリID」と「アプリSecret」は
`Const.h`
の中にある下記の2行に設定してください。

~~~
#define MEME_APP_CLIENT_ID  @"*****"
#define MEME_CLIENT_SECRET  @"*****"
~~~


### 2.パネル機能のテキスト読み上げ機能の設定（任意）

#### 2-1.PoolIDの設定

AWSよりテスキスト読み上げ機能用の「PoolID」を取得してください。

取得した「PoolID」は
`Const.h`
の中にある下記に設定してください。

~~~
#define AWS_POOL_ID         @"*****"
~~~

#### 2-2.リージョンの変更

`PanelViewController.m`

の中にあるテスキスト読み上げ機能のリージョンを変更します。

`- (void)speach:(NSString *)text{}`

上記メソッドの中にある

~~~~
AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionAPNortheast1 ← ここ
                                                                                                    identityPoolId:AWS_POOL_ID];
~~~~

~~~~
AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPNortheast1 ← ここ
                                                                         credentialsProvider:credentialsProvider];
~~~~

上記2箇所のリージョンを「PoolID」を取得した時に設定したリージョンに変更します。


## ライセンス

MIT License
