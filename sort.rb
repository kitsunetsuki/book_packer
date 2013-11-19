require 'json'

module Boxes
  include Float
 

  attr_reader :books, :boxes

  def initialize 
    @num_files =Dir["./data/**/*"].length
    @books = []
    get_books
    @boxes={}
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
      @space = ((@max_weight) - (book["weight"]))
      @most_space = @large_books.last 
      if @most_space == nil 
        @most_space = 0
      else
        @most_space = (@max_weight - @most_space["weight"])
      end
      #first, determine if there are any books that are too heavy to share a box, and put them in their own box
      if @space < @books.last["weight"]
        puts "#{book["Title"]} gets its own box! because the remainder is weighs #{@space}, and the smallest book weighs #{@books.last['weight']}"
        @boxes = {"box#{@boxcount}" => {"id" => "#{boxcount}", "total_weight" => book["weight"], "contents" => [book]}}
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
      if !(add_another_book[large_book])  #if we couldn't add another book, then box it up by itself
        @boxes = {"box#{@boxcount}" => {"id" => "#{boxcount}", "total weight" => book["weight"], "contents" => [book]}}
        boxcount+=1
      end
    end
  end

  private
  def add_another_book(books)
    @books = books
    @total_weight
    @books.each do |book|
      @current_weight += book["weight"]
    end

    @small_books.each do |small_book|

      #starting with the largest "small book"
      @combined_weight = @total_weight + small_book["weight"]
      #if the combined weight of the book(s) in the box are < the max weight and the difference between the max weight and the combined weight are greater than the smallest book, then we are going to add another book
      if @combined_weight < @max_weight && (@max_weight - @combined_weight) > @small_books.last["weight"]
        @books << small_book
        @small_books.delete[0]
         
        add_another_book(@books) #recursion automatically breaks the loop, silly
      
      elsif (@combined_weight < @max_weight) #and presumably the second statement above is false, these books are now in a box
        @boxes = {"box#{@boxcount}" => {"id" => "#{boxcount}", "total weight" => @combined_weight, "contents" => @books}}
        @boxcount += 1
        # @boxed_books << small_book
        # @books.each do |book| 
        #   @boxed_books << book
        # end
        @small_books.delete[0]
        return true #stop going through the small books, we're good
      end#else, try the same thing with the next largest "small book"
    end
    return false #can't add any more books to this pile
  end
  
end