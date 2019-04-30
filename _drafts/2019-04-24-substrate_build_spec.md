---
layout: post
title:  "Substrate build-spec"
author: mtdk1
categories: [ Substrate ]
tags: [Substrate, BDevUx]
image: assets/images/20190425001.jpg
description: "json ファイルを修正するだけでオリジナルブロックチェーンを作る。"
featured: false
hidden: false
rating: 0
---

json ファイルを修正するだけでオリジナルブロックチェーンを作る。

オリジナルブロックチェーンというか、、、、プライベート、コンソーシアム型のチェーンを作るということですね。

---

substrate 起動時にブロックチェーンの仕様を指定します。

```bash
$ substrate --chain=local
```

指定できるのは local, dev, staging, elm などソースコード内であらかじめ定義してあるものと
chain_spec.json のように json ファイルを指定することができます。

オリジナルブロックチェーンでは、この json ファイルを配布します。

ゼロから作るのは大変なので、ベースとなる json ファイルを修正してオリジナルのものにします。

chain_spec.json はブロックチェーン起動時の初期値になります。

## ベースにする chain_spec.json を作る

```bash
$ substrate build-spec --chain=staging > staging-spec.json
```

貼り付けようと思いましたが、行数がおおいのでやめておきます。。。。

ここで出力された json ファイルは人が読むことができるもので、配布するものではありません。
配布する時は --raw フラグを追加して出力します。

```bash
$ substrate build-spec --chain=staging-spec.json --raw > my-spec.json
```

my-spec.json を配布します。

## json を修正してオリジナルの chain_spec.json を作る

```json
  "name": "Staging Testnet",
  "id": "staging_testnet",
  "bootNodes": [
    "/ip4/127.0.0.1/tcp/30333/p2p/QmTu9MsQfTPErzQUnKpojjyjp7saJq4NZoi5XAACA19TyC"
  ],
```

name はブロックチェーン名で画面に表示するなど人が判別するためのものです。
id はブロックデータやキーなどを保存するディレクトリ名に使用されたりします。
bootNodes は配列です。起動時に最初に接続しに行くノードを指定します。

```json
  "properties": {
    "tokenDecimals": 15,
    "tokenSymbol": "DVX"
  },
```

substrate/core/service/src/lib.rs

```rust
		// RPC
		let system_info = rpc::apis::system::SystemInfo {
			chain_name: config.chain_spec.name().into(),
			impl_name: config.impl_name.into(),
			impl_version: config.impl_version.into(),
			properties: config.chain_spec.properties(),
		};
		let rpc = Components::RuntimeServices::start_rpc(
			client.clone(), network.clone(), has_bootnodes, system_info, config.rpc_http,
			config.rpc_ws, task_executor.clone(), transaction_pool.clone(),
		)?;

```
rpc の初期化で使用されています。


```json
      "timestamp": {
        "minimumPeriod": 5
      },
```

ブロック生成の間隔として使用されています。
5 を指定すると 2 倍の 10 秒がブロック生成間隔です。

properties は staging-spec.json には無いので追加しました。
小数点以下の桁数とトークンの単位名を指定しました。
これらも画面表示で使用されたりします。

```json
      "consensus": {
        "authorities": [
          "5EPwBRhmXYfAdmdJL9VUrKvEd6rQAVqAk6JVGo558HfBbc98"
        ],
        "code": 
```

authorities は配列です。初期の authority 権限（ブロック生成者）を指定しました。
これは、ブロックチェーン起動後に Staking, validator で変更されます。
code は runtime そのものです。wasm です。build.sh とかで作成されたものです。


```json
      "balances": {
        "existentialDeposit": 100000000000000,
        "transferFee": 1000000000000,
        "creationFee": 1000000000000,
        "transactionBaseFee": 1000000000000,
        "transactionByteFee": 10000000000,
        "balances": [
          [
            "5F9dfgvv3By5mqYMeB8cbbnRqvLEjoYHs5rqhHJhHdhQDbPZ",
            1000000000000000000000
          ],
```
手数料や、アカウントの初期所有資産を指定します。
プライベートで手数料なしにしたい場合は、ここで Fee を 0 にすればトランザクション関連で手数料が必要なくなります。

```json
      "session": {
        "validators": [
          "5FJ9Cu6hJyV2Wuo7dE7WcM8egHXX1QbUxZzukYhh7jBc9rUx"
        ],
        "sessionLength": 10,
        "keys": [
          [
            "5FJ9Cu6hJyV2Wuo7dE7WcM8egHXX1QbUxZzukYhh7jBc9rUx",
            "5EPwBRhmXYfAdmdJL9VUrKvEd6rQAVqAk6JVGo558HfBbc98"
          ]
        ]
      },
```
consensus のところで指定したのは session アカウントです。
session.validators では controller アカウントを指定します。
keys には [controller, session] の配列を指定します。順番を間違えるとブロック生成が行われなくなります。

```json
      "staking": {
        "minimumValidatorCount": 1,
        "sessionsPerEra": 3,
        "offlineSlash": 0,
        "offlineSlashGrace": 0,
        "bondingDuration": 30,
        "validatorCount": 7,
        "sessionReward": 2065,
        "invulnerables": [
          "5FJ9Cu6hJyV2Wuo7dE7WcM8egHXX1QbUxZzukYhh7jBc9rUx"
        ],
        "currentEra": 0,
        "currentSessionReward": 0,
        "stakers": [
          [
            "5CigR6Z2G8jfdYs7BjTZPRGXNLBt2muA55S2q4X3zz1cWCGA",
            "5FJ9Cu6hJyV2Wuo7dE7WcM8egHXX1QbUxZzukYhh7jBc9rUx",
            1000000000000000000000,
            "Validator"
          ]
        ]
      },
```
sessionPerEra は sessionLength(初期値：10) * 3 = 30 session で １ Era になります。
画面上では 1/10 session,  1/3 Era という表示になっていますが
1/10 の 10 が sessionLength, 1/3 の 3 が sessionPerEra の値
30 session は 5 * 2 * 30 = 300 秒です。

sessionReward は 1 Era ごとに 得られる報酬額です。

validatorCount は validator になれる人数です。適切な数字はいくつなのでしょう、、、、、

stakers では
[Stash, Controller, Stake額, 'Vlidator'] の配列
初期値として指定していないと、起動後に Validator が存在せず、、、、ブロック生成が行われなく（なりそうです）
ここらへんの初期化コードは読んだのですが、、、忘れてしまいました。

```json
      "sudo": {
        "key": "5F9dfgvv3By5mqYMeB8cbbnRqvLEjoYHs5rqhHJhHdhQDbPZ"
      }
```

このアカウントはノード起動後に他のアカウントに置き換えましょう。

## まとめ

修正するのは
- ブロックチェーン名、ID
- トークンの小数点以下桁数、単位名
- bootnodes
- Controller、Stash、Session、Sudo の初期アカウント

アカウントを修正する時は、あらかじめ各アカウントを作成してから
まとめて置換すると間違えずに修正できます。

プログラミング一切なしでオリジナルブロックチェーンが完成しました！！



