#!/usr/bin/env ruby
# watch.rb by Brett Terpstra, 2011 <http://brettterpstra.com>
# with credit to Carlo Zottmann <https://github.com/carlo/haml-sass-file-watcher>
# Updated by Tyler Hoyt (CodeCorrupt), Nov 2015 <https://github.com/CodeCorrupt>

trap("SIGINT") { exit }

if ARGV.length != 3
  puts "Usage: #{$0} watch_folder keyword [chrome|safari]"
  puts "Example: #{$0} ~/Sites mywebproject chrome"
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
      %x{osascript #{browser}-refresh.scpt "#{keyword}"}
    end
  end
  sleep 1
end
