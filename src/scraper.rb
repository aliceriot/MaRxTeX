require 'mechanize'

class Scraper
  attr_reader :body

  def initialize(url)
    @url = url
    @agent = Mechanize.new
    @body = @agent.get(@url).search('body')
    check_for_blockquote
    delete_useless_children_from_body
  end

  def delete_useless_children_from_body
    @body.keep_if { |node| ["p", "h3", "h2"].include? node.name }
  end

  def check_for_blockquote
    if @body.children.map { |node| node.name }.include? "blockquote"
      @body = @body.search('blockquote').children[1].children.to_a
    else
      @body = @body.children.to_a
    end
  end
end
