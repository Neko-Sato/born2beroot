
## sshの設定
```
$ sed s/#Port 22/Port 4242/ /etc/sshd_config
$ sed s/#PermitRootLogin prohibit-password/PermitRootLogin no/ /etc/sshd_config
$ service ssh restart
```

## ファイヤーウォールの設定
```
$ apt install ufw
$ ufw default DENY
$ ufw allow 4242
```

## sudoの設定
```
$ apt install sudo
$ adduser [user_name] sudo
```

## グループの設定
```
$ groupadd user42
$ adduser [user_name] user42
```

## パスワードポリシーの設定
```
$ sed s/#PASS_MAX_DAYS  99999/PASS_MAX_DAYS   30/ /etc/login.defs
$ sed s/#PASS_MIN_DAYS  0/PASS_MIN_DAYS  2/ /etc/login.defs

```
