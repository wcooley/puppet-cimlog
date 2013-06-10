* Write rspec tests. How the hell do I write rspec tests for reports?
* I am uncertain about `dest` as the name of the remote client. It *seems* like the best fit based on [Splunk's documentation](http://docs.splunk.com/Documentation/Splunk/latest/Knowledge/UnderstandandusetheCommonInformationModel) but feels wrong.
* `event_id` could be shorter yet more certainly unique. Currently it is the timestamp at a resolution of 1 second, which is likely to duplicate even with a just a couple hundred clients (the `event_id` and `dest` should create unique transactions, however). I could rebase to a more recent epoch by subtracting a good deal of time and add higher precision timestamps, for example, or just use a completely random string. I could also possibly use [Crockford's base32 encoding](http://www.crockford.com/wrmg/base32.html). (UUIDs are too long for this; my Splunk license would never forgive me.)
* Decode Puppet's resource specifications and log as key=value. I have regexes in Splunk to decode this but part of my motivation for writing this was to simplify the Splunk configuration. Unfortunately, Ruby 1.8's regular experssions lack [named capture groups](http://www.regular-expressions.info/named.html), which make implementing more tedious (and make keeping the decoding here and in Splunk more tedious).
* Maybe use [James Turnbull's puppet-splunk](http://forge.puppetlabs.com/jamtur01/splunk) report instead?