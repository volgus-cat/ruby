#===============================================================
#                Класс работы с поездом
#===============================================================
class Train
  attr_accessor :number, :type, :wagons, :route, :speed, :current_station_index 

  def initialize(number, type)
      @number = number           # номер(название) поезда
      @type = type               # тип поезда : Товарный, Пассажирский и другие
      @wagons = []               # массив объектов вагонов
      @speed = 0                 # скорость поезда
      @current_station_index = 0 # индекс текущей станции (ПО РАСПИСАНИЮ ПОЕЗДА)
  end

  def assign_route(route)
      @route = route
  end

  #перекрыть стандартный метод для puts, print
  def to_s
    if @route == nil
       return "#{@number}    <маршрут не назначен> "   
    else 
       #начальная и конечная станции маршрута
       st = "(#{@route.stations[0]} - #{@route.stations[-1]})"          
       return sprintf("%-10s %-30s Вагонов:%d  Тип:%s", @number, st, @wagons.size, @type )
    end       
  end

  #================================================================================
  #  Получить индекс станции (index) в общем массиве станций (stations) 
  #  по индексу станции (route_index) в маршруте поезда
  #================================================================================
  def get_index_of_station(stations,route_index)    
      #route_index-индекс станции в маршруте
      station = @route.stations[route_index]  
      #найти эту станцию в общем массиве станций
      index = stations.index {|s| s.name == station } 
  end

  #=======================================================
  # Передвинуться к следующей станции (согласно маршруту)
  #=======================================================
  def go_forward(stations)  
      go(1,stations)
  end
  #=======================================================
  # Передвинуться к предыдущей станции (согласно маршруту)
  #=======================================================
  def go_backward(stations)
      go(-1,stations)
  end
  #=======================================================
  # Передвинуться к ...
  #=======================================================
  def go(direction,stations)  
      # найти текущую станцию в общем массиве станций    
      index = get_index_of_station(stations, @current_station_index)   
      #отослать поезд с этой станции
      stations[index].send_train(self) 

      if direction == 1
         #сместить указатель на следующую станцию
         @current_station_index += 1 if @current_station_index < @route.stations.size-1
      else
         #сместить указатель на предыдущую
         @current_station_index -= 1 if @current_station_index > 0  
      end
    
      # найти НОВУЮ текущую станцию в общем массиве станций  
      index = get_index_of_station(stations, @current_station_index)   
      #поставить поезд на эту станцию
      stations[index].add_train(self)
      
      puts "|" * 80  
      puts "Поезд:<#{@number}> прибыл на станцию <#{stations[index]}>"
      puts "|" * 80
    
  end


  def speed_up(speed)
    @speed += speed if speed <= 0
  end

  def stop  
    @speed = 0
  end

  def relevant_wagon?(wagon)
    wagon.type == @type
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def remove_wagon(wagon)
    if @speed.zero?
       @wagons.delete(wagon)
    end
  end

  def next_station
      @routes.stations[@current_station_index + 1]
  end

  def previous_station
      @routes.stations[@current_station_index - 1]
  end

end
