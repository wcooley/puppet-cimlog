puppet-cimlog
=============

Description
-----------

CIM Log is a Puppet report processor that formats report data as field=value
pairs and logs over syslog, so Splunk can automatically extract fields. This is
being designed for use with my [Puppet
Pulse](https://github.com/wcooley/splunk-puppet) App for Splunk, so its output
will change to meet the needs of that.

Installation
------------

To use, check out or download into your Puppet modules directory or install using the Puppet module tool. `puppet.conf` needs the following:

* pluginsync enabled
* agent configured to send reports
* master configured with `cimlog` as a report processor

My `puppet.conf` looks something like this:

    [main]
    pluginsync = true

    [agent]
    report = true

    [master]
    reports = cimlog

Output
------

Some sample anonymized output:

    masterofpuppets puppet-master[17621]: [cimlog] dest=puppetclient event_id=1370889076 ver="1370862162" kind="apply" status="changed"
    masterofpuppets puppet-master[17621]: [cimlog/metrics] dest=puppetclient event_id=1370889076 category="changes" total="6"
    masterofpuppets puppet-master[17621]: [cimlog/metrics] dest=puppetclient event_id=1370889076 category="time" units="seconds" rtime_augeas="7.186" rtime_config_retrieval="5.346" rtime_cron="0.003" rtime_exec="10.949" rtime_file="4.121" rtime_file_line="0.001" rtime_filebucket="0.001" rtime_group="0.025" rtime_host="0.002" rtime_package="0.861" rtime_service="6.153" total="35.042" rtime_user="0.042" rtime_vcsrepo="0.330" rtime_yumrepo="0.024"
    masterofpuppets puppet-master[17621]: [cimlog/metrics] dest=puppetclient event_id=1370889076 category="resources" changed="6" failed="0" failed_to_restart="0" out_of_sync="6" restarted="0" scheduled="0" skipped="7" total="764"
    masterofpuppets puppet-master[17621]: [cimlog/metrics] dest=puppetclient event_id=1370889076 category="events" failure="0" success="6" total="6"
    masterofpuppets puppet-master[17621]: [cimlog/logs] dest=puppetclient event_id=1370889076 source="/Stage[main]/Host_puppetclient/Exec[update_generated_foo]/returns" level="notice" msg="executed successfully"
    masterofpuppets puppet-master[17621]: [cimlog/logs] dest=puppetclient event_id=1370889076 source="/Stage[main]/Puppet::Master::Hacks/Cfengine_conf[etc/foo.conf]/File[/etc/puppet/modules/foo/files/foo.conf]/content" level="notice" msg="content changed '{md5}0c96ce187f3184d4bf3d9ade7f50a7f1' to '{md5}baaa5134a6f497348a3236416b24105a'"
    masterofpuppets puppet-master[17621]: [cimlog/logs] dest=puppetclient event_id=1370889076 source="Puppet" level="notice" msg="Finished catalog run in 43.47 seconds"
    masterofpuppets puppet-master[17621]: [cimlog/resource] dest=puppetclient event_id=1370889076 resource="File[/etc/puppet/modules/foo/files/foo.conf]" resource_title="/etc/puppet/modules/foo/files/foo.conf" resource_type="File" resource_changes="1"
    masterofpuppets puppet-master[17621]: [cimlog/change] dest=puppetclient event_id=1370889076 resource="File[/etc/puppet/modules/foo/files/foo.conf]" change_type="content_changed" change_property="content" change_status="success" change_previous="{md5}0c96ce187f3184d4bf3d9ade7f50a7f1" change_desired="{md5}baaa5134a6f497348a3236416b24105a"
    masterofpuppets puppet-master[17621]: [cimlog/resource] dest=puppetclient event_id=1370889076 resource="Exec[update_generated_foo]" resource_title="update_generated_foo" resource_type="Exec" resource_changes="1"
    masterofpuppets puppet-master[17621]: [cimlog/change] dest=puppetclient event_id=1370889076 resource="Exec[update_generated_foo]" change_type="executed_command" change_property="returns" change_status="success" change_previous="notrun" change_desired="0"

Author
------
Wil Cooley <wcooley(at)nakedape.cc>

License
-------
    Author:: Wil Cooley (wcooley(at)nakedape.cc)
    Copyright:: Copyright (c) 2013 Wil Cooley
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
