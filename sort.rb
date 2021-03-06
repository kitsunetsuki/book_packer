require_relative 'float'
require_relative 'book'

class Boxes
 
  attr_reader :books, :boxes, :boxcount

  def initialize(max_weight)
    @num_files =Dir["./data/**/*"].length #obs, this is just pulling from the data file, but the method could be modified
    @books = []
    get_books
    @boxes={}
    @boxcount = 1
    @large_books = []
    @small_books = []
    @boxed_books = []
    @max_weight = max_weight
    sort_books
    put_in_boxes
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
        @most_space = (@max_weight - @most_space["weight"])
      end
      #first, determine if there are any books that are too heavy to share a box, and put them in their own box
      if @space < @books.last["weight"]
        @boxes = {"box#{@boxcount}" => {"id" => "#{boxcount}", "total_weight" => book["weight"], "contents" => [book]}}
        @boxcount+=1
        @boxed_books << book

        #if the book couldn't go into a box with the box with the most space in the large books array, it also joins the large books array
      elsif (book["weight"] > @most_space)
        @large_books << book
      end
    end
    @small_books = ((@books - @large_books) - @boxed_books)
    #order large books from smallest to largest
    @large_books.reverse!
  end

  def put_in_boxes
    @large_books.each do |large_book|
      if !(add_another_book([large_book]))  #if we couldn't add another book, then box it up by itself
        @boxes["box#{@boxcount}"] = {"id" => "#{boxcount}", "total weight" => large_book["weight"], "contents" => [large_book]}
       @boxcount+=1
      end
      @boxed_books <<large_book
    end
    @remainder = @books - @boxed_books
    if @remainder != []
      @large_books = [@remainder[0]]
      @remainder.delete_at(0)
      @small_books = @remainder
      put_in_boxes
    end
  end

  private
  def add_another_book(current_books)
    @current_books = current_books
    @current_weight =0
    @current_books.each do |current_book|
      @current_weight += current_book["weight"]
    end


    @small_books.each do |small_book|


      #starting with the largest "small book"
      @combined_weight = @current_weight + small_book["weight"]
      #if the combined weight of the book(s) in the box are < the max weight and the difference between the max weight and the combined weight are greater than the smallest book, then we are going to add another book
      if @combined_weight <= @max_weight && (@max_weight - @combined_weight) >= @small_books.last["weight"]
        @current_books << small_book
        @boxed_books << small_book
        @small_books.delete_at(0)
         
        add_another_book(@current_books) #recursion automatically breaks the loop, silly
      
      elsif (@combined_weight <= @max_weight) #and presumably the second statement above is false, these books are now in a box
        @current_books << small_book
        @boxed_books << small_book
        @boxes["box#{@boxcount}"] = {"id" => "#{boxcount}", "total weight" => @combined_weight, "contents" => @current_books}
        @boxcount += 1
        # @boxed_books << small_book
        # @books.each do |book| 
        #   @boxed_books << book
        # end
        @small_books.delete_at(0)
        return true #stop going through the small books, we're good
      end
    end
    return false #can't add any more books to this pile
  end

end