require 'puppet/reports'

Puppet::Reports.register_report(:reportlog) do
  desc "Send metrics to log, structured to make it easy with Splunk."

  def process
    node = self.host.split('.', 2)[0]

    prefix_msg = "[reportlog] node=#{node} ver=\"#{self.configuration_version.to_s}\""

    self.metrics.each do |category,data|

      msg = Array.new
      msg += [ prefix_msg ]
      msg += [ 'category="%s"' % category ]

      if category == 'time'
        msg += [ 'units="seconds"' ]
      end

      msg += data.values.map do |val|
        metric = val[1].downcase.tr(' ', '_')
        value = val[2].to_s

        '%s="%s"' % [metric, value]
      end

      Puppet.info(msg.join(' '))
    end
  end
end

