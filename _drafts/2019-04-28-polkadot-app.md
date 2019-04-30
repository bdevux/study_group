---
layout: post
title:  "Polkadot/Substrate Portal"
author: mtdk1
image: assets/images/substrate_portal.png
categories: [ Things of interest ]
tags: [Things of interest, Substrate, Polkadot]
description: "Things of interest"
featured: false
hidden: false
---

[Polkadot/Substrate Portal](https://polkadot.js.org/apps/#/explorer)

Polkadot/Substrate ノード開発をしているときに利用させていただいています。
公式が提供しているテストネットへのアクセスだけではなく、ローカルで起動しているノードへ接続してオリジナルのネットワークへのアクセスができ、簡単な動作確認ができます。

ソースコードが提供されているので、カスタマイズすることでオリジナルブロックチェーン用の GUI を作ることができるのではないでしょうか

Github: [polkadot-js/apps: Basic Polkadot/Substrate UI for interacting with a node. This is the main user-facing application, allowing access to all features available on Substrate chains.](https://github.com/polkadot-js/apps)

私自身はまだ UI 開発を始めていないので詳しく中を見てはいませんが
RxJS という単語が出てきているので Angular を利用しているのかと思いましたが
package.json を覗いてみると react が利用されているようです。
また、src にあるファイルの拡張子が tsx なので、TypeScript で書かれているようです。

React, TypeScript はよく使っているのでキャッチアップは早くできそうです。

まだ UI に着手することはできそうもありませんが、オリジナルブロックチェーンのアイデアが固まって開発が進めば UI も作り始めることができそうです。

