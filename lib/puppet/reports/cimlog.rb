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
                      resource_changes="#{res.events.length}"
                    })

      res.events.each do |event|
        Puppet.notice(@prefix_msg, %W{
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

