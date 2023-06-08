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
$ sudo sed s/#PASS_MAX_DAYS  99999/PASS_MAX_DAYS   30/ /etc/login.defs
$ sudo sed s/#PASS_MIN_DAYS  0/PASS_MIN_DAYS  2/ /etc/login.defs
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
```

## sudoグループの設定
```
# 以下を追記
$ sudo visudo
```
```
Defaults	passwd_tries = 3
Defaults	badpass_message="You're a fucking fake."
Defaults	logfile=/var/log/sudo/
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```