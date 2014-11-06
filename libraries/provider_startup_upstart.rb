class Chef
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
            t.source('upstart.erb')
            t.cookbook('startup')
            t.variables(upstart_spec)
            t.run_action(:create)
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
