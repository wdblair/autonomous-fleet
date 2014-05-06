classdef simState
    
    properties
        locations
        agents
        map
        orders
        distances
        time
    end
    
    methods
        
        %% Contructor:
        function self = simState(varargin)
            p = inputParser;
            p.addParamValue('locations', []);
            p.addParamValue('agents',   []);
            p.addParamValue('map',  []);
            p.addParamValue('distances', []);
            p.addParamValue('orders',    []);
            p.addParamValue('time',     []);
            
            p.parse(varargin{:});
            
            self.locations = p.Results.locations;
            self.agents =  p.Results.agents;
            self.map = p.Results.map;
            self.distances = p.Results.distances;
            self.orders = p.Results.orders;
            self.time = p.Results.time;
        end
        
        %% Time Step:
        function self = update(self,delta)
            % delta is in seconds
            for i = 1:length(self.agents)
                self.agents(i) = self.agents(i).updateSensors(delta);
            end
        end
        
        %% Copy:
        function cp = copy(self)
            cp = simState('locations', self.locations, ...
                           'agents',    self.agents, ...
                           'map',   self.map, ...
                           'distances', self.distances, ...
                           'orders',    self.orders, ...
                           'time',  self.time);
        end
        
        %% Children:
        function chil = children(self)
            % Returns possible children
            % numAircraft(landed)*numAirports*numPackages
            
        end
        
        %% Heuristic:
        function h_x(self)
            h_x = [];
        end
        
        %% Visualize
        function visualize(self,figHandle)
            
        end
            
    end
    
end