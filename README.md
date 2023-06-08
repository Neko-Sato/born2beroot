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
# pam_pwquality, pam_cracklibをインストール
$ sudo apt install pam_pwquality pam_cracklib
# 有効期限を30日, 変更不可期限を2日, 通知を7日前に(default)
$ sudo sed s/#PASS_MAX_DAYS  99999/PASS_MAX_DAYS   30/ /etc/login.defs
$ sudo sed s/#PASS_MIN_DAYS  0/PASS_MIN_DAYS  2/ /etc/login.defs

```

## sudoグループの設定
```
echo >> /etc/sudoers
# ログ設定
echo Defaults	logfile=/var/log/sudo/ >> /etc/sudoers
# パス制限設定
echo Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin" >> /etc/sudoers
```