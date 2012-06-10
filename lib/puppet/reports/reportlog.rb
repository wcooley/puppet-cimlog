require 'puppet/reports'

Puppet::Reports.register_report(:reportlog) do
  desc "Send all received logs to the local log destinations.  Usually
    the log destination is syslog."

  def process
    self.metrics.each do |category,data|
      data.values.each do |val|
        metric = val[1]
        value = val[2]

        if category == 'time'
          units = 'seconds'
        else
          units = category
        end

        Puppet.info("[reportlog] category=\"#{category}\" metric=\"#{metric}\" units=\"#{units}\" value=\"#{value}\"")
      end
    end
  end
end

