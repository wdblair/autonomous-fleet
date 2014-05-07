classdef node
   
    properties
        state %the state inside
        g_x % cost to get to node
        f_x % estimated total cost
        h_x % estimated remaining cost
        parent
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
            cpObj.state = self.state;
            cpObj.parent = self.parent;
            cpObj.g_x = self.g_x;
        end
        
        function ch = getChildren(self)
            [chState delta] = self.state.children;
            for i = 1:length()
                ch(i) = self.copy();
                ch(i).state = chState(i);
                ch(i).g_x = ch(i).g_x + delta(i);
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
    end
    
    
    
end