=begin
2. Заполнить массив числами от 10 до 100 с шагом 5
=end

def get_array(n1,n2,step)
    i = 0
    arr = []
    while true do
        a = n1 + step*i
        if a <= n2
           arr << a
        else 
           break
        end
        i += 1   
    end
    return arr
end    

puts "Заполнить массив числами от 10 до 100 с шагом 5"
a = get_array(10,100,5)
puts a

puts "Press any key"; gets