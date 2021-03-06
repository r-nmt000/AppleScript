on run
	set modelist to {"Sleep mode (hibernatemode 0)", "Safe sleep mode (hibernatemode 3)", "Deep sleep mode (hibernatemode 25)                                 "}
	set exp to "
Sleep mode : 常にサスペンド
Safe Sleep mode : サスペンドから一定時間でハイバネーション
Deep Sleep mode : メモリを開放してからハイバネーション
"
	choose from list modelist default items "Sleep mode (hibernatemode 0)" with prompt my check_mode() & "

【変更したいスリープモードを選んでください】" & exp with title "スリープモードの変更"
	
	if the result is not false then
		set modetype to last item of words of (get item 1 of result)
		if (modetype = "0") then set modenum to modetype & " ; if [ -f /var/vm/sleepimage ]; then sudo rm /var/vm/sleepimage; fi;"
		if (modetype = "3") then set modenum to modetype
		if (modetype = "25") then set modenum to modetype
		
		try
			do shell script "sudo pmset -a hibernatemode " & modenum with administrator privileges
			display dialog "変更を完了しました
" & my check_mode() buttons {"OK"} default button "OK" with title "確認"
		on error
			display dialog "スリープモードの変更をキャンセルしました
" & check_mode() buttons {"OK"} default button "OK" with title "確認"
		end try
	end if
end run

on check_mode()
	set type to (get item 2 of words of (do shell script "pmset -g|grep hibernatemode"))
	set mode to ""
	if (type = "0") then set mode to "Sleep mode (hibernatemode " & type & ")"
	if (type = "3") then set mode to "Safe Sleep mode (hibernatemode " & type & ")"
	if (type = "25") then set mode to "Deep Sleep mode (hibernatemode " & type & ")"
	return "現在の設定は \"" & mode & "\" です"
end check_mode