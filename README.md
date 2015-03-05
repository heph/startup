Startup Cookbook
================

Extends the Chef 'service' resource to create init template and service
definition with a single resource. This eliminates certain 'chicken and egg'
problems with Chef service definitions.

Installation
------------

In your cookbook's `metadata.rb`, add the line:

```ruby
depends 'startup'
```

In your cookbook, declare your `service` resources with
`provider Chef::Provider::Startup::Upstart` (see [Examples](#examples) below)

Requirements
------------

**Platforms**

```ruby
supports 'ubuntu' # Tested on 14.04 (trusty)
```

Usage
-----

### Actions

Extends the default Chef [service actions](https://docs.chef.io/resource_service.html#actions)
as follows:

#### `:create`

Creates an upstart config to invoke the contents of `exec` or `script`

#### `:delete`

Calls action `:stop` and deletes an upstart config if defined.

### Upstart Parameters

The `Upstart` provider maps the following resource parameters to
[Upstart Configuration Stanzas](http://upstart.ubuntu.com/cookbook/#configuration).

#### Documentation

| Option | Default | Example |
|-------:|---------|---------|
| [`author`](http://upstart.ubuntu.com/cookbook/#author) | `Managed by Chef` | `John Q. Hacker` |
| [`description`](http://upstart.ubuntu.com/cookbook/#description) | `nil` | `Runs a Service` |
| [`emits`](http://upstart.ubuntu.com/cookbook/#emits) | `nil` | `hello-world` |
| [`version`](http://upstart.ubuntu.com/cookbook/#version) | `nil` | `1.0.2a-beta4` |
| [`usage`](http://upstart.ubuntu.com/cookbook/#usage) | `nil` | `BIND_IP - environment variable` |

#### Event Definition

| Option | Default | Example |
|-------:|---------|---------|
| [`manual`](http://upstart.ubuntu.com/cookbook/#manual) | `false` | Boolean: `true` or `false` |
| [`start_on`](http://upstart.ubuntu.com/cookbook/#start-on) | `runlevel [2345]` | `filesystem`, `rc`, `hello-world` |
| [`stop_on`](http://upstart.ubuntu.com/cookbook/#stop-on) | `runlevel [06]` | `stopping memcached`, `hello-world` |

#### Services, Tasks, and Respawning

| Option | Default | Example |
|-------:|---------|---------|
| [`normal_exit`](http://upstart.ubuntu.com/cookbook/#normal-exit) | `nil` | Array: `[0, 13, 'SIGUSR1', 'SIGWINCH']` |
| [`respawn`](http://upstart.ubuntu.com/cookbook/#respawn) | `false` | Boolean: `true` or `false` |
| [`respawn_limit`](http://upstart.ubuntu.com/cookbook/#respawn-limit) | `nil` | Array: `[COUNT, INTERVAL]` |
| [`task`](http://upstart.ubuntu.com/cookbook/#task) | `nil` | Boolean: `true` or `false` |

#### Process Environment

| Option | Default | Example |
|-------:|---------|---------|
| [`apparmor_load`](http://upstart.ubuntu.com/cookbook/#apparmor-load) | `nil` | `/etc/apparmor.d/usr.sbin.cupsd` |
| [`apparmor_switch`](http://upstart.ubuntu.com/cookbook/#apparmor-switch) | `nil` | `/usr/bin/cupsd` |
| [`console`](http://upstart.ubuntu.com/cookbook/#console-none) | `nil` | `none`, `output`, or `owner` |
| [`chdir`](http://upstart.ubuntu.com/cookbook/#chdir) | `nil` | `/var/mydaemon` |
| [`chroot`](http://upstart.ubuntu.com/cookbook/#chroot) | `nil` | `/srv/chroots/oneiric` |
| [`limit`](http://upstart.ubuntu.com/cookbook/#limit) | `nil` | `nofile unlimited unlimited` |
| [`nice`](http://upstart.ubuntu.com/cookbook/#nice) | `nil` | `19` |
| [`oom_score`](http://upstart.ubuntu.com/cookbook/#oom-score) | `nil` | `1000` |
| [`setgid`](http://upstart.ubuntu.com/cookbook/#setgid) | `nil` | `www-data` |
| [`setuid`](http://upstart.ubuntu.com/cookbook/#setuid) | `nil` | `www-data` |
| [`umask`](http://upstart.ubuntu.com/cookbook/#umask) | `nil` | `0002` |

#### Job Environment

| Option | Default | Example |
|-------:|---------|---------|
| [`env`](http://upstart.ubuntu.com/cookbook/#env) | `nil` | Object: `{:BIND_ADDR => "0.0.0.0"}` |
| [`export`](http://upstart.ubuntu.com/cookbook/#export) | `nil` | Array: `[:BIND_ADDR]` |

#### Process Control

| Option | Default | Example |
|-------:|---------|---------|
| [`expect`](http://upstart.ubuntu.com/cookbook/#expect-fork) | `nil` | `fork`, `daemon`, or `stop` |
| [`kill_signal`](http://upstart.ubuntu.com/cookbook/#kill-signal) | `nil` | `SIGINT` |
| [`kill_timeout`](http://upstart.ubuntu.com/cookbook/#kill-timeout) | `nil` | `20` |
| [`reload_signal`](http://upstart.ubuntu.com/cookbook/#reload-signal) | `nil` | `SIGUSR1` |

#### Process Definition

| Option | Default | Example |
|-------:|---------|---------|
| [`exec`](http://upstart.ubuntu.com/cookbook/#exec) | `nil` | `node application.js PORT=$(( 8080 + $INSTANCE ))` |
| [`script`](http://upstart.ubuntu.com/cookbook/#script) | `nil` | Array: `['touch /tmp/restarted', 'node application.js PORT=$(( 8080 + $INSTANCE ))']` |


### All Options (with defaults)

```ruby
service 'nodeapp' do
  provider        Chef::Provider::Startup::Upstart
  apparmor_load   nil
  apparmor_switch nil
  author          'Managed by Chef'
  chdir           nil
  chroot          nil
  console         nil
  description     nil
  emits           nil
  env             nil
  exec            nil
  expect          nil
  export          nil
  kill_signal     nil
  kill_timeout    nil
  limit           nil
  manual          nil
  nice            nil
  normal_exit     nil
  oom_score       nil
  reload_signal   nil
  respawn         nil
  respawn_limit   nil
  script          nil
  setgid          nil
  setuid          nil
  start_on        'runlevel [2345]'
  stop_on         'runlevel [06]'
  task            false
  umask           nil
  usage           nil
  version         nil
  workers         nil
  action          :create
end
```

## Examples

### Create a Service

Invoking this provider with `:create` builds an init script named
 `/etc/init/#{new_resource.name}.conf`. All supported upstart parameters are
copied into that init script verbatim.

The Chef config of:
```ruby
# Create the service
service 'nodeapp' do
  provider Chef::Provider::Startup::Upstart
  chdir   '/opt/nodeapp'
  env     { :PORT => 8080,
            :BIND_ADDR => "127.0.0.1" }
  exec    'node application.js'
  respawn true
  action  :create
end
```

creates an Upstart config named `/etc/init/nodeapp.conf` with the contents:
```upstart
##
# Documentation
author "Managed by Chef"

##
# Event Definition
start on runlevel [2345]
stop on runlevel [06]

##
# Services, Tasks, and Respawning
respawn

##
# Process Environment
chdir /opt/nodeapp

##
# Job Environment
env PORT=8080
env BIND_ADDR="127.0.0.1"

##
# Process Control

##
# Process Definition
exec node application.js
```

### Managing Startup Services

Services created with this provider are managable just like other chef
`service` resources. For example, `subscribes` and `notifies` behave as you
would expect:

```ruby
# Add a config file, restart service[nodeapp]
file '/etc/nodeapp/mongo.json' do
  contents JSON.pretty_generate({:mongos => '127.0.0.1'})
  notifies :restart, 'service[nodeapp]', :immediately
end
```

However, note that if the `service` resource itself changes, the service will
be restarted automatically. This is to ensure compliance with 12factor
environment-based config administration.

You can administer the service on the server with standard upstart commands:
```bash
$ service nodeapp status
start/running
$ service nodeapp stop
$ service nodeapp start
```
