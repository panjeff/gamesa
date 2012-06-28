require 'net/ftp'
host = '120.132.133.34'
user = 'administrator'
pass = '21vianet'
file = '100M.tgz'

Net::FTP.open(host) do |ftp|
  ftp.login(user,pass)
  size = ftp.size(file)
  t1 = Time.now
  ftp.getbinaryfile(file)
  t = Time.now - t1
  printf("get speed: %10.2f KB/s\n", size/(1024*t))
end

