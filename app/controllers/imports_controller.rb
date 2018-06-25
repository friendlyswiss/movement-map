class ImportsController < ApplicationController
  
  def get_moves
    
    #Returns a Moves Storyline JSON string for each week since last import 

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

  	      #Create new point feature
          place_segment = PlaceSegment.new

  	      place_segment.start_time = segment['startTime']
          place_segment.end_time = segment['endTime']

          place_segment['activities'].each { |activity| 
    
            #Create a new activity object
            activity = Activity.new

            activity.type = activity['activity']
            activity.start_time = activity['startTime']
            activity.end_time = activity['endTime']
            activity.steps = activity['steps']
            activity.calories = activity['calories']

            activity.save
          }

          place_segment.place_id = segment['place']['id']

          #Unless a place with this ID already exists, add a new one
          #By checking only for existence of a place ID, changes made to 
          #a place's name (on either end) or coordinates (in Movement Map)
          #since the last import will remain out of sync
          unless Place.exists?(segment['place']['id'])
            
            #Create new place
            place = Place.new

            place.id = segment['place']['id']
            place.title = segment['place']['name']
            
            #Create a point in format (43 74)
            place.coordinates = "(#{segment['place']['location']['lat']} #{segment['place']['location']['lon']})"
            
            #Save the place object to the database
            place.save

          end

          #Save the place segment object to the database
          place_segment.save

        elsif segment['type'] == 'move'

          #Iterate through a move's activities
          segment['activities'].each { |activity|
            
            #Create a new movement object
            movement = Movement.new

            movement.type = activity['activity']
            movement.start_time = activity['startTime']
            movement.end_time = activity['endTime']
            movement.steps = activity['steps']
            movement.calories = activity['calories']
            
            #Create a linestring in format (43 74, 98 4, 12 119)
            linestring = '('
            activity['trackPoints'].each { |coordinate| 
              
              linestring << "#{coordinate['lat']} #{coordinate['lon']}, "
            }

            linestring.gsub(/\,\ $/, ')')
            movement.coordinates = linestring

            #Save the movement object to the database
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
