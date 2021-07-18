# hdd_zero_write
Write zero to hard disk (SSD) and check zero
廃棄前のディスク全体のデータ抹消します。
ハードディスクを1GBごとに非0を数えて、非0があれば、0を書き込みます。

## OS
Ubuntu 18

## 目的

1GBブロックごとに非0を数えます。
非0があれば、その1GBブロック全体に0を書き込みます。

SSDは書き込み回数の制限があります。
Gutmanの35回書き込みや、NSA方式の3回書き込みは、SSDの寿命を縮めてしまいそうで心配です。
SSDは、0を書き込むだけの1パス、それも非0が見つかった領域だけを処理したい。

また、他のデータ抹消ソフトでzero書き込みした後、本当にzeroを書き込んだのか、確認する方法がありません。
本当にzeroを書き込んだのか、確認したいんですね。

解説記事
https://www.ninton.co.jp/archives/8488

## 使い方

### git clone
```
$ git clone https://github.com/ninton/hdd_zero_write.git
$ cd hdd_zero_write
```

### データ抹消したいハードディスクまたはSSDをUSB3に接続してください

### lsblkでデバイス名を確認してください

```
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
...
sda      8:0    0 894.3G  0 disk 
├─sda1   8:1    0   512M  0 part /boot/efi
└─sda2   8:2    0 893.8G  0 part /
sdb      8:16   0   2.7T  0 disk 
└─sdb1   8:17   0   2.7T  0 part /media/hoge/USB_3TB_BKUP1
sdc      8:32   0   477G  0 disk ★コレがターゲットです！
└─sdc1   8:33   0   477G  0 part /media/hoge/C0E2F85FE2F85ADC

```

### zero書き込みの実行

512GBのSSDで、約1.5時間かかりました。

くれぐれも、デバイス名を間違えないように注意してください。
sudoのパスワードを聞かれたら、入力してください。

```
$ time ./hdd_zero_write.sh /dev/sdc
total_bytes=512110190592

skip=0
[sudo] hoge のパスワード: 
1+0 レコード入力
2097152+0 レコード出力
notzero_bytes=0

skip=1
1+0 レコード入力
2097152+0 レコード出力
notzero_bytes=0

...
```

最後、「notzero_bytes=0」を表示されれば、非0はありません。全ての領域に0が書き込まれています。


```
notzero_bytes=0

real	94m8.700s
user	54m19.780s
sys	50m51.366s
```


廃棄前のディスク全体のデータ抹消が目的です。
パーティション /dev/sdc1 を指定して実行したことはありません。
