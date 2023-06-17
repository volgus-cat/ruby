#===============================================================
#                Класс работы с меню 
#===============================================================
class Menu
  attr_accessor :stations
  #=====================================================================  
  def initialize
    @stations = []  #список всех станций
    @routes   = []  #список всех маршрутов
    @trains   = []  #список всех поездов  

    @current_train_number = ""  #номер  поезда для манипуляции
    @current_train_index  = 0   #индекс поезда для манипуляции
    
    @names = ["Москва","Лихоборы","Крюково","Окуловка","Обухово","Тосно","Колпино","Петербург"]
    
  end
  #=====================================================================
  def show_menu  
    puts "РАБОТА СО СТАНЦИЯМИ:"
    puts "  [ 1]  -  Создать станции ( [101]- станции по умолчанию )" 
    puts "  [ 2]  -  Показать список станций с поездами"
    puts "РАБОТА С МАРШРУТАМИ:"
    puts "  [ 3]  -  Создать маршрут ( [103]- станции и маршруты по умолчанию )"
    puts "  [ 4]  -  Добавить/Удалить станцию из маршрута" 
    puts "  [ 5]  -  Показать список маршрутов"
    puts "РАБОТА С ПОЕЗДАМИ:"
    puts "  [ 6]  -  Создать поезд"
    puts "  [ 7]  -  Назначить поезду маршрут"
    puts "  [ 8]  -  Переместить (М-поезд) ВПЕРЁД по маршруту"
    puts "  [ 9]  -  Переместить (М-поезд) НАЗАД  по маршруту"
    puts "  [10]  -  Прицепить/Отцепить вагон к (М-поезду)"
    puts "  [11]  -  Показать списк поездов"
    puts "  [12]  -  Назначить поезд для манипуляций - (М-поезд). См.пп.[7,8,9,10]"
    puts "ПРОЧИЕ КОМАНДЫ:"
    puts "  [20]  -  Выход из программы"
    puts "  [22]  -  СОЗДАТЬ ИНФРАСТРУКТУРУ ЖЕЛЕЗНОЙ ДОРОГИ (для проверки программы)"
    puts "================================================================================"
    puts " Станций:#{@stations.size}    Маршрутов:#{@routes.size}  Поездов:#{@trains.size}"
    puts " ||||||||||||||||>  Поезд для манипуляций (M): #{@current_train_number}"
    puts "================================================================================"
    puts "Ожидаю команду:"
  end
#=====================================================================
  def run(command)

    if    command ==   1;  create_station_array
    elsif command == 101;  create_station_array_default   
    elsif command ==   2;  show_full_stations_list
    elsif command ==   3;  create_route
    elsif command == 103;  create_routes_default  
    elsif command ==   4;  edit_route
    elsif command ==   5;  show_routes_list
    elsif command ==   6;  create_train  
    elsif command ==   7;  assign_route_to_train   
    elsif command ==   8;  move_train( 1) # forward
    elsif command ==   9;  move_train(-1) # backward    
    elsif command ==  10;  edit_wagons      
    elsif command ==  11;  show_trains_list; 
    elsif command ==  12;  assign_current_train        
    elsif command ==  22;  create_railway_default
    end
    stop
  end   
#=====================================================================
#   Главный цикл 
#=====================================================================
 def main_loop
    while true
      system "cls" 
      show_menu    
       command = gets.to_i
       if command == 20
          exit
       else
          system "cls" 
          run(command)
       end    
    end
 end  
#=====================================================================
#    СОЗДАНИЕ МАРШРУТОВ ПО УМОЛЧАНИЮ (вспомог.метод)
#=====================================================================  
def create_routes_default

   #очистить предыдущую инфраструктуру 
   @routes   = []  #список маршрутов
   @stations = []  #список станций
   
   #создать список стаций (по умолчанию)
   @names.each {|s| @stations << Station.new(s) }
   
   show_stations_list

   #создать ТРИ маршрута по умолчанию c разными конечными станциями
   @routes << Route.new(@names[ 0], @names[-1])
   @routes << Route.new(@names[ 1], @names[-2])
   @routes << Route.new(@names[ 2], @names[-3])
   
   #создать списоки промежуточных станций и заполнить маршруты промежуточными станциями 
   dsa = []; @names.each {|n| dsa << n };  
   dsa.reverse; 
   dsa.delete_at(0); dsa.delete_at(-1); dsa.each { |d| @routes[0].add_station(d) }
   dsa.delete_at(0); dsa.delete_at(-1); dsa.each { |d| @routes[1].add_station(d) }
   dsa.delete_at(0); dsa.delete_at(-1); dsa.each { |d| @routes[2].add_station(d) }
   
   #вывести список созданных саршрутов
   show_routes_list
end
#=====================================================================
#    СОЗДАНИЕ ИНФРАСТРУКТУРЫ ЖЕЛЕЗНОЙ ДОРОГИ (вспомог.метод)
#=====================================================================
  
  def create_railway_default

      #очистить предыдущую инфраструктуру 
      @stations = []  #список станций
      @routes   = []  #список маршрутов
      @trains   = []  #список поездов
      
      #создать список станций и маршрутов по умолчанию
      create_routes_default

      # cоздать ТРИ поезда, назначить им маршруты, добавить вагоны (5 или 6)
      numbers = {"№123"=>:cargo,"№345"=>:passenger,"№678"=>:cargo}
      x=0
      numbers.each do |key,val|
         if    val == :cargo
               t = CargoTrain.new(key)
               5.times {t.add_wagon(    CargoWagon.new)} 
         elsif val == :passenger    
               t = PassengerTrain.new(key)
               6.times {t.add_wagon(PassengerWagon.new)}
         end           
         t.assign_route(@routes[x])                  # назначить маршрут
         index = t.get_index_of_station(stations,0)  # получить индекс в массиве станций для 0-й станцию в маршруте
         @stations[index].add_train(t)               # добавить поезд на станцию     
         @trains << t                                # добавить поезд в массив поездов
         x += 1                                      # увеличить счётчик поездов
      end                        

      #вывести список поездов с маршрутами и станциями нахождения 
      show_trains_list
      
      puts ""
      sep
      puts "Назначен поезд для манипуляций: #{@trains[0].number}"
      sep
      @current_train_index  = 0                 #индекс поезда для манипуляции
      @current_train_number = @trains[0].number  #номер  поезда для манипуляции
      
  end
#=====================================================================
#  Показать полный список станций (с поездами)
#=====================================================================
def show_full_stations_list
  if @stations.empty?
     puts "Список станций пуст!"
  else   
     puts "\n\n||||||||||| Список станций ||||||||||||||\n\n"
     @stations.each.with_index { |s,i| s.full_info(@current_train_number) }       
  end   
end
#=====================================================================
#  Показать список станций (краткий - без поездов)
#=====================================================================
def show_stations_list
  if @stations.empty?
     puts "Список станций пуст!"
  else   
     puts "\n\n||||||||||| Список станций ||||||||||||||\n\n"
     @stations.each.with_index { |s,i| print "(#{i}):#{s}  " }       
  end   
end
#=====================================================================
#   Вывести список маршрутов
#=====================================================================
def show_routes_list
  if @routes.empty?
    puts "Список маршрутов пуст!"
  else       
    puts   "\n\n|||||||||||| Список маршрутов ||||||||||||||\n\n"
    @routes.each_with_index do |r,i|
      puts "(#{i}):Маршрут -----------------------------\n"
      print "    "
      r.stations.each_with_index {|s,i| print "(#{i}):#{s} "}
      puts ""   
    end 
  end  
end   
#=====================================================================
#   Вывести список поездов с маршрутами и станциями нахождения 
#===================================================================== 
def show_trains_list
    if @trains.empty?
       puts "Список поездов пуст!"
    else       
       puts "\n\n||||||||||||| Список поездов! |||||||||||||||\n\n"
       @trains.each_with_index {|t, i| puts "(#{i}) : #{t}" }         
    end  
end 
#=====================================================================
#            Назначить поезд для манипуляций
#===================================================================== 
def assign_current_train
  if @trains.empty?
     puts "Список поездов пуст!"
  else  
     show_trains_list     
    
     puts "\nВведите (индекс) строки для выбора поезда для манипуляций:"
     i = gets.to_i
     if @trains.at(i) != nil
           if @trains[i].route == nil
              puts "\n Поезд #{@trains[i].number} не имеет маршрута!" 
              return  
           end
        @current_train_number = @trains[i].number
        @current_train_index  = i
        puts "\n Поезд #{@trains[i].number} назначен поездом для манипуляций (М-поезд)" 
     else 
        puts "\nОШИБКА - индекс поезда задан неверно"
     end 
  end    
  return 0
end 
#=====================================================================
#      Создать список станций    
#=====================================================================
def create_station_array  
  @stations = []
  while true
        print "Введите имя станции ( <пустая строка>-для выхода ): "
        station = gets.chomp.to_s 
        if  station == ""
            break
        else  
            @stations << Station.new(station)                
        end 
  end  
  show_stations_list
end       
#=====================================================================
#      Создать список станций по умолчанию (вспомог.метод)   
#=====================================================================
def create_station_array_default  
    @stations = []
    @names.each {|s| @stations << Station.new(s) }  
    show_stations_list
 end 
#=====================================================================
#       Создать маршрут и добавить его в массив маршрутов
#=====================================================================
  def create_route    
    if @stations.size < 2
       puts "Дополните список станций. Пока их меньше двух (см. пункт [1] меню)"
    else
       st = "Укажите (индекс) станции для ПЕРВОЙ станции маршрута из списка:"
       
       first_station = select_from_array(@stations,st) 
       
       stations_reject = @stations.reject { |s| s == first_station }
       st = "Укажите (индекс) станции для ПОСЛЕДНЕЙ станции маршрута из списка:"
       last_station = select_from_array(stations_reject,st)
       
       if (first_station == nil) || (last_station == nil)
          puts "ОШИБКА - неправильно указан один из индексов"
          return
       end

       @routes << Route.new(first_station.name, last_station.name)

       puts "Создан новый маршрут: #{@routes[-1].stations.first}-#{@routes[-1].stations.last}"
    end
  end 
#=====================================================================
#                  Редактировать маршрут
#=====================================================================
  def edit_route
     
    if @routes.empty?
       puts "Список маршрутов пуст!"
    else
       show_routes_list
       puts "\nВыберите (индекс) маршрута для редактирования:"
       r = gets.to_i
       if @routes.at(r) == nil
          puts "\nОШИБКА - (индекс) МАРШРУТА задан неверно"
          return
       end 

       route = @routes[r]
   
       puts "\nВыберите команду:  (1):Добавть станцию  (2):Удалить станцию"
       
       command = gets.to_i
       
       case command
       when 1                     
         mess = "Веберите (индекс) добавляемой станции:"
         station = select_from_array(@stations,mess)
         route.add_station(station)
         puts "Станция <#{station}> добавлена в маршрут перед последней станцией!"
       when 2
         if route.stations.size == 2
            puts "В выбранном маршруте всего две станции!"
            return
         end   
         mess = "Веберите (индекс) удаляемой станции:"
         station = select_from_array(route.stations, mess)      
         n1 = route.stations.size #до удаления
         n2 = route.remove_station(station) #после удаления
         if n1 == n2
            puts "Крайние станции маршрута удалять нельзя!"
         else   
            puts "Станция <#{station}> удалена из маршрута!"
         end
       else
         puts "ОШИБКА - введена ошибочная команда"  
       end
    end
  end
#=====================================================================
#                   Назначить маршрут поезду 
#=====================================================================
  def assign_route_to_train    
      if @trains.empty?
         puts "Список ПОЕЗДОВ пока пуст!"
      elsif @routes.empty?
         puts "Список МАРШРУТОВ пока пуст!"       
      else
         ######################################################
         show_trains_list      # список поездов
    
         puts "\nВведите (индекс) строки для выбора поезда для изменения маршрута:"
         i = gets.to_i
         if @trains.at(i) != nil
            train = @trains[i]
         else 
            puts "\nОШИБКА - индекс поезда задан неверно"
            return
         end 
        
         # если поезд был станции, то удалить его со станции
         @stations.each { |s| s.trains.delete(train) }
        
         ######################################################
         #список маршрутов
         show_routes_list  

         puts "\nУкажите (индекс) МАРШРУТА для этого поезда: "
         r = gets.to_i
         if @routes.at(r) == nil
            puts "\nОШИБКА - (индекс) МАРШРУТА задан неверно"
            return
         else
            route =  @routes[r]    
         end 
         ####################################################

         train.assign_route(route)
         index = train.get_index_of_station(stations,0)  # получить индекс в массиве станций для 0-й станцию в маршруте
         @stations[index].add_train(train)               # добавить поезд на станцию     
              
         puts "Поезд #{train.number} получил маршрут:"
         route.stations.each_with_index {|ai, i| print "(#{i}):#{ai} "}; puts "\n"
         
      end   
  end
#=====================================================================
#                Создание поезда в диалоге
#=====================================================================
 def create_train
     puts "Введите название (номер) поезда:"
     train_number = gets.chomp
    
     #проверить уникальность названия поезда
     index = @trains.index {|t| t.number == train_number } 
     if index != nil
        puts "Поезд #{train_number} уже существует!!!  "  
        return
     end  
     #---------------------------------------

     puts "Выберите тип поезда: (1):грузовой, (2):пассажирский"

     type = gets.chomp.to_i
     if    type == 1
           @trains << CargoTrain.new(train_number)
     elsif type == 2
           @trains << PassengerTrain.new(train_number)
     end

     train = @trains.last
     puts "Создан поезд: #{train.number} - Грузовой"      if type == 1
     puts "Создан поезд: #{train.number} - Пассажирский"  if type == 2   
            
 end
#=====================================================================
#                     Создать новый вагон
#=====================================================================
  def create_new_wagon(train)
   ###################################################################
   puts "Выберите тип присоединяемого ВАГОНА: (1):грузовой, (2):пассажирский"
   type = gets.chomp.to_i
   if [1,2].index(type) == nil
      puts "Неправильно указан тип ВАГОНА"     
      return nil
   end   
   ###################################################################
   if     (train.type == :cargo) && (type == 1)
          puts "Для грузового поезда добавлен грузовой ВАГОН"
          return CargoWagon.new          
    elsif (train.type == :passenger) && (type == 2)
          puts "Для пассажирского поезда добавлен пассажирский ВАГОН"
          return PassengerWagon.new       
    else      
          puts "ОШИБКА - тип ВАГОНА не совпадает с типом ПОЕЗДА!"
          return nil
    end
  end
#=====================================================================
#                    Редактировать 
#=====================================================================
  def edit_wagons
    if @trains.empty?
       puts 'Отсутствуют поезда'
    elsif @current_train_number == ""
       puts 'Необходимо задать поезд для манипуляций (см. [п.12] меню)'
    else
      #поезд для манипуляций
      train = @trains[@current_train_index]
      ###############################################################
      puts "Выберите действие (1)-добавить вагон, (2)-удалить вагон"
      action = gets.chomp.to_i
      if [1,2].index(action) == nil
         puts "Неправильно указана команда"     
         return
      end 
      ##############################################################
      case action
      when 1
         new_wagon = create_new_wagon(train)
         train.add_wagon(new_wagon) if new_wagon != nil
      when 2
         message = "Выберите вагон для удаления"
         wagon = select_from_array( train.wagonS, message)
         train.remove_wagon(wagon)
         puts "В поезде #{train.number} всего вагонов: #{train.wagonS.size} "
      end
    end  
  end
#=====================================================================
#            Переместить поезд (который для манипуляций)
#=====================================================================
  def move_train(direction)
    
    if @trains.empty?
       puts 'Нет поездов для перемещения'
    elsif @current_train_number == ""
       puts 'Задайте поезд для манипуляций (см. [п.12] меню)'
    else
      train = @trains[@current_train_index]
      if direction == 1     
         train.go_forward(stations)   #двигаем поезд вперёд
      else
         train.go_backward(stations)  #двигаем поезд назад
      end
      show_full_stations_list
    end
  end

  protected
  
  # ЭТИ МЕТОДЫ ИСПОЛЬЗУЮТСЯ ИСКЛЮЧИТЕЛЬНО ДЛЯ ОБЕСПЕЧЕНИЯ РАБОТЫ ДАННОГО
  # КЛАССА (Menu) И НЕ ПРЕДНАЗНАЧЕНЫ ДЛЯ ИСПОЛЬЗОВАНИЯ В ЕГО ПОТОМКАХ.
  # ПОЭТОМУ ОНИ ОБЪЯВЛЕНЫ В СЕКЦИИ protected
  #=====================================================================
  # Для выбора ответа из массива
  #=====================================================================  
  def select_from_array(a,text)
    return if a.empty?
    a.each_with_index {|ai, i| print "(#{i}):#{ai} "}; puts "\n"
    puts text
    a[gets.chomp.to_i]
  end
  #=====================================================================
  #    Для показа сообщений
  #=====================================================================
  def stop
    puts "\n\n>>>>>>>>>>>>>>>>>>>>>>>> Нажмите ENTER для продолжения"
    gets 
  end
  #=====================================================================
  #    Для выделения блока сообщений
  #=====================================================================
  def sep
    puts "|"*80
  end

end

