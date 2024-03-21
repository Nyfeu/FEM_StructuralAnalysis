classdef TRI3 < Element

    % Um elemento TRI3 é um elemento plano (de chapa) formado por três nós.
    
    methods
        
        % Constructor:
        
            function obj = TRI3(index,nodes,E,v,t)
            
                obj = obj@Element(index,nodes,E,v,t,3);
            
            end
        
        % Getters:
            
            function MatrixK = getK(obj,settings)
                
                Delta = obj.elementArea();
                Bmatrix = obj.bMatrix(Delta);
                
                D = (obj.E/(1-obj.v^2)) * [1 obj.v 0; obj.v 1 0; 0 0 (1-obj.v)/2];
                
                MatrixK = obj.t * Delta * Bmatrix' * D * Bmatrix;
                
            end
            
            function displayEl(obj)
                fprintf("\n\n(TRI3) > (%d,%d,%d)\n",obj.index(1),obj.index(2),obj.index(3));
            end
            
    end
    
    methods (Access = private)
    
        % Métodos auxiliares
        
        function Area = elementArea(obj)
            
            coordinates = zeros(3,2);
            
            for ii=1:3
                node = obj.nodes{ii};
                coordinates(ii,:) = node.getCoordinates();
            end
            
            x = coordinates(:,1);
            y = coordinates(:,2);
            
            Area = (1/2)*((x(2)*y(3)-x(3)*y(2))-(x(1)*y(3)-x(3)*y(1))+(x(1)*y(2)-x(2)*y(1)));
            
        end
        
        function MatrixB = bMatrix(obj,Area)
            
            coordinates = zeros(3,2);
            
            for ii=1:3
                node = obj.nodes{ii};
                coordinates(ii,:) = node.getCoordinates();
            end
            
            x = coordinates(:,1);
            y = coordinates(:,2);
            
            x_13 = x(1) - x(3);
            x_32 = x(3) - x(2);
            x_21 = x(2) - x(1);
            
            y_12 = y(1) - y(2);
            y_23 = y(2) - y(3);
            y_31 = y(3) - y(1);
            
            b = [y_23 0 y_31 0 y_12 0; 0 x_32 0 x_13 0 x_21; x_32 y_23 x_13 y_31 x_21 y_12];
            
            MatrixB = (1/(2*Area)) * b;  
            
        end
        
    end
    
end

