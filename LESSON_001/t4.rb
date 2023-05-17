=begin
  Квадратное уравнение. Пользователь вводит 3 коэффициента a, b и с. 
  Программа вычисляет дискриминант (D) и корни уравнения (x1 и x2, если они есть)
  и выводит значения дискриминанта и корней на экран. 
  При этом возможны следующие варианты:
  Если D > 0, то выводим дискриминант и 2 корня
  Если D = 0, то выводим дискриминант и 1 корень (т.к. корни в этом случае равны)
  Если D < 0, то выводим дискриминант и сообщение "Корней нет"
  Подсказка: Алгоритм решения с блок-схемой (www.bolshoyvopros.ru). 
  Для вычисления квадратного корня, нужно использовать Math.sqrt  
=end

puts "Программа: КВАДРАТНОЕ УРАВНЕНИЕ"
puts "===>    a*x**2 + b*x + c = 0    <==="

puts "Введите коэффициент - (a)"
a = gets.to_f
puts "Введите коэффициент - (b)"
b = gets.to_f
puts "Введите коэффициент - (c)"
c = gets.to_f

if a == 0
   if b != 0
      puts "Это линейное уравнение"
      x = -c/b
      puts "Корень #{x}"
      puts "Нажмите любую клавишу"; gets
   else
      puts "Это ВООБЩЕ НЕ уравнение"
      puts "Нажмите любую клавишу"; gets
   end 
   exit  
end   

D = b**2 - 4*a*c   # дискриминант

if D < 0
   p "Нет действительных корней"
   puts "Нажмите любую клавишу"; gets
   exit
else
  SD = Math.sqrt(D)  # корень из дискриминанта
  puts "Дискриминант = #{D}"   
end

if  D == 0
    x = -b/(2*a) 
    puts "Один корень  x = #{x}"
    puts "Нажмите любую клавишу"; gets
    exit
end 

if (D > 0)      
    x1 = (-b + SD)/(2*a)
    x2 = (-b - SD)/(2*a)
    puts "Два корня  x1 = #{x1}   x2 = #{x2}"
    puts "Нажмите любую клавишу"; gets
end

