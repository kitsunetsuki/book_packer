
# each page is a book object. initialize by scraping with ALL THE REGEX

    # Title
    # Author
    # Price
    # Shipping Weight
    # ISBN-10



class Book
  attr_reader :title, :author, :publisher, :isbn10, :dimensions, :weight
  def initialize(num)
    @num =num
    #converts the file to a utf-8 string
    @contents =IO.read("data/book#{num}.html").force_encoding('iso-8859-1').encode('utf-8')
    @publisher = get_publisher
    @isbn10 = get_isbn10
    @weight = get_weight
    @dimensions = get_dimensions
    get_title_author
  end

  def hash
    {"Title"=> @title, "Author(s)" => @author, "publisher" => @publisher, "isbn10" => @isbn10, "dimensions" => @dimensions, "weight" => @weight}
  end


private
  def get_title_author
    #look after a title tag and before a string of 13 numbers
    @data= @contents[/(?<=(<title>)).*(?=(\d{13}))/]

    #get rid of the extra space
    @data.chop!.chop!

    @author = @data.slice!((@data.rindex(/:/)+2)..@data.length)
    @title = @data.chop!.chop!

   
  end

  def get_isbn10
    @contents[/(?<=<b>ISBN-10:<\/b> ).*(?=<)/]
  end

  #currently returns weight without checking if it is in pounds or kg. possibly add check for units of measurement?
  def get_weight
   (@contents[/(?<=(Shipping Weight:<\/b>)\s).*(?=\s\()/])[/\d*.\d*/]

  end

  def get_dimensions
    @contents[/.*inches/]
  end

  def get_publisher
    @publisher = @contents[/(?<=(Publisher:<\/b> )).*(?= \()/].split(";")[0]
      #check and see if the listed author is actually the publisher, if so, set author to an empty string
    if @publisher == self.author
      self.author = ''
    end
    @publisher   
  end

  #this is non-optimal, however, it works for this set of pages. would need to test on a larger set
  #also potentially do a check for currency, and convert to appropriate currency
  def get_price
    @price = @contents[/(?<=("priceLarge">)).*?(?=<)/]
    if @price == nil
      @price =@contents[/(?<=("rentPrice">)).*?(?=<)/]
    end
    @price
  end


end