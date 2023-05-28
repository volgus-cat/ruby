=begin
Класс Station (Станция):
[п.1]	Имеет название, которое указывается при ее создании
[п.2]	Может принимать поезда (по одному за раз)
[п.3]	Может возвращать список всех поездов на станции,
      находящиеся в текущий момент
[п.4]	Может возвращать список поездов на станции по типу 
      (см. ниже): кол-во грузовых, пассажирских
[п.5] Может отправлять поезда (по одному за раз, при этом, поезд 
      удаляется из списка поездов, находящихся на станции).
=end

class Station
  # [п.1]
  def initialize(sta_name) 
      @sta_name = sta_name
      @trains = []
  end
  
  # [п.2] принять поезд 
  def accept_train(train)   
    num = train.get_params[:num]  # номер поезда
    current_sta_name = train.get_current_sta_name  # где он на маршруте  
    if @sta_name == current_sta_name
       @trains << train
       puts "Поезд <#{num}> принят на станцию <#{@sta_name}>"
    else
       puts "Поезд <#{num}> ещё не подошёл к станции <#{@sta_name}>"
    end     
  end

  #[п.3] и [п.4]
  def get_trains_list(type_train="All")
      
      puts "///////////////////////////////////////////////////////////////"          
      case type_train
        when "Пассажирский"        
             puts "Список пассажирских поездов на станции <#{@sta_name}>:"
        when "Грузовой"        
             puts "Список грузовых поездов на станции <#{@sta_name}>:"
        else
             puts "Список всех типов поездов на станции <#{@sta_name}>:" 
      end      

      # расчитать количество поездов по каткгориям
      sum_all, sum_pass, sum_gruz = 0,0,0
      @trains.each do |t|
            params = t.get_params     
            sum_all += 1
            case params[:type] 
                 when "Пассажирский"
                 sum_pass += 1
                 when "Грузовой"
                 sum_gruz += 1
             end               
      end      

      # вывести список поездов 
      @trains.each do |t|
        params = t.get_params 

        if  (type_train == params[:type]) && (type_train == "Пассажирский")
             puts   "---> #{params[:num]} - #{params[:len]} вагонов" 
        end

        if  (type_train == params[:type]) && (type_train == "Грузовой")  
             puts   "---> #{params[:num]} - #{params[:len]} вагонов" 
        end       
        
        if  (type_train == "All")
             puts   "---> #{params[:num]} - #{params[:type]} - #{params[:len]} вагонов"           
        end
      end  

      puts "---------------------------------------------------------------"
      puts "Пас=#{sum_pass}  Груз=#{sum_gruz}  Всего=#{sum_all}"   
      puts "---------------------------------------------------------------" 
  end  
 
  # [п.5] отправить поезд со станции 
  def send_train(num_train)
     flag = false
     @trains.each_with_index do |t,index|
          params = t.get_params     
          if num_train == params[:num]
             puts "Отпраляем поезд #{num_train} по расписанию"
             t.next_station
             @trains.delete_at(index) # удаляем поезд из списка станции
             flag = true
             break
          end              
     end 
     if !flag 
        puts "Поезда #{num_train} нет на станции!!!" 
     end       
  end    

end 
