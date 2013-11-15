require 'json'


module Sort(max_weight)
  @num_files =Dir["./data/**/*"].length
  @books =[]

  for i in (1..num_files) do
    book = Book.new(i)
    @books << book.hash
  end

  @books.sort_by!{|book|, book["weight"]}

 