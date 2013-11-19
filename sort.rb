require 'json'

class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end
end

class Boxes
  attr_reader :books, :large_books

  def initialize 
    @num_files =Dir["./data/**/*"].length
    @books = []
    get_books
    @boxes=[]
    @boxcount = 1
    @large_books = []
    @small_books = []
    @boxed_books = []
    @max_weight = 10
  end

  def get_books

    for i in (1..@num_files) do
      book = Book.new(i)
      @books << book.hash
    end

    @books.sort_by!{|book| book["weight"]}.reverse!
  end

  #this sorts the books into either their own boxes, an array of large books, and an array of small books

  def sort_books
    @books.each do |book|
      @space = ((@max_weight) - (book["weight"])).round_to(2)
      @most_space = @large_books.last 
      if @most_space == nil 
        @most_space = 0
      else
        @most_space = (@max_weight - @most_space["weight"]).round_to(2)
      end
      #first, determine if there are any books that are too heavy to share a box, and put them in their own box
      if @space < @books.last["weight"]
        puts "#{book["Title"]} gets its own box! because the remainder is weighs #{@space}, and the smallest book weighs #{@books.last['weight']}"
        @boxes << {"box#{@boxcount}" => book}
        @boxcount += 1
        @boxed_books << book

        #if the book couldn't go into a box with the box with the most space in the large books array, it also joins the large books array
      elsif (book["weight"] > @most_space)
        puts "#{book["Title"]} into the large_books array. the books weight is #{book["weight"]}"
        @large_books << book
      end
    end
    @small_books = ((@books - @large_books) - @boxed_books)
    #order large books from smallest to largest
    @large_books.reverse!
  end

  def put_in_boxes
    @large_books.each do |large_book|
      @small_books.each do |small_book|
        if large_book["weight"] + small_book["weight"] < @max_weight

        end

    end
  end
  
end