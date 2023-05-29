#=============================================================================
#                               Станция
#=============================================================================
class Station 
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept_train(train)   # Принимаем поезда
    @trains << train
  end

  def trains_by_type(type)   # Список поездов на станции по типу
      @trains.select { |train| train.type == type}
  end
  
  def send_train(train)  # Отправка поезда 
    @trains.delete(train)
  end
end

#=============================================================================
#                                Поезд
#=============================================================================
class Train
  attr_accessor :number, :type, :count, :speed, :route, :current_station_index

  def initialize(number, type, count)
      @number = number  # номер поезда
      @type   = type    # тип поезда : Товарный, Пассажирский и другие
      @count  = count   # количество вагонов
      @speed  = 0       # скорость
  end

  def accept_route(route) # получить маршрут
      @route = route
      @current_station_index = 0
  end
  
  def current_station
      @route.stations[@current_station_index]
  end  
  
  def next_station #узнать какая станция следующая
      @route.stations[@current_station_index + 1]
  end  

  def previous_station #узнать какая станция была раньше
      @route.stations[@current_station_index - 1]
  end  

  def go_next_station
      @current_station_index += 1 if @current_station_index < @route.stations.size-1
  end  

  def go_previous_station
      @current_station_index -= 1 if @current_station_index > 0
  end 

  def add_coach   
      @count += 1 if @speed == 0  
      return @count
  end  

  def subtract_coach 
      @count -= 1 if (@speed == 0) && (@count >= 0)      
      return @count
  end  

end  

#=============================================================================
#                              Маршрут
#=============================================================================
class Route 
  attr_reader :routes, :stations

  def initialize(station_first, station_last)
    @stations = [station_first, station_last]
  end
  
  #добавление НОВОЙ станции перед последней станцией
  def add_station(station) 
      if !stations.include?(station)
        stations.insert(-2, station)
      end
  end

  # удаление СУЩЕСТВУЮЩЕЙ станции
  def delete_station(station) 
      if stations.include?(station)
        stations.delete(station)
      end
  end
  
  # взять имя станции по индексу
  def station_name(station_index) 
      @stations[station_index]
  end

end

