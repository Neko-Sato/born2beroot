
```
$ su -

$ sed s/#Port 22/Port 4242/ /etc/sshd_config
$ sed s/#PermitRootLogin prohibit-password/PermitRootLogin no/ /etc/sshd_config

$ apt install ufw
$ ufw default DENY
$ ufw allow 4242

$ apt install sudo
$ groupadd user42
$ adduser $(whoami) user42
$ adduser $(whoami) sudo
```