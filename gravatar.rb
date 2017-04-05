#!/usr/bin/env ruby -w 

require 'digest/md5'

email = ARGV[0] || 'juliannicholls29@gmail.com'

digest = Digest::MD5.hexdigest email

puts "https://gravatar.com/avatar/#{digest}"


