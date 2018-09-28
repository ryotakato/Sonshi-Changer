#!/bin/bash
id=$(xinput list | grep Translate | grep -o 'id=[0-9]*' | grep -o [0-9]*)

state=$(xinput list | grep Translated)
# 内蔵キーボードの行のみを抽出できるよう、固有の文字列をgrepに渡す
# 作者の環境では Translated

master=3

if [[ $state =~ floating ]];

	then
		notify-send '尊師スタイルOFF' \ "内蔵キーボード - 接続" -i ~/Sonshi-Changer/sonshi_off.jpg;

		xinput reattach $id $master
		fcitx-imlist -s mozc
		fcitx-imlist -s fcitx-keyboard-jp

		sed -i 's/mozc,us/mozc,jp/' ~/.config/fcitx/data/layout_override
		sed -i -e '3c\TriggerKey=CTRL_SPACE ZENKAKUHANKAKU' ~/.config/fcitx/config

		# alt-ime-swich OFF
		sed -i -e '34c\#ActivateKey=ALT_RALT' ~/.config/fcitx/config
		sed -i -e '36c\#InactivateKey=ALT_LALT ESCAPE' ~/.config/fcitx/config


elif [[ $state =~ slave ]];
	then
		notify-send "尊師スタイル ON" \ "内蔵キーボード - 切断" -i ~/Sonshi-Changer/sonshi_on.jpg;

		xinput float $id
		fcitx-imlist -s mozc
		fcitx-imlist -s fcitx-keyboard-us

		sed -i 's/mozc,jp/mozc,us/' ~/.config/fcitx/data/layout_override
		sed -i -e '3c\TriggerKey=CTRL_SPACE' ~/.config/fcitx/config

		# alt-ime-switch ON
		sed -i -e '34c\ActivateKey=ALT_RALT' ~/.config/fcitx/config
		sed -i -e '36c\InactivateKey=ALT_LALT ESCAPE' ~/.config/fcitx/config


else
		notify-send "尊師スタイル エラー" \ "sonshi.h を実行できませんでした";

fi
