#===============================================================
#                Класс работы с пассажирским поездом
#===============================================================
class PassengerTrain < Train
  def initialize(number,route,stations)
    super(number,:passenger,route,stations)
  end
end
