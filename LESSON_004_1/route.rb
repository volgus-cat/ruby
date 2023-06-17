#===============================================================
#                Класс работы с маршрутом
#===============================================================
class Route
  attr_reader :stations

  def initialize(station_first, station_last)
    @stations = [station_first, station_last]
  end

  #добавляем новую станцию перед последней
  def add_station(station)
    if !stations.include?(station)
       @stations.insert(-2, station)
    end   
  end

  #удаляем только промежуточную станцию 
  def remove_station(station)
    if (station != @stations.first) && (station != @stations.last)
       @stations.delete(station)
    end
    return @stations.size
  end
end
