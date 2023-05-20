=begin
3. Заполнить массив числами фибоначчи до 100
=end

def get_fib(n)
    a, b = 0, 1
    arr = []
    
    while a <= n  
	    arr << a
      a, b = b, a + b
    end
    
    return arr
end


puts "3. Заполнить массив числами фибоначчи до 100"

x = get_fib(100)
puts x

puts "Press any key"; gets
