on run arg
	tell application "/Applications/Google Chrome.app"
		set windowList to every window
		repeat with aWindow in windowList
			set tabList to every tab of aWindow
			repeat with atab in tabList
				if (URL of atab contains arg) then
					execute atab javascript "window.location.reload()"
				end if
			end repeat
		end repeat
		--activate
	end tell
end run
