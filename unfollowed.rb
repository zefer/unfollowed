require 'twitter'
require 'json'

user = ARGV.first
raise "username arg must be provided" if user.nil?

filename = "#{user}.followers.json"

followers = Twitter.follower_ids(user)[:ids]

if File.exists?(filename)
  # 
  # Compare current followers with previous followers (from file)
  #
  f = File.open(filename, "r")
  previous_followers = JSON.parse(f.read)
  unfollowers = previous_followers - followers
  
  if unfollowers.length > 0
    puts "\n#{user} has #{followers.length} followers. #{unfollowers.length} users have unfollowed:"
  
    unfollowers.each do |id|
      begin
        u = Twitter.user(id)
        puts " - @#{u.screen_name} (#{u.name})"
      rescue
        puts " - #{id}"
      end
    end
  else
    puts "\n#{user} still has #{followers.length} followers!"
  end
else
  # 
  # Current followers only (no past data available)
  #
  puts "\n#{user} has #{followers.length} followers."
end

File.open(filename,"w") do |f|
  f.write(followers.to_json)
end
