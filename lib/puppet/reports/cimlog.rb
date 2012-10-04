require 'puppet'

Puppet::Reports.register_report(:cimlog) do
  desc "Send metrics to log, structured to make it easy with Splunk."

  def process
    cimlog_base
    cimlog_metrics
    cimlog_logs
    cimlog_resource_statuses
  end

  def prefix_msg(p=undef)
    if p
      prefix = "[cimlog/#{p}]"
    else
      prefix = "[cimlog]"
    end

    @node = self.host.split('.', 2)[0] if not @node
    @run_id = Time.now.to_i.to_s if not @run_id

    [prefix, "dest=#{@node}", "event_id=#{@run_id}"]
  end

  def cimlog_base
    @prefix_msg = "[cimlog] dest=#{@node} event_id=#{@run_id}"
    Puppet.notice(self.prefix_msg, %W{
                  ver="#{self.configuration_version.to_s}"
                  kind="#{self.kind}"
                  status="#{self.status}"
                })
  end

  def cimlog_metrics
    self.metrics.each do |category,data|

      msg = [ self.prefix_msg('metrics'), 'category="%s"' % category ]

      if category == 'time'
        msg += [ 'units="seconds"' ]
      end

      msg += data.values.map do |val|
        metric = val[1].downcase.tr(' ', '_')
        value = val[2].to_s

        if metric != 'total'
          metric = 'rtime_' + metric
        end

        '%s="%s"' % [metric, value]
      end

      Puppet.notice(msg)
    end
  end

  def cimlog_logs
    self.logs.each do |log|
      Puppet.notice(self.prefix_msg('logs'), %W{
                    source="#{log.source}"
                    level="#{log.level}"
                    msg="#{log.to_s}"
                  })
    end
  end

  def cimlog_resource_statuses
    resources = self.resource_statuses.values.select { |r| r.change_count > 0 }

    resources.each do |res|

      Puppet.notice(self.prefix_msg('resource'), %W{
                      resource="#{res.resource}"
                      resource_title="#{res.title}"
                      resource_type="#{res.resource_type}"
                      resource_changes="#{res.events.length}"
                    })

      res.events.each do |event|
        Puppet.notice(self.prefix_msg('change'), %W{
                      resource="#{res.resource}"
                      change_type="#{event.name}"
                      change_property="#{event.property}"
                      change_status="#{event.status}"
                      change_previous="#{event.previous_value}"
                      change_desired="#{event.desired_value}"
                    })
                      
      end
    end
  end

end

