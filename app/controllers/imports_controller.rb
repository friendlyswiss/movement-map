class ImportsController < ApplicationController
  
  def get_moves

    #Query latest full day of data
    #start_day = segments.last.getdate or whatever
  	
  	#Loop through each week beginning at start_day
  	#loop
  	
  	#GET storyline API for each week; for now, we are referencing a static file
  	file = File.read('app/assets/storyline_20180619.json')
  	
  	#Parse the JSON string (turn it into a hash)
    data_hash = JSON.parse(file)

  	#Loop through each day in the hash
    data_hash.each { |day|

  	  #Loop through segments
  	  day['segments'].each { |segment| 
  	    
  	    if segment['type'] == 'place'

          #Add a new stay object
          stay = Stay.new

  	      stay.start_time = segment['startTime']
          stay.end_time = segment['endTime']
          stay.place_id = segment['place']['id']
          
          stay.save
          
          #Unless a place with this ID already exists, add a new one
          #By checking only for existence of a place ID, changes made to 
          #a place's name (on either end) or coordinates (in Movement Map)
          #since the last import will remain out of sync
          unless Place.exists?(segment['place']['id'])
            
            place = Place.new

            place.id = segment['place']['id']
            place.title = segment['place']['name']
            
            #Create a point in format (43 74)
            place.location = "POINT(#{segment['place']['location']['lon']} #{segment['place']['location']['lat']})"

            place.save

          end

          #Add the stay's activities
          segment['activities'].each { |act| 
    
            activity = Activity.new

            activity.type_name = act['activity']
            activity.manual = act['manual']
            activity.start_time = act['startTime']
            activity.end_time = act['endTime']
            activity.steps = act['steps']
            activity.calories = act['calories']

            activity.save
          }

        elsif segment['type'] == 'move'

          #A move may have more than one linestring feature, so iterate through them
          segment['activities'].each { |activity|
            
            #Create a new movement object
            movement = Movement.new

            movement.type_name = activity['activity']
            movement.start_time = activity['startTime']
            movement.end_time = activity['endTime']
            movement.steps = activity['steps']
            movement.calories = activity['calories']
            
            #Create a linestring in format (43 74, 98 4, 12 119)
            linestring = 'LINESTRING('

            activity['trackPoints'].each { |coordinate| 
              
              linestring << "#{coordinate['lon']} #{coordinate['lat']}, "
            }

            linestring.gsub!(/\,\ $/, ')')

            movement.path = linestring

            movement.save
          }

        elsif segment['type'] == 'off'
          #Do nothing, keep iterating

        else
          #Throw some kind of error because this JSON has new segment types
        
        end 	  
  	  }
  	}  	
  end
end
