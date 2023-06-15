#===============================================================
#                Класс работы с маршрутом
#===============================================================
class Route
  attr_reader :stationS

  def initialize(station_first, station_last)
    @stationS = [station_first, station_last]
  end

  #добавляем новую станцию перед последней
  def add_station(station)
    if !stationS.include?(station)
       @stationS.insert(-2, station)
    end   
  end

  #удаляем только промежуточную станцию 
  def remove_station(station)
    if (station != @stationS.first) && (station != @stationS.last)
       @stationS.delete(station)
    end
    return @stationS.size
  end
end
