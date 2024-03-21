classdef Error < handle

    % Serviço responsável por 'tratar' exceções.
    
    properties
        
        errorCode;
        errorString;
        
    end
    
    methods
        
        % Constructor:
        
            function obj = Error(errorCode,errorString)
                obj.errorCode = errorCode;
                obj.errorString = errorString;
            end
        
        % Getters:
        
            function consoleDisplay(obj)
                fprintf("\n\nERROR (%d): %s!\n", obj.errorCode, obj.errorString);
                obj.errorDisplay();
            end
            
            function errorDisplay(obj)
               
                errorView(obj.errorCode,obj.errorString);
                
            end
            
    end
end

