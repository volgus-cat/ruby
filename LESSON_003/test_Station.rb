require_relative 'Train'
require_relative 'Route'
require_relative 'Station'

puts "================================================="
puts "          Тестирование класса Station            "
puts "================================================="
t1 = Train.new("Красная стрела","Пассажирский",10)
r1 = Route.new("Москва","Санкт-Петербург")
r1.add_sta "Крюково";     r1.add_sta "Новая Тверь";  r1.add_sta "Окуловка"
r1.add_sta "Мельниково";  r1.add_sta "Обухово";  
t1.set_route(r1)

t2 = Train.new("№123","Грузовой",30)
r2 = Route.new("Москва","Санкт-Петербург")
r2.add_sta "Крюково";     r2.add_sta "Новая Тверь";  r1.add_sta "Окуловка"
r2.add_sta "Мельниково";  r2.add_sta "Обухово";  
t2.set_route(r2)

t3 = Train.new("Фирменный","Пассажирский",15)
r3 = Route.new("Москва","Санкт-Петербург")
r3.add_sta "Крюково";     r3.add_sta "Новая Тверь";  r3.add_sta "Окуловка"
r3.add_sta "Мельниково";  r3.add_sta "Обухово";  
t3.set_route(r3)

s  = Station.new("Москва")
s.accept_train(t1)
s.accept_train(t2)
s.accept_train(t3)
s.get_trains_list

s.send_train("№123")
s.get_trains_list
