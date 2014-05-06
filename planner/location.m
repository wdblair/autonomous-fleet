classdef location < handle
   
    properties
        latitude_deg
        longitude_deg
        elevation_ft
    end
    
    methods
        function self = location(lat,long,elev)
            self.longitude_deg = long;
            self.latitude_deg = lat;
            self.elevation_ft = elev;
        end
        
        function cobj = copy(self)
            cobj = location(self.latitude_deg, ...
                            self.longitude_deg, ...
                            self.elevation_ft);
        end
        
    end
    
    methods(Static)
        function distance = distance(a,b)
            if ~isa(a,'location') || ~isa(b,'location')
                error('a and b must be locations')
            end
            
            distance = ((a.longitude_deg - b.longitude_deg)^2 + ...
                (a.latitude_deg - b.latitude_deg)^2) ^ 0.5;
        end
        
        function heading = heading(a,b)
            if ~isa(a,'location') || ~isa(b,'location')
                error('a and b must be locations')
            end
            
            heading = atan2( (b.longitude_deg - a.longitude_deg),...
                (b.latitude_deg - a.latitude_deg));
            end
        
    end
    
end