require 'sinatra'
require './plugman/src/PlugMan.rb'

$site_title = 'Hay'

PlugMan.define :main do
  author 'mzdravkov'
  version  '0.0.1'
  extends({root: [:root]})
  requires []
  extension_points [:site_title, :plugin_routes]
  params()

  def get_site_title
    site_title = $site_title
    PlugMan.extensions(:main, :site_title).each do |plugin|
      site_title = plugin.filter_site_title(site_title)
    end
    site_title
  end

	def all_plugin_routes
		plugin_routes = []
    PlugMan.extensions(:main, :plugin_routes).each do |plugin|
      plugin_routes << plugin.plugin_routes
		end
		plugin_routes
	end
end

def load_plugin_routes
	PlugMan.registered_plugins[:main].all_plugin_routes.each do |plugin_routes|
		plugin_routes.each do |method, route, block|
			settings.send method, route, &block
		end
	end
end

PlugMan.load_plugins './plugins'
PlugMan.start_all_plugins

set :views, settings.root

get '/' do
  PlugMan.registered_plugins[:main].get_site_title
end

get '/reload_plugins' do
	PlugMan.stop_all_plugins
	PlugMan.registered_plugins.delete_if { |k, v| k != :root and k != :main }
	PlugMan.load_plugins './plugins'
	PlugMan.start_all_plugins
	load_plugin_routes
	'ready'
end

load_plugin_routes
