=begin
Класс Route (Маршрут):
[п.1]	Имеет начальную и конечную станцию, а также список
      промежуточных станций. Начальная и конечная станции 
      указываются при создании маршрута, а промежуточные 
      могут добавляться между ними.
[п.2]	Может добавлять промежуточную станцию в список
[п.3]	Может удалять промежуточную станцию из списка
[п.4]	Может выводить список всех станций по-порядку от 
      начальной до конечной
=end


class Route
     # [п.1]
    def initialize (sta_first, sta_end) # [п.1]
        @sta = []    # список станций маршрута
        @sta << sta_first 
        @sta << sta_end
        @current = 0 # текущее положение поезда на маршруте
    end
    
    # имя текущей станции на маршрутее
    def get_current_sta_name
        return @sta[ @current ] 
    end  

    # переход на следующую станцию маршрута
    def next
        if  @current +  1 != @sta.size
            @current += 1
            return {:status=>"next", :sta_name=>get_current_sta_name }
        else
            return {:status=>'stop', :sta_name=>get_current_sta_name }
        end    
    end
    
    # переход на предыдущую станцию маршрута
    def prev
      if  @current > 0
          @current -= 1
          return {:status=>"prev", :sta_name=>get_current_sta_name}
      else 
          return {:status=>"stop", :sta_name=>get_current_sta_name}  
      end    
    end
      
    # длина маршрута
    def get_route_lenght
      return @sta.size
    end  
    
    # [п.2] добавить станцию в маршрут
    def add_sta(sta_new) # 
      #вставляем перед последней станцией
      @sta.insert(-2,sta_new)   
    end    
    
    # [п.3] удалить станцию из маршрута 
    def del_sta(sta_del) 
        @sta.delete(sta_del)   
    end

    # вывести список станций с указанием текущей
    def show_route # [п.4]
      puts "------ Маршрут --------"
      @sta.each_with_index do |s,index| 
        if index == @current 
             puts "#{index} #{s} <---(текущая станция)"
        else
             puts "#{index} #{s}"          
        end     
      end  
      puts "-----------------------"
    end
      
end  