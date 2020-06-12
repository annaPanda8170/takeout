# 概要
ログイン不要!スマホで簡単テイクアウト注文。『ぱんだTakeOut!』。<br>
注文はもちろん、出店販売もスマホのみで簡単に出来ます。
<br>
<br>

# 言語・環境
- Ruby On Rails 6.0.3.1
- ruby 2.7.0
- JQuery
- MySQL
- docker-compose
- EC2
- Route53
- Cerftificate Manager
<br>
<br>

# URL
https://takeout.annapanda.xyz/
<br>※データベースは定期的にリセットしているので、自由に登録等して下さって構いません。
<br>
<br>

# テストカード情報
- カード：4242 4242 4242 4242
- 有効期限：今より未来ならなんでも
- CVC番号：3桁の数字なんでも
- 名前：なんでも
<br>
<br>

# 出店側ログイン情報
- Email: a@a
- password: 123123123
<br>
<br>

# 使用法一巡
## ①注文側
### 【店を選ぶ】
<br>
<br>
<div><img src="https://gyazo.com/5d2900c0239015e45763310420c8df78/raw" height="200px" align="left" magin-right="100px">店をジャンルからもしくは現在地から近い場所から探すことが出来ます。ジャンルから探す場合は、トップイメージの下にあるそれぞれのカテゴリー一覧へのリンクから入ります。<br>トップイメージはPC版ではスライドイメージになっていて、スマホ版では固定イメージになっています。<img src="https://gyazo.com/284b2181ee04c1206c09c62de58ef121/raw" height="200px" align="right"><br clear="all"></div>
<br>
<br>
<div><img src="https://gyazo.com/8c2bc43568a876c8ac0d846f36eb9c3e/raw" height="200px" align="left" magin-right="100px">現在地から近い場所から探す場合は、『ジャンルから探す』の下に、範囲を指定して現在地を取得して一覧を表示するボタンがあります。<br>seedに入っているレストランの数が少ないので今回は1km以上での検索にしました。ちなみにseedに入っているレストランの場所は都心からランダムで配置されます。たまに東京湾の中などになってしまうかもしれません(笑)<br><img src="https://gyazo.com/6b7ea50c5bfa904f4a2d3abd84dbb8db/raw" height="200px" align="right"><br clear="all"></div>
<br>

### 【料理を選ぶ】

<div><img src="https://gyazo.com/c9b3668d6bccfd7139ebdae8e15f4523/raw" height="200px" align="left" magin-right="100px">料理ごとに数量ボタンがあるので増やしたり減らしたりします。<br>数量を変更するごとに合計の値が変わります。<br>そのまま会計に移ることも、買い物かごに入れてトップ画面に戻ることも出来ます。<br>映像は後者です。<br>パソコン版の場合、トップ画面に戻ると右上の赤い部分に変更が反映されています。<img src="https://gyazo.com/5b36aef91c99b108706e59979ccf2d31/raw" height="200px" align="right"><br clear="all"></div>

### 【買い物かご情報】
<br>

<br>
<div><img src="https://gyazo.com/4931835840822d36ef541a7f6d250ee4/raw" height="200px" align="left" magin-right="100px"><img src="https://gyazo.com/48b934aae566482b463765d3823ae26c/raw" height="200px" align="left" magin-right="100px">右上の赤のホバーメニュー（PC版）やスライドメニュー（スマホ版）、そして一覧から見れます。<br>ここで削除なども出来ます。<br>一覧はPC版のみです。<img src="https://gyazo.com/8ab820f027da516980f1aa059158e330/raw" height="200px" align="right"><br clear="all"></div>

### 【会計】
<br>
<br>
<div><img src="https://gyazo.com/3e9110909af4264de70f0abb22b8444f/raw" height="200px" align="left" magin-right="100px">未会計一覧かホバースライドメニューか料理を選んだ時そのまま会計ボタンを押せば会計に移ります。<br>ここで数量の変更、料理の削除等を出来ます。<br>料理ごとに調理時間が登録されていてます。注文された物の中で一番時間のかかる料理の調理時間と現在の時間を足しそれを15分単位に直して最早時間を定め、それより前の時間を指定出来ないようになっています。<br>現在地を取得して受け取り場所との距離を加味して、徒歩時間と車での時間を表示出来ます。<br>当日のみ前提の仕様になっています。<img src="https://gyazo.com/6042378b6869ca308d11b39bf12329af/raw" height="200px" align="right"><br clear="all"></div>
<br>

### 【注文関連未実装】
<br>

- 注文側にログイン機能がないので注文した情報を注文者が保持できず、店側も注文者を判断出来ません。メールを送信するか、QRコードを発行するなど必要だと思いますが、今回は未実装です。
- 会計時にかごに一度入れたものを編集して会計に移ることは出来ますが、編集して会計せずに買い物かごに保存させる機能が未実装です。
- 店舗営業時間を加味した実装。

<br>

## ②店舗側
### 【会員登録】
<br>
<br>
<div><img src="https://gyazo.com/4129a7456f3240b8cd7b75576328b183/raw" height="200px" align="left" magin-right="100px">会員登録、ログインのボタンは下にあります。注文者が間違って入らない為の配慮です。<br>店名・ジャンル・Eメール・パスワード・画像で1ページ目、2ページ目では時間と場所を登録します。<br>画像はなくて登録出来ます。<br>現在地は緯度経度で取得してますが、注文者側が取りに行く為に住所の記載が必要なので、ダブルで保存しています。建物の階は取得出来ないので手入力になります。<img src="https://gyazo.com/82da959cef7aac7357747b5b11afa402/raw" height="200px" align="right"><br clear="all"></div>
<br>

### 【料理登録】
<br>
<div><img src="https://gyazo.com/e250bcf4d4074ecc34cd3a98817db266/raw" height="200px" align="left" magin-right="100px">名前・説明・画像・単価・調理時間で登録します。<br>登録されているものが一覧で表示されます。<img src="https://gyazo.com/13072b5aeeed3f780c1aa5d5c94fe089/raw" height="200px" align="right"><br clear="all"></div>
<br>

### 【未実装】
<br>

- 受けた注文の一覧、詳細が未実装です。
- 料理の編集機能、会員登録情報の編集機能が未実装です。
- 登録時店でない場所にいて緯度経度取得ができない場合に、逆に入力された住所から緯度経度を取得する機能が未実装です。