require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'sinatra/content_for'
require 'redcarpet'

root = File.expand_path("..", __FILE__)

configure do
  enable :sessions
  set :session_secret, 'secret-key'
end

helpers do
#   def render_markdown(text)
#     markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
#     markdown.render(text)
#   end
end

get '/' do
  @files = Dir.glob(root + '/data/*').map {|fn| File.basename(fn) }.sort

  erb :index
end

# get "/:filename" do
#   file_path = root + "/data/" + params[:filename]
# 
#   if File.file?(file_path) && File.extname(file_path) == '.md'
#     markdown.render(File.read(file_path))
#   elsif File.file?(file_path)
#     headers["Content-Type"] = "text/plain"
#     File.read(file_path)
#   else
#     session[:message] = "#{params[:filename]} does not exist."
#     redirect "/"
#   end
#end
