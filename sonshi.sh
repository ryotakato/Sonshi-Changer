#!/bin/bash
id=$(xinput list | grep LITE-ON | grep -o 'id=[0-9]*' | grep -o [0-9]*)

state=$(xinput list | grep LITE-ON)
# 内蔵キーボードの行のみを抽出できるよう、固有の文字列をgrepに渡す
# この環境では LITE-ON

master=3

if [[ $state =~ floating ]];

	then
		notify-send '尊師スタイルOFF' \ "JPキーボード - 接続" -i ~/Sonshi-Changer/sonshi_off.jpg;

		xinput reattach $id $master
		fcitx-imlist -s mozc
		fcitx-imlist -s fcitx-keyboard-jp

		sed -i 's/mozc,us/mozc,jp/' ~/.config/fcitx/data/layout_override
		sed -i -e '3c\TriggerKey=CTRL_SPACE' ~/.config/fcitx/config

		# alt-ime-switch OFF 書き換えなくても同じだが、一応 USとJPキーボードでは使うかな入力文字も違う
		sed -i -e '34c\ActivateKey=HIRAGANAKATAKANA HANGUL' ~/.config/fcitx/config
		sed -i -e '36c\InactivateKey=ZENKAKUHANKAKU HANGULHANJA' ~/.config/fcitx/config


elif [[ $state =~ slave ]];
	then
		notify-send "尊師スタイル ON" \ "JPキーボード - 切断" -i ~/Sonshi-Changer/sonshi_on.jpg;

		xinput float $id
		fcitx-imlist -s mozc
		fcitx-imlist -s fcitx-keyboard-us

		sed -i 's/mozc,jp/mozc,us/' ~/.config/fcitx/data/layout_override
		sed -i -e '3c\TriggerKey=CTRL_SPACE' ~/.config/fcitx/config

		# alt-ime-switch ON 書き換えなくても同じだが、一応 USとJPキーボードでは使うかな入力文字も違う
		sed -i -e '34c\ActivateKey=HIRAGANAKATAKANA HANGUL' ~/.config/fcitx/config
		sed -i -e '36c\InactivateKey=ZENKAKUHANKAKU HANGULHANJA' ~/.config/fcitx/config


else
		notify-send "尊師スタイル エラー" \ "sonshi.sh を実行できませんでした";

fi
