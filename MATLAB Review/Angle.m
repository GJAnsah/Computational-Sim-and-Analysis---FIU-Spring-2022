classdef Angle
    properties (Access=protected)
        value %angle
        trajectory %x and y displacements for each occurence of the angle
    end
    
    methods
        function angle = Angle(value,trajectory)
            % Usage: angle = Angle(value,trajectory)
            % Purpose: Constructor
            % Input: value −− angle
            % trajectory −− %x and y displacements for each occurence of the angle as a
            % cell array
            % Output: angle −− Angle object
            angle.value=value;
            angle.trajectory=trajectory;
        end
        
        function [h_displacements,distance] = xVals(angle)
            % Usage: [h_displacements,distance] = xVals(angle)
            % Purpose: Get the x-values and horizontal distance for each occurence of the angle
            % Input: angle −− Angle object
            % Output: h_displacements−− x-values
            %         distance -- horizontal distance
            
            h_displacements=cellfun(@max,angle.trajectory,'UniformOutput',false);
            distance=cellfun(@max,h_displacements);
        end
        
        function [v_displacements,height] = yVals(angle)
            
            % Usage: [v_displacements,height] = yVals(angle)
            % Purpose: Get the y-values and vertical height for each occurence of the angle
            % Input: angle −− Angle object
            % Output: v_displacements−− y-values
            %         height -- vertical height
            v_displacements=cellfun(@min,angle.trajectory,'UniformOutput',false);
            height=cellfun(@max,v_displacements);
        end
        
        function flightTime = time(angle)
            % Usage: flightTime = time(angle)
            % Purpose: Get the time of flight for each occurence of the angle
            % Input: angle −− Angle object
            % Output: flightTimes−− time of flight
            flightTime =cellfun(@length,angle.trajectory);
        end
        
        function disp(~,h_displacements,v_displacements,color)
            % Usage: disp(angle,h_displacements,v_displacements,color)
            % Purpose: plot all trajectories for the angle
            % Input: ~ -- Angle object
            %        v_displacements−− y-values
            %        h_displacements−− x-values
            %        color -- line color
            % Output: figure showing trajectories
           for i=1:length(h_displacements)
               plot(h_displacements{i},v_displacements{i},'color',color)
               hold on
             
           end
        end
    end
end