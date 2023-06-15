#===============================================================
#                Класс работы с грузовым поездом
#===============================================================
class CargoTrain < Train
  def initialize( number, route, stations )
    super( number, :cargo, route, stations)
  end
end
