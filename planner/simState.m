classdef simState
    
    properties
        locations
        agents
        map
        orders
        distances
        time
        paths
        
        h_x
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
            p.addParamValue('paths',    []);
            
            p.parse(varargin{:});
            
            self.locations = p.Results.locations;
            self.agents =  p.Results.agents;
            self.map = p.Results.map;
            self.distances = p.Results.distances;
            self.orders = p.Results.orders;
            self.time = p.Results.time;
            self.paths = p.Results.paths;
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
                           'time',  self.time, ...
                           'paths', self.paths);
        end
        
        %% Children:
        function [chil, deltak] = children(self)
            % 12 seconds:
            % Returns possible children
            % numAircraft(landed)*numAirports*numPackages
            
            isLanded = find(arrayfun(@(x) x.landed, self.agents));
            
            action = cell(length(isLanded),length(self.locations));
            delta = NaN(length(isLanded), length(self.locations));
            benefit = delta;
            for i = 1:length(isLanded)
                for k = 1:length(self.locations)
                    action{i,k} = [self.agents(isLanded(i)).location.index self.locations(k).index];
                    delta(i,k) = self.distances(self.agents(isLanded(i)).location.index, self.locations(k).index) / self.agents(1).speed;
                    
                    clear temp
                    inds = find(arrayfun(@(x) x.location.index, self.orders) == self.agents(isLanded(i)).location.index);
                    for m = 1:length(inds)
                        temp(m) =  ...
                            self.distances(self.orders(inds(m)).dest.index, self.locations(k).index) - ...
                            self.distances(self.orders(inds(m)).dest.index,self.orders(inds(m)).location.index); 

                    end
                    temp(temp>0) = NaN;
                    benefit(i,k) = nansum(temp) / (self.agents(1).speed);
                end
            end
            
            clear inds
            for i = 1:5
                [~,inds{i}] = nanmin(benefit,[],2);
                for m = 1:length(inds{i})
                    benefit(m,inds{i}(m)) = inf;
                    deltac(m) = delta(m,inds{i}(m));
                end
                
                deltak(i) = min(deltac); % how long does this node last?
                
                chil(i) = self.copy;
                
                for m = 1:length(isLanded)
                    chil(i).agents(isLanded(m)).goal.landed = 1;
                    chil(i).agents(isLanded(m)).goal.location = ... 
                        self.locations(inds{i}(m));
                end
                
            end
            
        end
        
        %% Heuristic:
        function h_xt = get.h_x(self)
            h_xt = 0;
            for i = 1:length(self.orders)
                h_xt = h_xt+self.distances(self.orders(i).dest.index, self.orders(i).location.index) / self.agents(1).speed;
            end
        end
        
        %% Visualize
        function visualize(self,figHandle)
            
            figure(figHandle)
            image(self.map.xd,self.map.yd,self.map.weather)
            set(gca,'YDir','normal')
            xlabel('Longitude')
            ylabel('Latitude')

            hold on
            lv = cell2mat(arrayfun(@(c) [c.x c.y],self.locations,'UniformOutput',0));
            plot(lv(:,2),lv(:,1),'ko','MarkerFaceColor','k')
            
            
            states = shaperead('usastatehi', 'UseGeoCoords', true);
            bads = [];
            for i = 1:length(states)
                if strcmp(states(i).Name,'Alaska') || strcmp(states(i).Name,'Hawaii')
                    bads = [bads i];
                end
            end
            states(bads) = [];
            
            for i = 1:length(states)
                plot(states(i).Lon(:), states(i).Lat(:),'k');
            end
            
            for i = 1:length(self.agents)
                ag = self.agents(i);
                plot(ag.location.y,ag.location.x,'co','MarkerFaceColor','c')
                plot([ag.location.y ag.goal.location.y],[ag.location.x ag.goal.location.x],'r')
            end
            
        end
            
    end
    
end