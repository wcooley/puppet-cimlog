puppet-cimlog
=============

Description
-----------

CIM Log is a Puppet report processor that formats report data as field=value
pairs and logs over syslog, so Splunk can automatically extract fields. This is
being designed for use with my Puppet Pulse App for Splunk, so its output will
change to meet the needs of that.

Installation
------------

To use, check out or download into your Puppet modules directory and in your
`puppet.conf`, you need the following:

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

Author
------
Wil Cooley <wcooley<at>nakedape.cc>

License
-------
    Author:: Wil Cooley (wcooley<at>nakedape.cc)
    Copyright:: Copyright (c) 2012 Wil Cooley
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
