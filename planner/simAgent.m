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
        
        %% Contructor
        function self = simAgent(portNumber,origin, speed)
            
            self.port = portNumber;
            self.hostname = 'localhost';        
            
            self.location = origin;
            self.landed = true;
            
            if ~exist('speed','var')
                self.speed = 590/(60*60);
            else
                self.speed = speed;
            end
        end
        
        %% Update Sensors
        function self = updateSensors(self, delta)
            % delta should be in seconds:
            if ~isempty(self.goal)
                self.heading = atan2(self.goal(1).location.y - self.location.x, ...
                                     self.goal(1).location.y - self.location.x);

                 distance = sqrt((self.goal(1).location.y - self.location.x)^2 + ...
                                     (self.goal(1).location.y - self.location.x)^2);
                                    
                self.location.x = self.location.x + cos(self.heading)*self.speed*delta;
                self.location.y  = self.location.y + sin(self.heading)*self.speed*delta;
                self.location.z = self.goal.location.z;

                if (distance < 0.01)
                    if (self.goal.landed == 1)
                        self.location = self.goal(1);
                        self.landed = 1;
                    else
                        self.loation = self.goal(1);
                    end

                    self.goal(1) = [];

                end
            
            end
        end
        
        %%
        function sendCommand(self)
            % holder method Doesn't actually need to do anything
        end

        
    end
    
end