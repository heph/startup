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

        @supports = { :restart => false, :reload => false, :status => false }
        @allowed_actions.push(:create, :delete, :enable, :disable, :start, :stop, :restart, :reload)
      end

      def apparmor_load(arg=nil)          set_or_return(:apparmor_load,   arg, :kind_of => [ String ]) end
      def apparmor_switch(arg=nil)        set_or_return(:apparmor_switch, arg, :kind_of => [ String ]) end
      def author(arg="Managed by Chef")   set_or_return(:author,          arg, :kind_of => [ String ]) end
      def chdir(arg=nil)                  set_or_return(:chdir,           arg, :kind_of => [ String ]) end
      def chroot(arg=nil)                 set_or_return(:chroot,          arg, :kind_of => [ String ]) end
      def console(arg=nil)                set_or_return(:console,         arg, :kind_of => [ String ]) end
      def description(arg=nil)            set_or_return(:description,     arg, :kind_of => [ String ]) end
      def emits(arg=nil)                  set_or_return(:emits,           arg, :kind_of => [ String ]) end
      def env(arg=nil)                    set_or_return(:env,             arg, :kind_of => [ Object ]) end
      def exec(arg=nil)                   set_or_return(:exec,            arg, :kind_of => [ String ]) end
      def expect(arg=nil)                 set_or_return(:expect,          arg, :kind_of => [ String ]) end
      def export(arg=nil)                 set_or_return(:export,          arg, :kind_of => [ Array ]) end
      def kill_signal(arg=nil)            set_or_return(:kill_signal,     arg, :kind_of => [ String ]) end
      def kill_timeout(arg=nil)           set_or_return(:kill_timeout,    arg, :kind_of => [ Fixnum, Integer ]) end
      def limit(arg=nil)                  set_or_return(:limit,           arg, :kind_of => [ String ]) end
      def manual(arg=false)               set_or_return(:manual,          arg, :kind_of => [ TrueClass, FalseClass ]) end
      def nice(arg=nil)                   set_or_return(:nice,            arg, :kind_of => [ Fixnum, Integer ]) end
      def normal_exit(arg=nil)            set_or_return(:normal_exit,     arg, :kind_of => [ Array ]) end
      def oom_score(arg=nil)              set_or_return(:oom_score,       arg, :kind_of => [ Fixnum, Integer ]) end
      def reload_signal(arg=nil)          set_or_return(:reload_signal,   arg, :kind_of => [ String ]) end
      def respawn(arg=false)              set_or_return(:respawn,         arg, :kind_of => [ TrueClass, FalseClass ]) end
      def respawn_limit(arg=nil)          set_or_return(:respawn_limit,   arg, :kind_of => [ String ]) end
      def script(arg=nil)                 set_or_return(:script,          arg, :kind_of => [ Array ]) end
      def setgid(arg=nil)                 set_or_return(:setgid,          arg, :kind_of => [ String ]) end
      def setuid(arg=nil)                 set_or_return(:setuid,          arg, :kind_of => [ String ]) end
      def start_on(arg="runlevel [2345]") set_or_return(:start_on,        arg, :kind_of => [ String ]) end
      def stop_on(arg="runlevel [06]")    set_or_return(:stop_on,         arg, :kind_of => [ String ]) end
      def task(arg=false)                 set_or_return(:task,            arg, :kind_of => [ TrueClass, FalseClass ]) end
      def umask(arg=nil)                  set_or_return(:umask,           arg, :kind_of => [ String ]) end
      def usage(arg=nil)                  set_or_return(:usage,           arg, :kind_of => [ String ]) end
      def version(arg=nil)                set_or_return(:version,         arg, :kind_of => [ String ]) end
    end
  end
end

