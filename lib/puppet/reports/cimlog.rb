require 'puppet'

Puppet::Reports.register_report(:cimlog) do
  desc "Send metrics to log, structured to make it easy with Splunk."

  def process
    cimlog_base
    cimlog_metrics
#    cimlog_logs
    cimlog_resource_statuses
  end

  def cimlog_base
    @node = self.host.split('.', 2)[0]
    @run_id = Time.now.to_i.to_s if not @run_id

    @prefix_msg = "[cimlog] dest=#{@node} event_id=#{@run_id}"
    Puppet.notice(@prefix_msg, %W{
                  ver="#{self.configuration_version.to_s}"
                  kind="#{self.kind}"
                  status="#{self.status}"
                })
  end

  def cimlog_metrics
    self.metrics.each do |category,data|

      msg = Array.new
      msg += [ @prefix_msg ]
      msg += [ 'category="%s"' % category ]

      if category == 'time'
        msg += [ 'units="seconds"' ]
      end

      msg += data.values.map do |val|
        metric = val[1].downcase.tr(' ', '_')
        value = val[2].to_s

        '%s="%s"' % [metric, value]
      end

      Puppet.notice(msg)
    end
  end

  def cimlog_logs
    self.logs.each do |log|
      Puppet.notice(@prefix_msg, %W{
                    source="#{log.source}"
                    level="#{log.level}"
                    msg="#{log.to_s}"
                  })
    end
  end

  def cimlog_resource_statuses
    resources = self.resource_statuses.values.select { |r| r.change_count > 0 }

    resources.each do |res|

      Puppet.notice(@prefix_msg, %W{
                      resource="#{res.resource}"
                      resource_title="#{res.title}"
                      resource_type="#{res.resource_type}"
                      resource_events="#{res.events.length}"
                    })

      res.events.each do |event|
        Puppet.notice(@prefix_msg, %W{
                      resource="#{res.resource}"
                      event_name="#{event.name}"
                      event_property="#{event.property}"
                      event_status="#{event.status}"
                      desired_value="#{event.desired_value}"
                      previous_value="#{event.previous_value}"
                    })
                      
      end
    end
  end

end

