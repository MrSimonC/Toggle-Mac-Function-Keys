-- Apple Script (i.e. Use in Apple's Script Editor Application) to Toggle Function Keys / Media keys on/off
-- Tested on MacOS Monterey (12.6.2) Dec 2022, MacOS Ventura (13.0.1) Dec 2022
-- Project Path: https://github.com/MrSimonC/Toggle-Mac-Function-Keys

set osver to system version of (system info)

if osver > 13.0 then
	-- Full credit for this section to https://www.reddit.com/user/mflboys/ for creating MacOS Ventura code:
	-- from https://www.reddit.com/r/shortcuts/comments/yjlxvo/macos_ventura_shortcut_toggle_function_keys_f1f2/
	open location "x-apple.systempreferences:com.apple.Keyboard-Settings.extension"
	
	tell application "System Events" to tell process "System Settings"
		repeat until window "Keyboard" exists
		end repeat
		
		tell window "Keyboard"
			# "Keyboard Shortcuts..." Button
			click button 1 of group 2 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1
			
			repeat until sheet 1 exists
			end repeat
			
			# Click Function Keys
			keystroke "f"
			
			repeat until checkbox "Use F1, F2, etc. keys as standard function keys" of group 1 of scroll area 1 of group 2 of splitter group 1 of group 1 of sheet 1 exists
			end repeat
			
			click checkbox "Use F1, F2, etc. keys as standard function keys" of group 1 of scroll area 1 of group 2 of splitter group 1 of group 1 of sheet 1
			
			# "Done" Button - Close the sheet so the application can quit
			click button 1 of group 2 of splitter group 1 of group 1 of sheet 1
			
			# Attempting to check the sheet at a certain point while closing will throw an error
			# In that case, the outer repeat will try again
			repeat
				try
					repeat while sheet 1 exists
					end repeat
					exit repeat
				end try
			end repeat
			
		end tell
	end tell
	
	tell application "System Preferences" to quit
else
	-- Below for MacOS Monterey and below
	tell application "System Preferences"
		set current pane to pane "com.apple.preference.keyboard"
	end tell
	
	tell application "System Events"
		if UI elements enabled then
			tell application process "System Preferences"
				repeat until exists tab group 1 of window "Keyboard"
					delay 0.5
				end repeat
				click radio button "Keyboard" of tab group 1 of window "Keyboard"
				try
					click checkbox "Use F1, F2, etc. keys as standard function keys on external keyboards" of tab group 1 of window "Keyboard"
				end try
				try
					click checkbox "Use F1, F2, etc. keys as standard function keys" of tab group 1 of window "Keyboard"
				end try
			end tell
			tell application "System Preferences" to quit
		else
			-- GUI scripting not enabled.  Display an alert
			tell application "System Preferences"
				activate
				set current pane to pane "com.apple.preference.security"
				display dialog "UI element scripting is not enabled. Please activate this app under Privacy -> Accessibility so it can access the settings it needs."
			end tell
		end if
	end tell
end if