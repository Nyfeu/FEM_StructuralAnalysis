classdef Settings < handle

    % Classe que define as configurações do APP.
    
    properties (Access = private)
        
        gaussPoints;
        geometricSpace;
        
    end
    
    methods
        
        % Constructor:
        
            function obj = Settings(GPs,geometricSpace)

                obj.gaussPoints = GaussPoints(GPs);
                obj.geometricSpace = geometricSpace;

            end
        
        % Getters:
        
            function [vksi,w] = getGPs(obj)
                
                [vksi,w] = obj.gaussPoints.getGPs();
                
            end
            
            function geometricSpace = getGeometricSpace(obj)
                
                geometricSpace = obj.geometricSpace;
                
            end
            
        % Setters:
        
            function setGPs(obj,GPs)
            
                obj.gaussPoints.setGP(GPs);
            
            end
            
            function setGeometricSpace(obj,geometricSpace)
            
                obj.geometricSpace = geometricSpace;
            
            end
        
    end
end

