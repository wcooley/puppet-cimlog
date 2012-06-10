require 'puppet/reports'

Puppet::Reports.register_report(:reportlog) do
  desc "Send all received logs to the local log destinations.  Usually
    the log destination is syslog."

  def process
    prefix_msg = "[reportlog] node=#{self.host} ver=\"#{self.configuration_version.to_s}\" "
    self.metrics.each do |category,data|
      data.values.each do |val|
        metric = val[1]
        value = val[2]

        if category == 'time'
          units = 'seconds'
        else
          units = category
        end

        msg = prefix_msg + 'category="%s" metric="%s" value="%s" units="%s"' %
              [category, metric, value, units]

        Puppet.info(msg)
      end
    end
  end
end

