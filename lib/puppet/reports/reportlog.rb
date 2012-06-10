require 'puppet'
Puppet::Reports.register_report(:reportlog) do
  desc <<-DESC
  Logs more useful information than the default 'log' report, such as metrics.
DESC

  def process
    client = self.host
    logs = self.logs
    config_version = self.configuration_version
    dir = File.join(Puppet[:reportdir], client)
    Dir.mkdir(dir) unless File.exists?(dir)
    file = config_version + ".logs"
    destination = File.join(dir, file)
    File.open(destination,"w") do |f|
      f.write(logs)
    end
  end
end

