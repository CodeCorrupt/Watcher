#!/usr/bin/env ruby
# watch.rb by Brett Terpstra, 2011 <http://brettterpstra.com>
# with credit to Carlo Zottmann <https://github.com/carlo/haml-sass-file-watcher>
# Updated by Tyler Hoyt (CodeCorrupt), Nov 2015 <https://github.com/CodeCorrupt>

trap("SIGINT") { exit }

browsers = ['chrome', 'safari']

if ARGV.length != 3
    puts "Usage: #{$0} path_to_watch keyword #{browsers}]" 
    puts "Example: #{$0} ~/Sites localhost chrome"
    exit
end

if ! browsers.include? ARGV[2]
    puts "Invalid browser. Please select a browser from the list:"
    puts "    #{browsers}"
    exit
end

filetypes = ['css','html','htm','php','rb','erb','less','js']
watch_folder = ARGV[0]
keyword = ARGV[1]
browser = ARGV[2]
puts "Watching #{watch_folder} and subfolders for changes in project files..."

while true do
    files = []
    filetypes.each {|type|
        files += Dir.glob( File.join( watch_folder, "**", "*.#{type}" ) )
    }
    new_hash = files.collect {|f| [ f, File.stat(f).mtime.to_i ] }
    hash ||= new_hash
    diff_hash = new_hash - hash

    unless diff_hash.empty?
        hash = new_hash

        diff_hash.each do |df|
            puts "Detected change in #{df[0]}, refreshing"
            if browser == "safari"
                %x{osascript<<ENDGAME
tell application "/Applications/Safari.app"
	set windowList to every window
	repeat with aWindow in windowList
		set tabList to every tab of aWindow
		repeat with atab in tabList
			if (URL of atab contains "#{keyword}") then
				tell atab to do JavaScript "window.location.reload()"
			end if
		end repeat
	end repeat
	--activate
end tell
ENDGAME
                }

            end

            if browser == "chrome"
            %x{osascript<<ENDGAME
tell application "/Applications/Google Chrome.app"
	set windowList to every window
	repeat with aWindow in windowList
		set tabList to every tab of aWindow
		repeat with atab in tabList
			if (URL of atab contains "#{keyword}") then
				execute atab javascript "window.location.reload()"
			end if
		end repeat
	end repeat
	--activate
end tell
ENDGAME
            }
            end
        end
    end
    sleep 1
end
