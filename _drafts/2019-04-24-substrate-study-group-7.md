---
layout: post
title:  "Blockchain DevUx Study group 2019/04/23"
author: mtdk1
categories: [ Substrate, StudyGroup ]
tags: [Substrate, BDevUx]
image: assets/images/20190423001.jpg
description: "ブロックチェーン開発勉強会 渋谷で毎月開催"
featured: true
hidden: false
rating: 0
---

[第7回ブロックチェーン勉強会 Substrate でオリジナルブロックチェーンを作る - connpass](https://bdevux.connpass.com/event/128643/)

2019年4月23日に第7回ブロックチェーン勉強会を開催しました。

今回から「Substrate でオリジナルブロックチェーンを作る」をテーマにして勉強会、ワークショップを開催していきます。

ご興味をお持ちいただけましたら、是非ワークショップへおこしください。

---

今回のワークショップでは Substrate を利用して作ったデモを体験していただきました。

- 前提、準備
- Full node 起動
- アカウント作成
- トークン取得とValidator 立候補、Nominator
- Validator node 起動
- トークン追加発行 (準備中)
- Purge Chain (準備中)
- Build Spec (準備中)


## 目的

このデモを体験する目的は、Substrate（サンプル） で何ができるのかを体験する事で理解する。
カスタマイズできる所を知ることで、オリジナルブロックチェーン開発に繋げる。
トークンを送信するだけの体験ではなく、ノード運用（バリデータ）として報酬を得る。
動かして何か気がつくことがある。

実際に GUI で動きを見たあとにソースコードを見て動きを想像することが楽になります。

> Polkadot の体験ではありません。 Substrate テストネット（B DevUx 版）の体験です。
> B DevUx 版には bdevux という SRML が追加されていますが、本記事では紹介しません。今後、機会があれば記事を作成します。

## 前提、準備

デモの体験はローカル環境でノードを起動します。
ローカル環境は Ubuntu18 もしくは Amazon Linux2 を用意してください。
ノードプログラムは Amazon Linux2 でビルドし、Ubuntu でも動作確認をしました。


下記ページから zip ファイルをダウンロードしてローカルに展開してください。

https://github.com/bdevux/study_group/blob/20190423/README.md

```bash
$ wget https://github.com/bdevux/study_group/archive/20190423.zip
$ unzip 20190423.zip
$ cd study_group-20190423
```

substrate と .sh ファイルにファイル所有者(u) 、実行パーミッション(x) を追加します

```bash
$ chmod u+x substrate *.sh
```

外部ノードからの接続を許可する場合は PORT:30333 を開放（インバウンド）してください。
自分のノードから外部に接続することができるようにしてください（アウトバウンド）
多くの場合は自分で設定しない限りアウトバウンドは制限されていません。


## Full node 起動

ここからはダウンロードて展開されたファイルを使用します。
ビルドなどの作業は必要ありません。

このあと、報酬が得られるようにするために validator node の起動をしますが、
validator の条件としてブロックが完全に同期されている必要があります。
この記事を作成した時点でのブロック数は約 5 万で、約5分で同期します。

> boot node は開発用で使用しているため、バージョンアップなどにより
> 本記事の通りに実行しても接続できなる可能性があります。
> 本ブログの新しい記事をご確認いただきますようお願い致します。

full node として起動し、すべてのブロックを同期（ダウンロード）します。

```bash
$ vi start_full.sh

NODE_NAME='SAMPLE'
BASE_PATH=./tmp/bdevux

./substrate \
  --chain=./staging_raw.json \
  --bootnodes=/ip4/52.197.199.13/tcp/30333/p2p/QmaJKELVSebfXRLWPrJpizA5WSfXrheDC8wdGD7azSCeMg \
  --base-path=$BASE_PATH \
  --name=$NODE_NAME \
  --telemetry-url ws://telemetry.polkadot.io:1024
```

NODE_NAME='SAMPLE' の SAMPLE を任意の文字列（アルファベット）に変更してください。
BASE_PATH=./tmp/bdevux はブロックやノードキーが保存する場所を指定します。
特に希望がなければ、このままにしてください。変更した場合は他の .sh ファイルにも同じディレクトリを指定してください。

```bash
$ ./start_full.sh
2019-04-25 09:52:38 Substrate Node
2019-04-25 09:52:38   version 1.0.0-d90e092d-x86_64-linux-gnu
2019-04-25 09:52:38   by Parity Technologies, 2017-2019
2019-04-25 09:52:38 Chain specification: B Devux Chain --Dev
2019-04-25 09:52:38 Node name: SAMPLE
2019-04-25 09:52:38 Roles: FULL
2019-04-25 09:52:38 Generated a new keypair: d793532bf6a630211faa317c9b8c4b6330e4630532f9941a0dfbfb4446cce5be (5GwMv94S...)
2019-04-25 09:52:39 Initializing Genesis block/state (state: 0xa4cb…ffa9, header-hash: 0xd8da…3286)
2019-04-25 09:52:39 Loaded block-time = 10 seconds from genesis on first-launch
2019-04-25 09:52:39 Loading GRANDPA authority set from genesis on what appears to be first startup.
2019-04-25 09:52:39 Best block: #0
2019-04-25 09:52:39 Local node address is: /ip4/0.0.0.0/tcp/30333/p2p/QmRnx3GoMBC6EqpK7t5fc4RYciCEbdkWbJ3uhVut7KwDZK
2019-04-25 09:52:39 PSM => Connect(PeerId("QmaJKELVSebfXRLWPrJpizA5WSfXrheDC8wdGD7azSCeMg")): Received a previous request for that peer
2019-04-25 09:52:39 Listening for new connections on 127.0.0.1:9944.
2019-04-25 09:52:44 Banning PeerId("QmbPgV4iTsWHhrZDTPU5g1YtxJ11PcGC3f9oMTaNLUvJ6m") because "Peer is on different chain (our genesis: 0xd8da…3286 theirs: 0xf9e2…c2ba)"
2019-04-25 09:52:44 Banning a node is a deprecated mechanism that should be removed
2019-04-25 09:52:44 Syncing, target=#52593 (1 peers), best: #640 (0x4451…13c3), finalized #0 (0xd8da…3286), ⬇ 94.2kiB/s ⬆ 1.3kiB/s

```

以下の項目を確認してください

```bash
Chain specification: B Devux Chain --Dev
Node name: SAMPLE
Roles: FULL
Syncing, target=#52593 (1 peers), best: #640 (0x4451…13c3), finalized #0 (0xd8da…3286), ⬇ 94.2kiB/s ⬆ 1.3kiB/s
```

Node name は先に設定した任意の文字列になります。
その後、同期（Syncing）が始まり、boot node が持つブロック数（target=#52593）が表示されます。
best: #640 はダウンロードしたブロック数ですので、これが target と同じ数になるまで待ちます。
待っている間に次の作業に進んでください。


自分のノードが下記ページに表示されていることを確認してください。

[Polkadot Telemetry](https://telemetry.polkadot.io/#/B%20Devux%20Chain%20--Dev)

接続 peer 数やブロックの同期状況を簡単に確認できます。


## アカウント作成

ブラウザを使用します。起動した自分のノードに接続する必要はりません。

[Polkadot/Substrate Portal](https://polkadot.js.org/apps/#/staking/actions)

作成するアカウントは3つ

- Controller
- Stash
- Session

Validator, Nominator になる際に
Stash アカウントが保有するトークンを Stake (出資) します。

Validator はネットワークを維持する役割りがあり、この役割を果たせない場合は Stake したトークンから罰金を支払います。
Nominator は Validator が得た報酬の一部を受け取ることができますが、Validator が不正をした場合は罰金を支払うことになります。

Controller は Validator への立候補、Validator への Nominate を行うためのアカウントでトランザクション費だけが必要になります。Stake するアカウントではないため多くのトークンを持つ必要はありません。

Session は Validator になった際にブロックに署名をするアカウントです。
Validator node を起動する際に、このアカウントを指定します。

[Create account](https://polkadot.js.org/apps/#/accounts/create)


| name your account,  | create from the following mnemonic seed,|  keypair crypto type |
|---------------------|:---------------------------------------:|:--------------------:|
| Controller          | 0x---------------                       |Schnorrkel(sr25519)   |
| Stash               | 0x---------------                       |Schnorrkel(sr25519)   |
| Session             | 0x---------------                       |**Edwards(ed25519)**  |

 

name はブラウザに保存されるものです、あとで区別できる名前にしてください。希望がなければ表あるように役割名のままで作成してください。

パスワードはブラウザに保存されたアカウント情報を使用する（トランザクション送信）とアカウントをリストアする際に使用します。ネットワークに送信されるものではありません。今回は半角スペース1個でも問題ありません。


seed は特に変更する必要はありせん。

Session の seed は必ずメモしておいてください。忘れてしまうと報酬が得られなくなります。

keypaair crypto type は Session は必ず Edwards(ed25519) を選択してください。 sr25519 は使用できません。

## トークン取得とValidator 立候補、Nominator

トークンを取得するには Slack（チャット）でリクエストしてください、、、、、というのは今回はせずに

トークンを持っているアカウントを共有しますので、そのアカウントから自分宛てにトークンを送ってください。
このアカウントは他の人も使いますので、トークンは全額使い切ることなく 1 [DVX] 程度の送信にしてください。
アカウントの残高が少ない場合は Slack (チャット) でリクエストしてください。

### アカウントをリストアする

[Account restore](https://polkadot.js.org/apps/#/accounts/restore)

この画面でダウンロードした下記ファイルを指定してください。

> 5CtAYC2MdQR9iysz8A7EbdxnyidaCxXxx38RDxf5KkR27i98.json

パスワードは半角スペース1個です。

### Web 画面の接続先を自分のノードにする

アカウント作成やリストアは他のネットワークに接続されている状態でも問題ありませんが、トークンの送信はデモ用ネットワークに接続する必要があります。
ローカルで full node が起動していることを確認してください。
ブラウザと node が別 PC, OS で起動している場合は ssh ポートフォワーディンぐの設定をしてください。

[Settings / General](https://polkadot.js.org/apps/#/settings)

remote node/endpoint to connect to: **Local Node(127.0.0.1:9944)** を撰択

「Save & Reload」ボタンを押すと画面がリロードされます。
サイドバー の下のほうに「B Devux Chain --Dev 」と表示されていることを確認してください。

### ssh ポートフォワーディング

Windows で Tera Term を使用している場合は

> Menu > 設定 > SSH 転送

![Tera Term]({{ site.baseurl }}/assets/images/201904251118.png)

```bash
$ ssh -L 9944:127.0.0.1:9944 -i secret ubuntu@ec2.1.2.3.4
```


### トークンを送信する


[Transfer](https://polkadot.js.org/apps/#/transfer)

Controller, Stash 宛てに 1 [DVX] を送信します。 

送信元
5CtAYC2MdQR9iysz8A7EbdxnyidaCxXxx38RDxf5KkR27i98

送信先： Controller
balance: 1 [DVX]

送信先： Stash
balance: 1 [DVX]


**Session には送信しません**

### Bond Funds

[Staking / Account Actions](https://polkadot.js.org/apps/#/staking/actions)

Stash アカウント の Bond Funds ボタンを押します。

Controller アカウントは自分が作成した「Controller」を撰択
Value bonded は 1 [DVX] (トランザクション手数料が引かれた額が Stake 額になります)

Bond ボタンを押してから、しばらくすると（トランザクションがブロックに取り込まれると）
Controller アカウントに Set Session と Nominate が表示されます。

### Set Session Key

Controller アカウントの Set Session ボタンを押します。

Session アカウントを撰択します。

しばらくすると（トランザクションがブロックに取り込まれると）
Controller アカウントに Validate と Nominate が表示されます。


### Validator, Nominator

ここまでの操作で Validator, Nominator の準備は完了です。

Validator はブロックが同期完了していることと、Validator Node が起動していることが必要ですが
Nominator は node が起動している必要はありません。

もし、ノードを起動していない間も報酬を得たい場合は Nominator になりましょう。
ただし、Nominator になる際に選択する Validator が Validator わすさをするとペナルティが課されます。

Validate ボタンを押すと、Validator に立候補することになります。
立候補後は自分が Validator に選抜されるまで待ちましょう。選抜されると報酬が得られるようになります。
ただし、Validator としての責任が果たせない場合は Slash されペナルティが課されます。


## Validator node 起動

最初に起動した full node は同期が完了していますか？

[Explore / node info](https://polkadot.js.org/apps/#/explorer/node)

total peers が 1 以上、syncing = no となっていれば同期が完了しています。
total peers が 0 の場合は他のノードとの接続が切断されています。
ブロックの同期が完了していない場合があるので、ノードを再起動してみてください。


同期が完了したら validator node を起動します。
full node は停止します。(Ctrl + C)


```bash
$ vi ./start_validator.sh
NODE_NAME='SAMPLE'
BASE_PATH=./tmp/bdevux
KEY=//Sample

./substrate \
  --chain=./staging_raw.json \
  --bootnodes=/ip4/52.197.199.13/tcp/30333/p2p/QmaJKELVSebfXRLWPrJpizA5WSfXrheDC8wdGD7azSCeMg \
  --base-path=$BASE_PATH \
  --name=$NODE_NAME \
  --key=$KEY \
  --telemetry-url ws://telemetry.polkadot.io:1024 \
  --validator
```

KEY= Session アカウントの seed

Session アカウントの 0x で始まる seed に置き換えます。

```bash
$ ./start_validator.sh
2019-04-25 11:49:49 Substrate Node
2019-04-25 11:49:49   version 1.0.0-d90e092d-x86_64-linux-gnu
2019-04-25 11:49:49   by Parity Technologies, 2017-2019
2019-04-25 11:49:49 Chain specification: B Devux Chain --Dev
2019-04-25 11:49:49 Node name: SAMPLE
2019-04-25 11:49:49 Roles: AUTHORITY
2019-04-25 11:49:49 Best block: #768
2019-04-25 11:49:49 Local node address is: /ip4/0.0.0.0/tcp/30333/p2p/QmRnx3GoMBC6EqpK7t5fc4RYciCEbdkWbJ3uhVut7KwDZK
2019-04-25 11:49:49 PSM => Connect(PeerId("QmaJKELVSebfXRLWPrJpizA5WSfXrheDC8wdGD7azSCeMg")): Received a previous request for that peer
2019-04-25 11:49:49 Listening for new connections on 127.0.0.1:9944.
2019-04-25 11:49:49 Using authority key 5Crb8yTRvLKnshWH3u92dYCa6YvTQ1ELhi2NyRYkrP1mCdRZ
2019-04-25 11:49:49 Running Grandpa session as Authority 5Crb8yTRvLKnshWH3u92dYCa6YvTQ1ELhi2NyRYkrP1mCdRZ
```

Using authority key **5Crb8yTRvLKnshWH3u92dYCa6YvTQ1ELhi2NyRYkrP1mCdRZ**

Session アカウントのアドレスになっていることを確認してください。

[Staking / Account Actions](https://polkadot.js.org/apps/#/staking/actions)

Validate ボタンを押します

[Staking / Staking Overview](https://polkadot.js.org/apps/#/staking)

next up から validators に移動（選抜）されるのを待ちます。

選抜と報酬の付与は Era が 0 に戻るタイミングです。


## おわりに

報酬を得るのは validator としてブロックを生成する、nominator として validator そ推薦するの2通りです。
validator はネットワークを維持する責任があり、ブロック生成がタイムアウトしてしまうとペナルティが課されます。
nominator も同様にペナルティが課され資産を減らしてしまいます。

session と era があり、era がリセットされるタイミングで選抜、報酬付与が行われます。
era がリセットされるまでネットワークを維持しなけばなりません。

validator になるためには stake するトークンが多い順になります。
所有するトークン量が多ければ多いほど報酬が得られる validator になりやすいものの、
Stake したトークンは validator である間は動かすことができなくなります。

今回のデモでは触れませんでしたが、多数決の仕組みでもトークン量が重要になります。

オリジナルブロックチェーンを Substrate を使って開発していきます。
Slack での情報交換や勉強会での交流などに是非ご参加ください。

勉強会、Slack への招待リンクは下記をご覧ください。

- [Blockchain DevUx Group](https://bdevux.github.io/)
- [第7回ブロックチェーン勉強会 Substrate でオリジナルブロックチェーンを作る - connpass](https://bdevux.connpass.com/event/128643/)

次回勉強会は 2019/5/22 予定です。

