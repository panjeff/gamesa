x=[1,2,3,5,6,7,8]
y=[]
c=false

x.each_index do |s|
   unless c
     y << [x[s]]
     c=true
   end
   if x[s]+1 != x[s+1]
      y[-1] << x[s]
      c=false
   end
end
   
p y
