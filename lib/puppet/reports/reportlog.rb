require 'puppet'
Puppet::Reports.register_report(:reportlog) do
  desc <<-DESC
  Logs more useful information than the default 'log' report, such as metrics.
DESC

  def process
    dir = File.join(Puppet[:reportdir], self.host)
    Dir.mkdir(dir) unless File.exists?(dir)
    file = self.config_version + ".logs"
    destination = File.join(dir, file)
    File.open(destination,"w") do |f|
      Puppet::Util::Log.newmessage("reportlog: writing to #{destination}")
#      f.write(logs)
      self.metrics.each do |name, metric|
        f.puts("name=#{name} metric=#{metric}")
      end
    end
#    File.open('/tmp/puppet-reportlog.log', 'w') do |f|
#    end
  end
end

