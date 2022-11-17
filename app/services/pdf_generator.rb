class PdfGenerator  
  include Prawn::View

  def initialize
    content
  end

  def content
    text "Hello World!"
  end
end