require "bundler/gem_tasks"

task :update_ips do
  file = "lib/rack/cloudflare/ips.txt"
  system("curl https://www.cloudflare.com/ips-v4 > #{file} && echo >> #{file} && curl https://www.cloudflare.com/ips-v6 >> #{file}")
  puts "New IP ranges:"
  puts File.read(file)
end
