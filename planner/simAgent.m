classdef simAgent
% This custom Matlab class creates FlightGear aircraft at specificed 
% locations and allows the user to update a local representation of their 
% position. Also allows sending waypoint commands. 

    properties (Hidden)
        
    end
    
    properties
        port                % UDP port to connect to server. To listen to position is 2*port.
                            % to send commands, is 2*port+1
                            
        hostname            % hostname. For now, mandate 'localhost'
        
        % sensor readings:
        heading             % current heading of the aircraft
        speed               % current land-speed (knots)
        landed              % boolean. Is the aircraft currently on the ground?
        location
        
        % command information:
        goal
        
        % cargo information:
        cargo              % cargo class vector
        
    end
    
    methods 
        
        function self = simAgent(portNumber,airport, speed)
            
            self.port = portNumber;
            self.hostname = 'localhost';        
            
            
            self.location = airport.location.copy;
            self.landed = true;
            
            if ~exist('speed','var')
                self.speed = 590/(60*60);
            else
                self.speed = speed;
            end
        end
        
        function self = updateSensors(self, delta)
        % delta should be in seconds:
            if ~isempty(self.goal)
                self.heading = atan2(self.goal.location.latitude_deg - self.location.latitude_deg, ...
                                     self.goal.location.longitude_deg - self.location.longitude_deg);

                self.location.longitude_deg = self.location.longitude_deg + cos(self.heading)*self.speed*delta;
                self.location.latitude_deg  = self.location.latitude_deg + sin(self.heading)*self.speed*delta;
                self.location.elevation_ft = self.goal.location.elevation_ft;
            end
            
        end
        
        function sendCommand(self)
            % holder method Doesn't actually need to do anything
        end

        
    end
    
end