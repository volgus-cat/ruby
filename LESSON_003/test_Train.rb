require_relative 'Train'

puts "=========================================================="
puts "               Тестирование класса Train                  "
puts "=========================================================="

#---------------------------------------------------------------
puts "Cоздаём маршрут для поезда "
#---------------------------------------------------------------
r = Route.new("Москва","Санкт-Петербург")
r.add_sta "Крюково"
r.add_sta "Новая Тверь"
r.add_sta "Окуловка"
r.add_sta "Мельниково"
r.add_sta "Обухово"
#---------------------------------------------------------------
puts "Cоздаём поезд c заданным маршрутом"
#---------------------------------------------------------------
t=Train.new("1-Красная стрела","Пассажирский",10)
puts t.get_params
t.set_route(r)   # передаём маршрут в поезд
t.show_route     # показать маршрут
t.set_speed(200) # поехали
t.append_coach   # добавить вагон (на ходу)
t.stop           # тормозим
t.append_coach   # добавить вагон (стоим)
puts "---------------------"
t.show_current_sta_name
t.next_station
t.next_station
t.next_station
t.next_station
t.next_station
t.next_station
t.next_station
t.show_current_sta_name
puts "---------------------"
t.show_current_sta_name
t.prev_station
t.prev_station
t.prev_station
t.prev_station
t.prev_station
t.prev_station
t.prev_station
t.show_current_sta_name
