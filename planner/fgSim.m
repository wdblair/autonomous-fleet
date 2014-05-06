classdef fgSim
    
    properties
        state
    end
    
    methods
       
        %% constructor:
        function self = fgSim(varargin)
            close all
            
            ip = inputParser;
            ip.addParamValue('ifSim', 1,  @(x) (x==0)||(x==1));
            ip.addParamValue('numAgents',  30, @(x) isnumeric(x));
            ip.addParamValue('speed',    1,  @(x) isnumeric(x));
            ip.addParamValue('plannerMethod',   'real',   @(x) isstr(x));
            ip.addParamValue('initOrders',  400,    @(x) floor(x)==(x))
            ip.addParamValue('howLong', 10*60, @(x) isnumeric(x))
            ip.parse(varargin{:});
            
            ifSim = ip.Results.ifSim;
            numAgents = ip.Results.numAgents;
            plannerMethod = ip.Results.plannerMethod;
            initOrders = ip.Results.initOrders;
            howLong = ip.Results.howLong;            
            speed = ip.Results.speed;
            
            load loc.mat
            state.loc = loc;
            
            % Initalize aircraft
            if ifSim==0
                for i = 1:numAgents
                    planes(i) = aircraft(5000+i,airports(mod(i,length(airports)))); %#ok<*AGROW>
                    state.airports(mod(i,length(airports))).hasAircraft = 1;
                end
                
            else
                for i = 1:numAgents
                    agents(i) = simAgent(50000+i,airports(mod(i,length(airports))),speed));
                end
            end
            
            state.agents = agents(:);
            
            
            
        end
        
        function weather = self.updateWeather()
            load weathermap.mat
            weather = wmsread(weathermap,'ImageFormat','image/png');
        end
        
    end
    
end