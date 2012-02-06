open("/etc/passwd","r") do |s|
  puts s.readlines
end

# add a test comment by pyh