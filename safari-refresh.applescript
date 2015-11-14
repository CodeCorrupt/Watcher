on run arg
	tell application "Safari"
		set windowList to every window
		repeat with aWindow in windowList
			set tabList to every tab of aWindow
			repeat with atab in tabList
				if (URL of atab contains arg) then
					tell atab to do JavaScript "window.location.reload()"
				end if
			end repeat
		end repeat
		--activate
	end tell
end run
