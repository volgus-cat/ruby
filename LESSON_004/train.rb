#===============================================================
#                Класс работы с поездом
#===============================================================
class Train
  attr_accessor :number, :type, :wagonS, :route, :speed, :current_station_index 

  def initialize(number, type, route, stationS)
      @number = number           # номер(название) поезда
      @type = type               # тип поезда : Товарный, Пассажирский и другие
      @wagonS = []               # массив объектов вагонов
      @speed = 0                 # скорость поезда
      @current_station_index = 0 # индекс текущей станции (ПО РАСПИСАНИЮ ПОЕЗДА)
      @stationS = stationS       # список вокзалов (для регистрации там поезда)
      @route  = route            # маршрут
      assign_first_route(route)
  end

  # назначить ПЕРВЫЙ маршрут поезду и поставить его на первую станцию (согласно маршруту)  
  def assign_first_route(route)
    @route = route
    @current_station_index = 0 
    station = @route.stationS[@current_station_index] # стартовая станция (согласно маршруту)   
    #найти эту станцию в общем массиве станций
    index = @stationS.index {|s| s.name == station} 
    #поставить поезд на эту станцию
    @stationS[index].add_train(self)
  end

  # назначить ДРУГОЙ маршрут поезду и поставить его на первую станцию (согласно маршруту)  
  def assign_route(route)
    station = @route.stationS[@current_station_index] #станция (согласно ТЕКУЩЕМУ маршруту)  
    puts "///////////////>  старая станция #{station}"
    #найти эту станцию в общем массиве станций и удалить информацию о поезде
    index = @stationS.index {|s| s.name == station } 
    @stationS[index].send_train(self) 
    #ставим моезд на первую станцию (согласно маршруту)  
    assign_first_route(route)
  end

  #перекрыть стандартный метод для puts, print
  def to_s
    if @route == nil
       return "#{@number}    <маршрут не назначен> "   
    else 
       #начальная и конечная станции маршрута
       st = "(#{@route.stationS[0]} - #{@route.stationS[-1]})"          
       return sprintf("%-10s %-30s Вагонов:%d  Тип:%s", @number, st, @wagonS.size, @type )
    end       
  end

  #=======================================================
  # Передвинуться к следующей станции (согласно маршруту)
  #=======================================================
  def go_forward  
      go(1)
  end
  #=======================================================
  # Передвинуться к предыдущей станции (согласно маршруту)
  #=======================================================
  def go_backward
    go(-1)
  end
  #=======================================================
  # Передвинуться к ...
  #=======================================================
  def go(direction)  
    #имя текущей станции 
    station = @route.stationS[@current_station_index]
    #найти эту станцию в общем массиве станций
    index = @stationS.index {|s| s.name == station } 
    #отослать поезд с этой станции
    @stationS[index].send_train(self)   
    if direction == 1
       #сместить указатель на следующую станцию
       @current_station_index += 1 if @current_station_index < @route.stationS.size-1
    else
       #сместить указатель на предыдущую
       @current_station_index -= 1 if @current_station_index > 0  
    end
    #имя новой текущей станции 
    
    station = @route.stationS[@current_station_index]
    
    #найти эту станцию в общем массиве станций, так как она 
    index = @stationS.index {|s| s.name == station } 
    #поставить поезд на эту станцию
    @stationS[index].add_train(self)
    puts "|" * 80  
    puts "Поезд:<#{@number}> прибыл на станцию <#{station}>"
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
    @wagonS << wagon
  end

  def remove_wagon(wagon)
    if @speed.zero?
       @wagonS.delete(wagon)
    end
  end

  def next_station
      @routes.stationS[@current_station_index + 1]
  end

  def previous_station
      @routes.stationS[@current_station_index - 1]
  end

end
