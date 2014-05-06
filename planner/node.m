classdef node
   
    properties
        state %the state inside
        g_x % cost to get to node
        h_x % estimated cost to goal
        f_x % estimated total cost
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
    end
    
    
    
end