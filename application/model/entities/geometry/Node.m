classdef Node < handle
    
    % Um nó (node) é aquele que, ao ser juntado a outros nós, formará um
    % elemento.
    
    properties (Access = private)
        
        coordinateX;
        coordinateY = NaN;  % Caso não seja fornecido, será unidimensional.
        coordinateZ = NaN;  % Caso não seja fornecido, será bi/unidimensional.
        
    end
    
    methods
        
        % Constructor:
        
            function obj = Node(val1,val2,val3)
                
                % Overloading
                switch nargin
                    case 1
                        obj.coordinateX = val1;
                    case 2
                        obj.coordinateX = val1;
                        obj.coordinateY = val2;
                    case 3
                        obj.coordinateX = val1;
                        obj.coordinateY = val2;
                        obj.coordinateZ = val3;
                end
                
            end
        
        % Getters:
        
            function coordinates = getCoordinates(obj)
                
                if(isnan(obj.coordinateZ) && isnan(obj.coordinateY))
                    coordinates = [obj.coordinateX];
                elseif(isnan(obj.coordinateZ))
                    coordinates = [obj.coordinateX,obj.coordinateY];
                else 
                    coordinates = [obj.coordinateX,obj.coordinateY,obj.coordinateZ];
                end
                
            end
        
        % Setters:
            
            function setX(obj,val)
                obj.coordinateX = val;
            end
            
            function setY(obj,val)
                obj.coordinateY = val;
            end
            
            function setZ(obj,val)
                obj.coordinateZ = val;
            end
            
    end
end

