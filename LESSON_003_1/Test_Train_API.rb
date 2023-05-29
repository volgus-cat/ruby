require_relative 'Train_API'

puts "============================================================================="
puts "                          Тестирование API                                   "
puts "============================================================================="

puts "Создадим маршруты"

station_names = ["Крюково","Новая Тверь","Окуловка","Мельниково","Обухово"]

route1 = Route.new("Москва","Петербург");  station_names.each { |sn| route1.add_station(sn) }
route2 = Route.new("Москва","Петербург");  station_names.each { |sn| route2.add_station(sn) }
route3 = Route.new("Москва","Петербург");  station_names.each { |sn| route2.add_station(sn) }

puts "Cоздадим поезда и назначим им машруты"

train1 = Train.new("№123","Грузовой",20);      train1.accept_route(route1)
train2 = Train.new("№456","Пассажирский",15);  train2.accept_route(route2)
train3 = Train.new("№679","Грузовой",10);      train3.accept_route(route3)

puts "Cоздадим станцию и поставим туда поезда"

station = Station.new("Москва")
station.accept_train(train1)
station.accept_train(train2)
station.accept_train(train3)

puts "------------------------------------------------------"
puts "  Вывести список поездов на станции для разных типов  "
puts "------------------------------------------------------"
def show_list_station(station,type="ALL")
  if    type == "Грузовой";     puts "==Список грузовых==";      list = station.trains_by_type(type) 
  elsif type == "Пассажирский"; puts "==Список пассажирских==";  list = station.trains_by_type(type) 
  else                          puts "==Весь список==";          list = station.trains
  end
  list.each {|t| puts "#{t.number} - #{t.type} - #{t.count} ваг." }   
  puts "-----------------"
  puts "Всего: #{list.size}\n\n"
end  
show_list_station(station,"Грузовой")
show_list_station(station,"Пассажирский")
show_list_station(station)

puts "---------------------------------------------------------"
puts "    Tестирование работы с одним поездом - train1         "
puts "---------------------------------------------------------"

puts "Маршрут первого поезда #{train1.number}"
train1.route.stations.each {|s| puts s}
puts "---------------------------------"

def print_current_station(train)
    puts "Текущая станция: #{train.route.station_name(train.current_station_index)}"
end    

puts "===== двигаемся вперёд на 7 станций ====="
7.times { print_current_station(train1);   train1.go_next_station }

puts "===== двигаемся назад на 7 станций ====="
7.times { print_current_station(train1);  train1.go_previous_station }

puts "===== показать станции: ====="
puts "Предыдущая     #{train1.previous_station}"
puts "Текущая   ---> #{train1.current_station}"
puts "Следующая      #{train1.previous_station}"

puts "===== установить скорость 200 ====="
train1.speed = 200 
puts "Вагонов #{train1.count}"
puts "===== попытаться прицепить вагон на скорости ====="
count = train1.count
if train1.add_coach == count
   puts "Вагон не прицепился!"
   puts "Прицеплять вагоны на ходу опасно!!!"
end
puts "===== Останавливаю поезд ====="
train1.speed = 0
puts "Скорость поезда #{train1.speed}"
puts "===== попытаться прицепить вагони снова ====="
count = train1.count
if train1.add_coach > count
  puts "Вагон прицепился!"
  puts "Теперь вагонов #{train1.count}"
end
puts "===== попытаться отцепить вагони снова ====="
count = train1.count
if train1.subtract_coach < count
  puts "Вагон благополучно отцепился!"
  puts "Теперь вагонов #{train1.count}"
end

train1.speed = 200
puts "ПОЕХАЛИ!!!"
gets