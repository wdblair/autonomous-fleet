classdef realAgent
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
        cargo              % cargo will be a struct with fields of goalLocation and dueTime
    end
    
    
    properties (Dependent)
        
    end
    
    methods 
        
        function self = realAgent(portNumber,airport)
            
            % Tell it to work with server
            cmd = ['./run-fg.sh ' num2str(portNumber) ' --multiplay=out,1,localhost,5000 '];             
            
             % Tell it which port to report to
            cmd = [cmd '--multiplay=in,1,localhost,' num2str(portNumber),... 
                   ' --callsign=A' num2str(portNumber)];                  
            
            % Report position 
            cmd = [cmd ' --httpd=5500 --generic=socket,out,1,localhost,',...
                   num2str(portNumber*2) ',udp,sensor_protocol '];      
               
            % actuator protocol:
            cmd = [cmd '--generic=socket,in,1,localhost,', ...
                  num2str(portNumber*2+1) ',udp,actuator_protocol '];
            
           % Aircraft selection
            cmd = [cmd '--aircraft=777-200ER '];    
            
            % Birth location
            cmd = [cmd '--airport=' airport.name];   
            
            % Start up the simulator
            cmd = [cmd ' &'];
            
            unix(cmd);                                                     
            
            %self.location.location.x = NaN;
            %self.location.location.y = NaN;
            %self.location.location.z = NaN;
            %self.location.location.name = airport.name;
            %self.landed = 1;
            
            %self.goal.location = self.location;
            
            self.port = portNumber;
            self.hostname = 'localhost';
        end
        
        function self = updateSensors(self)
            [~,result] = unix(['python sensor.py "localhost" ' num2str(2*self.port)]);
            
            result = result+1-1;
            
            breaks = find(result==9);
            breaks = [0 breaks length(result)];
            
            vars = cell(length(breaks)-1,1);
            for i = 2:length(breaks)
                vars{i-1} = result(breaks(i-1)+1:breaks(i)-1);
            end
            
            vars = cellfun(@(x) str2double(char(x)),vars); 
            
            self.heading = vars(1); 
            self.location.y = vars(2); 
            self.location.x = vars(3); self.speed = vars(4);
            self.location.z = vars(5);
        end
        
        function self = sendCommand(self)
                        
            olong = self.location.x; olat = self.location.y;
            nlong = self.goal.location.x; nlat = self.goal.location.y;
            
            gheading = atan2(nlat-olat,nlong-olong);
            dist = sqrt((nlat-olat)^2+(nlong-olong)^2);
            
            if self.location.z < 10000 == 1
                % stay landed:
                if (self.goal.location.z<10000) && (dist < 1)
                    gmode = 'off';
                else
                    gmode = 'to/ga';
                end
                
            else
                if (self.goal.location.z < 10000) && (dist < 1)
                    % land
                    gmode = 'land';
                    
                else
                    % stay and update goal heading
                    gmode = 'cruise';
                end
            end
            
            cmd = ['python control.py "localhost" ' num2str(2*self.port+1), ' ', ...
                   gmode, ' ', ... 
                   num2str(gheading), ' ',...
                   num2str(35000)];
            unix(cmd)
            
            if strcmp('land',gmode)
                 self.destroy(); 
                % We had some problems with landing errors accumulating
                % during long runs. Instead, we kill them when they should
                % be landing, and reboot them at a later point. This should
                % be fixed before using in real-life aircraft, as it would
                % be expensive ... 
            end
            
        end

        function destroy(self)
            killFile = ['./kill-fg.sh ' num2str(self.port)];
            unix(killFile);
        end
        
    end
    
end