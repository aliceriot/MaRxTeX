class LatexDocument
  def initialize(elements, title, authors)
    @elements = elements
    @title = title
    @authors = authors
  end

  def to_s
    <<LATEX
\documentclass{article}
\begin{document}

\title{#{@title}}
\author{#{@authors}}

#{ @elements.each { |latex_element| latex_element.to_s } }

\end{document}
LATEX
  end
end
