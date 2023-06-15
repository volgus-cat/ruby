#===============================================================
#                Класс работы с меню
#===============================================================
class Menu
  attr_accessor :stationS
  #=====================================================================  
  def initialize
    @stationS = []  #список всех станций
    @routeS   = []  #список всех маршрутов
    @trainS   = []  #список всех поездов  
  
    @current_train_number = ""  #номер  поезда для манипуляции
    @current_train_index  = 0   #индекс поезда для манипуляции
    
    @nameS = ["Москва","Лихоборы","Крюково","Окуловка","Обухово","Тосно","Колпино","Петербург"]
    
  end
  #=====================================================================
  def show_menu  
    puts "РАБОТА СО СТАНЦИЯМИ:"
    puts "  [ 1]  -  Создать станции" 
    puts "  [ 2]  -  Показать список станций с поездами"
    puts "РАБОТА С МАРШРУТАМИ:"
    puts "  [ 3]  -  Создать маршрут"
    puts "  [ 4]  -  Добавить/Удалить станцию из маршрута" 
    puts "  [ 5]  -  Показать список маршрутов"
    puts "РАБОТА С ПОЕЗДАМИ:"
    puts "  [ 6]  -  Создать поезд и назначить ему маршрут"
    puts "  [ 7]  -  Изменить (М-поезду) маршрут "
    puts "  [ 8]  -  Переместить (М-поезд) ВПЕРЁД по маршруту"
    puts "  [ 9]  -  Переместить (М-поезд) НАЗАД  по маршруту"
    puts "  [10]  -  Прицепить/Отцепить вагон к (М-поезду)"
    puts "  [11]  -  Показать списк поездов"
    puts "  [12]  -  Назначить поезд для манипуляций - (М-поезд). См.пп.[7,8,9,10]"
    puts "ПРОЧИЕ КОМАНДЫ:"
    puts "  [20]  -  Выход из программы"
    puts "  [22]  -  СОЗДАТЬ ИНФРАСТРУКТУРУ ЖЕЛЕЗНОЙ ДОРОГИ (для проверки программы)"
    puts "================================================================================"
    puts " Станций:#{@stationS.size}    Маршрутов:#{@routeS.size}  Поездов:#{@trainS.size}"
    puts " ||||||||||||||||>  Поезд для манипуляций (M): #{@current_train_number}"
    puts "================================================================================"
    puts "Ожидаю команду:"
  end
#=====================================================================
  def run(command)

    if    command ==  1;  create_station_array
    elsif command ==  2;  show_full_stationS_list
    elsif command ==  3;  create_route
    elsif command ==  4;  edit_route
    elsif command ==  5;  show_routeS_list
    elsif command ==  6;  create_train  
    elsif command ==  7;  assign_route_to_train   
    elsif command ==  8;  move_train( 1) # forward
    elsif command ==  9;  move_train(-1) # backward    
    elsif command == 10;  edit_wagons      
    elsif command == 11;  show_trainS_list; 
    elsif command == 12;  assign_current_train        
    elsif command == 22;  create_railway_default
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
#    СОЗДАНИЕ ИНФРАСТРУКТУРЫ ЖЕЛЕЗНОЙ ДОРОГИ
#=====================================================================
  
  def create_railway_default

      #очистить предыдущую инфраструктуру 
      @stationS = []  #список станций
      @routeS   = []  #список маршрутов
      @trainS   = []  #список поездов
      
      #создать список стаций (по умолчанию)
      @nameS.each {|s| @stationS << Station.new(s) }
      
      show_stationS_list
  
      #создать ТРИ маршрута по умолчанию c разными конечными станциями
      @routeS << Route.new(@nameS[ 0], @nameS[-1])
      @routeS << Route.new(@nameS[ 1], @nameS[-2])
      @routeS << Route.new(@nameS[ 2], @nameS[-3])
      
      #создать списоки промежуточных станций и заполнить маршруты промежуточными станциями 
      dsa = []; @nameS.each {|n| dsa << n };  
      dsa.reverse; 
      dsa.delete_at(0); dsa.delete_at(-1); dsa.each { |d| @routeS[0].add_station(d) }
      dsa.delete_at(0); dsa.delete_at(-1); dsa.each { |d| @routeS[1].add_station(d) }
      dsa.delete_at(0); dsa.delete_at(-1); dsa.each { |d| @routeS[2].add_station(d) }
      
      #дополнитенльный маршрут для проверки
      @routeS << Route.new(@nameS[-2], @nameS[-1])
      
      #вывести список созданных саршрутов
      show_routeS_list
  
      # cоздать ТРИ поезда, назначить им маршруты, добавить вагоны
      train1 = CargoTrain.new("№123",@routeS[0],@stationS)
      1.times {train1.add_wagon(CargoWagon.new)}
      @trainS << train1     
      #---------------------------------------------------------              
      train2 = PassengerTrain.new("№456",@routeS[1],@stationS)
      2.times {train2.add_wagon(PassengerWagon.new)}
      @trainS << train2     
      #---------------------------------------------------------              
      train3 = CargoTrain.new("№789",@routeS[2],@stationS)
      3.times {train3.add_wagon(CargoWagon.new)}
      @trainS << train3     
      #---------------------------------------------------------                          
      
      #вывести список поездов с маршрутами и станциями нахождения 
      show_trainS_list

      puts "\nНазначен поезд для манипуляций: #{@trainS[0].number}"
      @current_train_index  = 0                 #индекс поезда для манипуляции
      @current_train_number = @trainS[0].number  #номер  поезда для манипуляции
      
  end
#=====================================================================
#  Показать полный список станций (с поездами)
#=====================================================================
def show_full_stationS_list
  if @stationS.empty?
     puts "Список станций пуст!"
  else   
     puts "\n\n||||||||||| Список станций ||||||||||||||\n\n"
     @stationS.each.with_index { |s,i| s.full_info(@current_train_number) }       
  end   
end
#=====================================================================
#  Показать список станций (краткий - без поездов)
#=====================================================================
def show_stationS_list
  if @stationS.empty?
     puts "Список станций пуст!"
  else   
     puts "\n\n||||||||||| Список станций ||||||||||||||\n\n"
     @stationS.each.with_index { |s,i| print "(#{i}):#{s}  " }       
  end   
end
#=====================================================================
#   Вывести список маршрутов
#=====================================================================
def show_routeS_list
  if @routeS.empty?
    puts "Список маршрутов пуст!"
  else       
    puts   "\n\n|||||||||||| Список маршрутов ||||||||||||||\n\n"
    @routeS.each_with_index do |r,i|
      puts "(#{i}):Маршрут -----------------------------\n"
      print "    "
      r.stationS.each_with_index {|s,i| print "(#{i}):#{s} "}
      puts ""   
    end 
  end  
end   
#=====================================================================
#   Вывести список поездов с маршрутами и станциями нахождения 
#===================================================================== 
def show_trainS_list
    if @trainS.empty?
       puts "Список поездов пуст!"
    else       
       puts "\n\n||||||||||||| Список поездов! |||||||||||||||\n\n"
       @trainS.each_with_index {|t, i| puts "(#{i}) : #{t}" }         
    end  
end 
#=====================================================================
#            Назначить поезд для манипуляций
#===================================================================== 
def assign_current_train
  if @trainS.empty?
     puts "Список поездов пуст!"
  else  
     show_trainS_list     
    
     puts "\nВведите (индекс) строки для выбора поезда для манипуляций:"
     i = gets.to_i
     if @trainS.at(i) != nil
        @current_train_number = @trainS[i].number
        @current_train_index  = i
        puts "\n Поезд #{@trainS[i].number} назначен поездом для манипуляций (М-поезд)" 
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
  @stationS = []
  while true
        print "Введите имя станции ( (пустая строка)-для выхода, (d)-создать станции по умолчанию ): "
        station = gets.chomp.to_s 
        if    station == ""
              break
        elsif station == "d"
              #создать список стаций (по умолчанию)
              @stationS = []
              @nameS.each {|s| @stationS << Station.new(s) }  
              break
        else  
              @stationS << Station.new(station)                
        end 
  end  
  show_stationS_list
end       

#=====================================================================
#       Создать маршрут и добавить его в массив маршрутов
#=====================================================================
  def create_route    
    if @stationS.size < 2
       puts "Дополните список станций. Пока их меньше двух (см. пункт [1] меню)"
    else
       st = "Укажите (индекс) станции для ПЕРВОЙ станции маршрута из списка:"
       
       first_station = select_from_array(@stationS,st) 
       
       stationS_reject = @stationS.reject { |s| s == first_station }
       st = "Укажите (индекс) станции для ПОСЛЕДНЕЙ станции маршрута из списка:"
       last_station = select_from_array(stationS_reject,st)
       
       if (first_station == nil) || (last_station == nil)
          puts "ОШИБКА - неправильно указан один из индексов"
          return
       end

       @routeS << Route.new(first_station.name, last_station.name)

       puts "Создан новый маршрут: #{@routeS[-1].stationS.first}-#{@routeS[-1].stationS.last}"
    end
  end 
#=====================================================================
#                  Редактировать маршрут
#=====================================================================
  def edit_route
     
    if @routeS.empty?
       puts "Список маршрутов пуст!"
    else
       show_routeS_list
       puts "\nВыберите (индекс) маршрута для редактирования:"
       r = gets.to_i
       if @routeS.at(r) == nil
          puts "\nОШИБКА - (индекс) МАРШРУТА задан неверно"
          return
       end 

       route = @routeS[r]
   
       puts "\nВыберите команду:  (1):Добавть станцию  (2):Удалить станцию"
       
       command = gets.to_i
       
       case command
       when 1                     
         mess = "Веберите (индекс) добавляемой станции:"
         station = select_from_array(@nameS,mess)
         route.add_station(station)
         puts "Станция <#{station}> добавлена в маршрут перед последней станцией!"
       when 2
         if route.stationS.size == 2
            puts "В выбранном маршруте всего две станции!"
            return
         end   
         mess = "Веберите (индекс) удаляемой станции:"
         station = select_from_array(route.stationS, mess)      
         n1 = route.stationS.size #до удаления
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
      if @trainS.empty?
         puts "Список ПОЕЗДОВ пока пуст!"
      elsif @routeS.empty?
         puts "Список МАРШРУТОВ пока пуст!"
      elsif @current_train_number == ""
        puts 'Задайте поезд для манипуляций (см. [п.12] меню)'         
      else
         train = @trainS[@current_train_index]

         show_routeS_list  #список маршрутов
         puts "\nУкажите (индекс) МАРШРУТА для этого поезда: "
         r = gets.to_i
         if @routeS.at(r) == nil
            puts "\nОШИБКА - (индекс) МАРШРУТА задан неверно"
            return
         else
            route =  @routeS[r]    
         end 

         train.assign_route(route)
         
         puts "Поезд #{train.number} получил маршрут:"
         puts "(#{route.stationS.first} - #{route.stationS.last})"
      end   
  end
#=====================================================================
#                Создание поезда в диалоге
#=====================================================================
 def create_train
  if @routeS.empty?
    puts "Для создания поезда должы быть заранее созданы маршруты (см. пункт [3] меню)"
  else    
    #---------------------------------------
    puts "Введите название (номер) поезда:"
    train_number = gets.chomp
    
    #проверить уникальность названия поезда
    index = @trainS.index {|t| t.number == train_number } 
    if index != nil
       puts "Поезд #{train_number} уже существует!!!  "  
       return
    end  
    #---------------------------------------
    #назначить маршрут поезду
    show_routeS_list  #список маршрутов

    puts "\nУкажите (индекс) МАРШРУТА для этого поезда: "
    r = gets.to_i
    if @routeS.at(r) == nil
       puts "\nОШИБКА - (индекс) МАРШРУТА задан неверно"
       return
    else
       route = @routeS[r]   
    end 
    #---------------------------------------

    puts "Выберите тип поезда: (1):грузовой, (2):пассажирский"

    type = gets.chomp.to_i
    if type == 1
       @trainS << CargoTrain.new(train_number, route, @stationS)
    elsif type == 2
       @trainS << PassengerTrain.new(train_number, route, @stationS)
    end
    train = @trainS.last
    puts "Создан поезд: #{train.number}"
            
    puts "Поезд #{train.number} получил маршрут: (#{route.stationS.first} - #{route.stationS.last})"

  end  
 end
#=====================================================================
  def create_new_wagon(train)
    if    train.type == :cargo
          CargoWagon.new
          puts "Для грузового поезда добавлен грузовой вагон"
    elsif train.type == :passenger
          PassengerWagon.new
          puts "Для пассажирского поезда добавлен пассажирский вагон"
    else      
      puts "ОШИБКА - не удалось определить тип поезда!"
    end
  end
#=====================================================================
  def edit_wagons
    if @trainS.empty?
       puts 'Отсутствуют поезда'
    elsif @current_train_number == ""
       puts 'Необходимо задать поезд для манипуляций (см. [п.12] меню)'
    else
      puts "Выберите действие 1-добавить вагон   2-удалить вагон"
      
      #поезд для манипуляций
      train = @trainS[@current_train_index]

      action = gets.chomp.to_i
      case action
      when 1
         new_wagon = create_new_wagon(train)
         train.add_wagon(new_wagon)
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
    
    if @trainS.empty?
       puts 'Нет поездов для перемещения'
    elsif @current_train_number == ""
       puts 'Задайте поезд для манипуляций (см. [п.12] меню)'
    else
      train = @trainS[@current_train_index]
      if direction == 1     
         train.go_forward   #двигаем поезд вперёд
      else
         train.go_backward  #двигаем поезд назад
      end
      show_full_stationS_list
    end
  end
  protected
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

