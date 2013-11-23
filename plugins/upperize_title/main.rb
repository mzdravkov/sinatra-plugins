PlugMan.define :upperize_title do
  author 'mzdravkov'
  version  '0.0.1'
  extends({main: [:site_title, :plugin_routes]})
  requires []
  extension_points []
  params()
	VIEWS_PATH = 'plugins/upperize_title/views'

  def filter_site_title title
    title.upcase
  end

	def plugin_routes
		[['get', '/test', Proc.new {erb :"#{VIEWS_PATH}/test"}]]
	end

	def stop
		#remove plugin routes
	end
end
