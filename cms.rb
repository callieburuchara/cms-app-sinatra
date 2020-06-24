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

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

def load_file_content(path)
  content = File.read(path)
  case File.extname(path)
  when '.txt'
    headers['Content-Type'] = 'text/plain'
    content
  when '.md'
    render_markdown(content)
  end
end

# View the index/homepage
get '/' do
  @files = Dir.glob(root + '/data/*').map {|fn| File.basename(fn) }.sort
  erb :index
end

# View an individual file
get "/:filename" do
  file_path = root + "/data/" + params[:filename]
    
  if File.exist?(file_path)
    @content = load_file_content(file_path)
  else
    session[:message] = "#{params[:filename]} does not exist."
    redirect "/"
  end

  erb :individual_file
end

get "/:filename/edit" do
  file_path = root + "/data/" + params[:filename]
  @file_name = params[:filename]
  @content = File.read(file_path)

  erb :edit_file
end

post '/:filename' do
  file_path = root + "/data/" + params[:filename]
  
  File.write(file_path, params[:content]) 

  session[:message] = "#{params[:filename]} has been updated."
  redirect '/'
end
