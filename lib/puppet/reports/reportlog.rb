require 'puppet/reports'

Puppet::Reports.register_report(:reportlog) do
  desc "Send all received logs to the local log destinations.  Usually
    the log destination is syslog."

  def process
    self.metrics.each do |metric,data|
      Puppet.info("[reportlog] metric=#{metric} data=\"#{data.to_yaml}\"")
    end
  end
end

