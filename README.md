## OSのインストール
- ホスト名は42で終わるようにする
- 暗号化されたパーティションを作る

## sudoの設定
```
$ su -
# sudoをインストール
$ apt install sudo
# sudo groupに追加
$ adduser [user_name] sudo
```

## sshの設定
```
# sshのポートを変更
$ sudo sed s/#Port 22/Port 4242/ /etc/sshd_config
# rootでのログインを不可に
$ sudo sed s/#PermitRootLogin prohibit-password/PermitRootLogin no/ /etc/sshd_config
# 反映
$ sudo service ssh restart
```

## ファイヤーウォールの設定
```
# ufwのインストール
$ sudo apt install ufw
# ポートの設定
$ sudo ufw default DENY
$ sudo ufw allow 4242
```

## グループの設定
```
# グループを作成しユーザーを追加
$ sudo groupadd user42
$ sudo adduser [user_name] user42
```

## パスワードポリシーの設定
```
# pam_pwqualityをインストール
$ sudo apt install pam_pwquality
# 有効期限を30日, 変更不可期限を2日, 通知を7日前に(default)
$ sudo sed s/PASS_MAX_DAYS  99999/PASS_MAX_DAYS   30/ /etc/login.defs
$ sudo sed s/PASS_MIN_DAYS  0/PASS_MIN_DAYS  2/ /etc/login.defs
# 長さの最小値を10に
$ sudo sed s/# minlen = 8/minlen = 10/ /etc/security/pwquality.conf
# 大小英数が含まれている必要がある
$ sudo sed s/# lcredit = 0/lcredit = -1/ /etc/security/pwquality.conf
$ sudo sed s/# ucredit = 0/ucredit = -1/ /etc/security/pwquality.conf
$ sudo sed s/# dcredit = 0/dcredit = -1/ /etc/security/pwquality.conf
# 3文字以上連続して同じ文字が使われてはならない
$ sudo sed s/# maxrepeat = 0/maxrepeat = 3/ /etc/security/pwquality.conf
# ユーザー名が使われてはならない
$ sudo sed s/# usercheck = 1/usercheck = 1/ /etc/security/pwquality.conf
# rootにも適応させる
$ sudo sed s/# enforce_for_root/enforce_for_root/ /etc/security/pwquality.conf
# 前のパスワードじゃない７つの文字が必要
$ sudo sed s/# difok = 1/difok = 7/ /etc/security/pwquality.conf

# パスワードを再設定する
$ sudo passwd root
$ sudo passwd [user_name]
```

## sudoグループの設定
```
# 下コードを追記
# 三回までトライできる
# エラー時のコメント
# ログの出力先
# ttyのやつ
# なんかディレクトリの保護
$ sudo visudo
```
```
Defaults	passwd_tries = 3
Defaults	badpass_message="You're a fucking fake."
Defaults	logfile=/var/log/sudo/
Defaults	requiretty
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```

## monitoring.shの作成
```
$ sudo apt install net-tools
```
- OSのアーキテクチャとそのカーネルバージョン
- 物理プロセッサの数
- 仮想プロセッサーの数
- サーバーで現在使用可能なRAMとその使用率（パーセント）
- サーバー上の現在の利用可能なメモリとその使用率（パーセント）
- プロセッサーの現在の使用率（パーセント）
- 最後のリブートの日付と時刻
- LVMがアクティブかどうか
- アクティブな接続数
- サーバーを使用しているユーザー数
- サーバーのIPv4アドレスとそのMAC（Media Access Control）アドレス
- sudoプログラムで実行されたコマンドの数