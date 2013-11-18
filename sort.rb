require 'json'



  class Boxes
    attr_reader :books

    def initialize 
      @num_files =Dir["./data/**/*"].length
      @books = []
      get_books
    end

    def get_books

      for i in (1..@num_files) do
        puts i
        book = Book.new(i)
        puts book.title
        puts "book#{i}.html"
        @books << book.hash
      end

      @books.sort_by!{|book| book["weight"]}
    end

    def put_in_boxes
      #first, determine if there are any books that are too heavy to share a box, by detmining if the
      @books.each do

    end
    #at some point, the weights of the books will be such that they cannot be put in a box with any book that ways more than itself. this method determines that point in the array

    def needs_own_box(array)
      @array = array
      @threshold_weight = @max_weight /2 #threshold for needing it's own box
      @median = @array[@array.length/2]
      @median_weight = @median["weight"]
      #if the median weight is greater than threshold weight, then we need to look in the lower half of the array
      if array[0] == threshold
      if @median_weight > @threshold_weight
        needs_own_box(@array[0 .. @median]
      #if the median weight is less than or equal to the threshold weight, then we need to look in the upper half of the array
      elsif @median_weight <= @threshold_weight
        needs_own_box(@array[@median .. array.last])
      else

          
    end
  end