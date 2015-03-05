class Chef
  class Resource
    class Service < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :service
        @service_name = name
        @enabled = nil
        @running = nil
        @parameters = nil
        @pattern = service_name
        @start_command = nil
        @stop_command = nil
        @status_command = nil
        @restart_command = nil
        @reload_command = nil
        @init_command = nil
        @priority = nil
        @timeout = nil
        @action = "nothing"

        @author = "Managed by Chef"
        @start_on = "runlevel [2345]"
        @stop_on = "runlevel [06]"
        @task = false
        @respawn = false
        @manual = false

        @supports = { :restart => false, :reload => false, :status => false }
        @allowed_actions.push(:create, :delete, :enable, :disable, :start, :stop, :restart, :reload)
      end

      def apparmor_load(arg=nil)    set_or_return(:apparmor_load,   arg, :kind_of => [ String ]) end
      def apparmor_switch(arg=nil)  set_or_return(:apparmor_switch, arg, :kind_of => [ String ]) end
      def author(arg=nil)           set_or_return(:author,          arg, :kind_of => [ String ]) end
      def chdir(arg=nil)            set_or_return(:chdir,           arg, :kind_of => [ String ]) end
      def chroot(arg=nil)           set_or_return(:chroot,          arg, :kind_of => [ String ]) end
      def console(arg=nil)          set_or_return(:console,         arg, :kind_of => [ String ]) end
      def description(arg=nil)      set_or_return(:description,     arg, :kind_of => [ String ]) end
      def emits(arg=nil)            set_or_return(:emits,           arg, :kind_of => [ String ]) end
      def env(arg=nil)              set_or_return(:env,             arg, :kind_of => [ Hash ]) end
      def exec(arg=nil)             set_or_return(:exec,            arg, :kind_of => [ String ]) end
      def expect(arg=nil)           set_or_return(:expect,          arg, :kind_of => [ String ]) end
      def export(arg=nil)           set_or_return(:export,          arg, :kind_of => [ Array ]) end
      def kill_signal(arg=nil)      set_or_return(:kill_signal,     arg, :kind_of => [ String ]) end
      def kill_timeout(arg=nil)     set_or_return(:kill_timeout,    arg, :kind_of => [ Fixnum, Integer ]) end
      def limit(arg=nil)            set_or_return(:limit,           arg, :kind_of => [ String ]) end
      def manual(arg=nil)           set_or_return(:manual,          arg, :kind_of => [ TrueClass, FalseClass ]) end
      def nice(arg=nil)             set_or_return(:nice,            arg, :kind_of => [ Fixnum, Integer ]) end
      def normal_exit(arg=nil)      set_or_return(:normal_exit,     arg, :kind_of => [ Array ]) end
      def oom_score(arg=nil)        set_or_return(:oom_score,       arg, :kind_of => [ Fixnum, Integer ]) end
      def reload_signal(arg=nil)    set_or_return(:reload_signal,   arg, :kind_of => [ String ]) end
      def respawn(arg=nil)          set_or_return(:respawn,         arg, :kind_of => [ TrueClass, FalseClass ]) end
      def respawn_limit(arg=nil)    set_or_return(:respawn_limit,   arg, :kind_of => [ String ]) end
      def script(arg=nil)           set_or_return(:script,          arg, :kind_of => [ Array ]) end
      def setgid(arg=nil)           set_or_return(:setgid,          arg, :kind_of => [ String ]) end
      def setuid(arg=nil)           set_or_return(:setuid,          arg, :kind_of => [ String ]) end
      def start_on(arg=nil)         set_or_return(:start_on,        arg, :kind_of => [ String ]) end
      def stop_on(arg=nil)          set_or_return(:stop_on,         arg, :kind_of => [ String ]) end
      def task(arg=nil)             set_or_return(:task,            arg, :kind_of => [ TrueClass, FalseClass ]) end
      def umask(arg=nil)            set_or_return(:umask,           arg, :kind_of => [ String ]) end
      def usage(arg=nil)            set_or_return(:usage,           arg, :kind_of => [ String ]) end
      def version(arg=nil)          set_or_return(:version,         arg, :kind_of => [ String ]) end
    end
  end

  class Provider
    class Startup
      class Upstart < Chef::Provider::Service::Upstart
        def upstart_spec
          {
            :author => @new_resource.author.inspect,
            :description => @new_resource.description,
            :emits => @new_resource.emits,
            :version => @new_resource.version,
            :usage => @new_resource.usage,
            :manual => @new_resource.manual,
            :start_on => @new_resource.start_on,
            :stop_on => @new_resource.stop_on,
            :normal_exit => @new_resource.normal_exit,
            :respawn => @new_resource.respawn,
            :respawn_limit => @new_resource.respawn_limit,
            :task => @new_resource.task,
            :apparmor_load => @new_resource.apparmor_load,
            :apparmor_switch => @new_resource.apparmor_switch,
            :console => @new_resource.console,
            :chdir => @new_resource.chdir,
            :chroot => @new_resource.chroot,
            :limit => @new_resource.limit,
            :nice => @new_resource.nice,
            :oom_score => @new_resource.oom_score,
            :setgid => @new_resource.setgid,
            :setuid => @new_resource.setuid,
            :umask => @new_resource.umask,
            :env => @new_resource.env,
            :export => @new_resource.export,
            :expect => @new_resource.expect,
            :kill_signal => @new_resource.kill_signal,
            :kill_timeout => @new_resource.kill_timeout,
            :reload_signal => @new_resource.reload_signal,
            :exec => @new_resource.exec,
            :script => @new_resource.script
          }
        end

        def action_create
          converge_by("Creating upstart config: #{@upstart_job_dir}/#{@new_resource.service_name}#{@upstart_conf_suffix}") do
            t = Chef::Resource::Template.new("#{@upstart_job_dir}/#{@new_resource.service_name}#{@upstart_conf_suffix}", run_context)
            t.helpers(Extensions::Templates)
            t.source('format_upstart.conf.erb')
            t.cookbook('startup')
            t.variables(upstart_spec)
            t.run_action(:create)

            if t.updated_by_last_action?
              action_restart
            end
          end
        end

        def action_delete
          action_stop
          if ::File.exists?("#{@upstart_job_dir}/#{@new_resource.service_name}#{@upstart_conf_suffix}")
            converge_by("Deleting upstart config: #{@upstart_job_dir}/#{@new_resource.service_name}#{@upstart_conf_suffix}") do
              ::FileUtils.rm("#{@upstart_job_dir}/#{@new_resource.service_name}#{@upstart_conf_suffix}")
            end
          end
        end
      end
    end
  end
end
