require 'rubygems'
require 'bundler'

Bundler.require

class UrbanAPI::Definition
  def self.extract_from(node)
    if node
      html = node.inner_html
      html.gsub!(/\n|\r/, '')
      html.gsub!(/<br>/i, "\n")
      Nokogiri::HTML.fragment(html).inner_text
    end
  end
end

def noop(txt)
  txt
end

REPLACEMENT = '\1&#$@!\2'.freeze
REPLACEMENT_CHARS = %w(& # $ @ !)
WORDS = %w(tit fuck poop cunt shit motherfu dick sex dick pussy anal ass cum jizz hand\ job rim\ job blow\ job jerk feces faeces ejacul jack porn stink\ nuggets)
def clean(txt)
  WORDS.each do |w|
    txt.gsub!(%r{(^|\s)#{w}[^\s]*(\s|$)}, replacement)
  end
  txt
end

def replacement
  arr = Array.new(4) { REPLACEMENT_CHARS[rand(5)] }
  arr.unshift '\1'
  arr << '\2'
  arr.join
end

get '/' do
  response.headers['Cache-Control'] = 'public, max-age=300'
  if term = params[:term]
    scrubber = params[:clean] ? :clean : :noop
    UrbanAPI.define(term, :page => params[:page]).map do |defn|
      {
        :definition => send(scrubber, defn.definition),
        :example    => send(scrubber, defn.example)
      }
    end.to_json
  else
    {:help => "?term=WORD&page=NUM"}.to_json
  end
end
