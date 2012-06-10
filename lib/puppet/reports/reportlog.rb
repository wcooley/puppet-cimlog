require 'puppet'
Puppet::Reports.register_report(:reportlog) do
  desc <<-DESC
  Logs more useful information than the default 'log' report, such as metrics.
DESC

  def process
    File.open('/tmp/puppet-reportlog.log', 'w') do |f|
      self.metrics.each do |name, metric|
        f.puts("name=#{name} metric=#{metric}")
      end
    end
  end
end

