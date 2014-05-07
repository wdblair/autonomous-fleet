classdef node
   
    properties
        state %the state inside
        g_x % cost to get to node
        f_x % estimated total cost
        h_x % estimated remaining cost
        parent
        
        isSuccess
        isFailure
    end
    
    methods
        function self = node(state,parent,g_x)
            self.state = state;
            self.parent = parent;
            self.g_x = g_x;
        end
        
        %% copy:
        function cpObj = copy(self)
            % Perform a deep copy
            cpObj = node(self.state, ...
                         self.parent, ...
                         self.g_x);
        end
        
        %% Children 
        function ch = getChildren(self)
            [chState delta] = self.state.children;
            for i = 1:length(chState)
                ch(i) = self.copy();
                ch(i).state = chState(i);
                ch(i).g_x = ch(i).g_x + delta(i);
                
                ch(i).state = ch(i).state.update(delta(i));
                
                ch(i).parent = self;
            end
        end
        
        %% h_x:
        function h_xt = get.h_x(self)
            h_xt = self.state.h_x;
        end
        
        %% f_x:
        function f_x = get.f_x(self)
            f_x = self.g_x + self.h_x;
        end
        
        %% isSuccess:
        function isS = get.isSuccess(self)
            isS = (self.h_x == 0);
        end
        
        
        %% isFailure:
        function isF = get.isFailure(self)
           isF = sum(self.state.time > arrayfun(@(x) x.time, ...
                     self.state.orders(:)));
        end
        
        
    end
    
    
    
end