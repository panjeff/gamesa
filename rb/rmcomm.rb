lab=0
File.open("1.rb").each_line do |s|
   next if s=~/^#|^$/
   if s=~/^=begin/
      lab = 1
   elsif s=~/^=end/
      lab = 0
      next
   end
   next if lab == 1
   puts s
end
   
