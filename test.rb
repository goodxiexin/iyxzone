require 'net/http'
require 'rexml/document'

def get_text element
  if element.is_a? REXML::Text
    element.to_s
  elsif element.is_a?(REXML::Element) or element.is_a?(REXML::Document)
    text = ''
    element.each do |e|
      text << get_text(e)
    end
    text
  end
end

d = REXML::Document.new File.new('test.xml')

puts get_text(d)
