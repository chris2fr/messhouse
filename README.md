# messhouse

Mess House Nixos Django Deployment

```
[nix-shell:~/messhouse]# su - django

[django@nixos:~]$ python3 --version
Python 3.11.8

[django@nixos:~]$ python3 -m venv venv

6: venet0@if105: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether e2:af:3a:ed:7c:10 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 37.205.14.63/32 scope global venet0
       valid_lft forever preferred_lft forever
    inet6 2a03:3b40:fe:7d7::1/64 scope global
       valid_lft forever preferred_lft forever
    inet6 fe80::e0af:3aff:feed:7c10/64 scope link proto kernel_ll
       valid_lft forever preferred_lft forever

```

IP v4: 37.205.14.63

IP v6: 2a03:3b40:fe:7d7::1

ssh django@37.205.14.63

git clone https://www.github.com/SViarbitskya/grore-django-app

