# Mandatory
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
# sshのポートを変更 rootでのログインを不可に
$ sudo sed -i /etc/ssh/sshd_config\
$ -e "s/#Port 22/Port 4242/"\
$ -e "s/#PermitRootLogin prohibit-password/PermitRootLogin no/" 
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
# libpam_pwqualityをインストール
$ sudo apt install libpam-pwquality
# 有効期限を30日, 変更不可期限を2日, 通知を7日前に(default)
$ sudo sed -i /etc/login.defs\
$ -e "s/PASS_MAX_DAYS  99999/PASS_MAX_DAYS   30/"\
$ -e "s/PASS_MIN_DAYS  0/PASS_MIN_DAYS  2/"
$ sudo passwd -x 30 -n 2 root
$ sudo passwd -x 30 -n 2 [user_name]
# 長さの最小値を10に
# 大小英数が含まれている必要がある
# 3文字以上連続して同じ文字が使われてはならない
# ユーザー名が使われてはならない
# rootにも適応させる
# 前のパスワードじゃない７つの文字が必要
$ sudo -i /etc/security/pwquality.conf\
$ -e sed "s/# minlen = 8/minlen = 10/"\
$ -e "s/# lcredit = 0/lcredit = -1/"\
$ -e "s/# ucredit = 0/ucredit = -1/"\
$ -e "s/# dcredit = 0/dcredit = -1/"\
$ -e "s/# maxrepeat = 0/maxrepeat = 3/"\
$ -e "s/# usercheck = 1/usercheck = 1/"\
$ -e "s/# enforce_for_root/enforce_for_root/"\
$ -e "s/# difok = 1/difok = 7/"
# パスワードを再設定する
$ sudo passwd root
$ sudo passwd [user_name]
```

## sudoグループの設定
```
$ sudo mkdir /var/log/sudo/
# 次コードを追記
# 三回までトライできる
# エラー時のコメント
# ログの出力先
# ttyのやつ
# なんかディレクトリの保護
$ sudo visudo
$ sudo apt
$ sudo chmod +r /var/log/sudo/sudo.log
```
```
Defaults	passwd_tries = 3
Defaults	badpass_message="You're a fucking fake."
Defaults	logfile=/var/log/sudo/sudo.log
Defaults	requiretty
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```

## monitoring.sh
```
$ wget https://raw.githubusercontent.com/Neko-Sato/born2beroot/main/monitoring.sh
$ sudo mv monitoring.sh /usr/local/bin/ 
# 次のコードを追記
$ sudo crontab -e
```
```
*/10 * * * * bash /usr/local/bin/monitoring.sh
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

# Bonus
- パーティション
マニュアル設定にて
以下のようにパーティションを作成
```
基本	500M	ext2 	/boot
理論	max		crypt
```
ボリュームの暗号化
暗号化ボリュームをlvmにする
LVMGroupを作成し以下を作成
```
root	10G		ext4 /
swap	2.3G	swap
home	5G		ext4 /home
var		3G		ext4 /var
srv		3G		ext4 /svr
tmp		3G		ext4 /tmp
var-log	4G		ext4 /var/log
```

- WordPress
```
# インストール
$ sudo apt install lighttpd php-fpm php-mysqlnd mariadb-server
# 所有者変更
$ chown -R www-data:www-data /var/www/
# WordPressのダウンロード
$ wget https://ja.wordpress.org/latest-ja.tar.gz
$ tar -zxvf latest-ja.tar.gz
$ sudo rm -rf /var/www/html/*
$ sudo cp -r ~/wordpress/* /var/www/html
$ sudo rm -rf latest-ja.tar.gz ~/wordpress
# ポートの開放
$ sudo ufw allow 80
# 下記設定を追記
$ sudo vim /etc/lighttpd/lighttpd.conf
# sudo service lighttpd restart
# dbのセットアップ
$ sudo mysql_secure_installation
# sudo mariadb
> CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress';
> CREATE DATABASE wordpress;
> GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
> FLUSH PRIVILEGES;
> exit;
```

/etc/lighttpd/lighttpd.confに追記
```
server.modules += ( "mod_fastcgi" )

fastcgi.server = (
	".php" => (
		"localhost" => ( 
		"socket" => "/run/php/php-fpm.sock",
		"broken-scriptfilename" => "enable"
	))
)
```
http://localhost/
にて設定
