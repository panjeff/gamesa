x=[
  ["1.2.3.4","domain1.com","domain1"],
  ["11.12.13.14","domain11.com","domain11"],
  ["111.112.113.114","domain111.com","domain111"],
]

x.each do |s|
   open("a.txt","a") do |f|
    f.puts "ip #{s[0]}"
   end
   open("b.txt","a") do |f|
    f.puts "name #{s[1]}"
   end
   open("c.txt","a") do |f|
    f.puts "domain #{s[2]}"
   end
end
