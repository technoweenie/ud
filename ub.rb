require 'rubygems'
require 'bundler'

Bundler.require

get '/' do
  response.headers['Cache-Control'] = 'public, max-age=300'
  if term = params[:term]
    UrbanAPI.define(term, :page => params[:page]).map do |defn|
      {:definition => defn.definition, :example => defn.example}
    end.to_json
  else
    {:help => "?term=WORD&page=NUM"}.to_json
  end
end
