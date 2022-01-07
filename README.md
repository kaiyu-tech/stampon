# StamPon

**すたんぽん**は、Discordの発言をブックマークするサービスです。
ブックマークしたい発言に「**気になる**」か「👀」スタンプを押すことで自動登録します。
Web上に自分のブックマーク管理サイトを持ち、絞り込み検索や削除することが出来ます。

# Setup

- initialization

```sh
git clone https://github.com/kaiyu-tech/stampon
```

```sh
cd stampon
```

```sh
bin/setup
```

- environment variable

```sh
touch .env
```

```txt
# Example of '.env'
TZ = Asia/Tokyo
LANG = ja-JP

DISCORD_CLIENT_ID = <YOUR_DISCORD_CLIENT_ID>
DISCORD_CLIENT_SECRET = <YOUR_DISCORD_CLIENT_SECRET>
DISCORD_REDIRECT_URI = http://127.0.0.1:3000
DISCORD_SCOPE = identify%20guilds
DISCORD_GUILD_ID = <YOUR_DISCORD_GUILD_ID>

STAMPON_API_TOKEN = <YOUR_STAMPON_API_TOKEN>
STAMPON_EXPIRES_IN = 10800
```

| Environment variable name | Description  |
| ---  | --- |
| DISCORD_CLIENT_ID | OAuth2 Client ID  |
| DISCORD_CLIENT_SECRET | OAuth2 Client Secret  |
| DISCORD_REDIRECT_URI | Destination to redirect to after authentication |
| DISCORD_SCOPE | Scope required by the application |
| DISCORD_GUILD_ID | Specifying where to use Stampon Bot  |
| STAMPON_API_TOKEN | Token to access the Stampon API  |
| STAMPON_EXPIRES_IN | Expiration date of login session |

```sh
# Example of 'STAMPON_API_TOKEN'
bin/rails runner 'p SecureRandom.urlsafe_base64(24)'
```

# Seeds

```sh
bin/rails db:seed
```

# Lint & Prettier & Test

```sh
rubocop

yarn run fix

bin/rails test:all
```

# Run

```sh
bin/rails s
```

# 使い方

1. [StamPon](https://stampon.herokuapp.com/)にアクセスしてください。

※現在は、このサービスは「フィヨルドブートキャンプ専用」となっております。

![001](https://user-images.githubusercontent.com/73627898/143539353-a0e6db17-2c5b-433a-bed4-6c2a52f42936.jpg)

2. Discordにログインしてください。

![002](https://user-images.githubusercontent.com/73627898/143539395-f20a2aa8-a461-48b9-98ce-c8f81fd6c426.jpg)

3. Botに必要な権限を確認して認証してください。

![003](https://user-images.githubusercontent.com/73627898/143539399-b18d6922-eeca-4b3d-8bb7-9be21a9bf68a.jpg)

4. ログイン後の画面です。

![004](https://user-images.githubusercontent.com/73627898/143539412-f484392b-fa3b-487d-86d1-b09030ed6fb6.jpg)

5. Discordでブックマークしたい発言に「気になる」か「👀」のスタンプでリアクションを付けてください。

![005](https://user-images.githubusercontent.com/73627898/143539421-0610c56e-bd30-44df-84a0-717306055b4c.jpg)

6. 以下がリアクションが付いた状態です。

![006](https://user-images.githubusercontent.com/73627898/143539550-29c1451a-c6fd-4092-b991-340be3fc7d5c.jpg)

7. 以下のようにブックマークが追加されます。

![007](https://user-images.githubusercontent.com/73627898/143539449-e92edac3-0983-458a-bbfb-b327b4560967.jpg)

8. ブックマークを選択して「タイトル」や「ノート」を編集することが出来ます。

![008](https://user-images.githubusercontent.com/73627898/143540283-65d4cf6e-c48d-4561-aa35-01bd1d364821.jpg)

9. 「ログアウト」や「アカウントの削除」はアイコンマークから行えます。

![009](https://user-images.githubusercontent.com/73627898/143539467-24cb953b-c362-479c-a411-2977e29ea824.jpg)
