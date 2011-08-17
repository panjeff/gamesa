open("/etc/passwd","r") do |s|
  puts s.readlines
end
