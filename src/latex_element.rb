class LatexElement
  attr_reader :latex_source

  def initialize(node, page)
    @node = node
    @page = page
    set_footnotes
  end

  def to_s
    node_latex = case @node.name
    when "p"
      make_latex_paragraph
    when "h2"
      make_latex_section
    when "h3"
      make_latex_subsection
    else
      raise Error "Didn't get a node type I understand"
    end
    node_latex.delete "\n"
  end

  def set_footnotes
    @footnotes = Hash[@page.css('.information').to_a.map do |footnote|
      split = footnote.text.delete("\n").split(".")
      footnote_text = split.slice(1..-1).join(".").strip
      footnote_text << "." unless footnote_text.end_with? "."
      [split[0], footnote_text]
    end]
  end

  def make_latex_paragraph
    if @node.children.map { |node| node.name }.include? "sup"
      process_paragraph_with_footnote
    else
      @node.text
    end
  end

  def process_paragraph_with_footnote
    @node.children.map { node.name == "sup" ? get_footnote(node) : node.text }
  end

  def get_footnote(node)
    "\footnote{#{@footnotes[node.children.first.attributes["href"].value.delete "#"]}}"
  end

  def make_latex_section
    "\section{#{@node.text}}"
  end

  def make_latex_subsection
    "\subsection{#{@node.text}}"
  end
end
