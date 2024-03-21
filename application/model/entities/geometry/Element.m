classdef (Abstract) Element < handle
    
    % Um elemento é formado pela composição de nós. Podendo ser de diversos
    % tipos.
    
    properties (Access = protected)
        
        index;  % Uma lista com os índices dos nós
        nodes;  % Uma lista com todos os nós
        E;  % Módulo de elasticidade (ou de Young)
        v;  % Coeficiente de Poisson
        t;  % Espessura da chapa/elemento
        
    end
    
    methods
        
        % Constructor:
        
            function obj = Element(index,nodes,E,v,t,qtd)

                if (~(length(index) == qtd && length(nodes) == qtd))
                    
                    error = Error(1,"Invalid nodes quantity");
                    error.consoleDisplay();
                    return;
                    
                end
                
                obj.index = index;
                obj.nodes = nodes;
                obj.E = E;
                obj.v = v;
                obj.t = t;
                
            end

        % Getters:
        
            function index = getIndex(obj)
                index = obj.index;
            end

            function nodes = getNodes(obj)
                nodes = obj.nodes;
            end

        % Setters:
        
            function setNodes(obj,nodes)
                obj.nodes = nodes;
            end

            function setIndex(obj,index)
                obj.index = index;
            end
        
    end
    
    methods (Abstract)
        
        % Aqui temos métodos que deverão ser implementados pelas subclasses
        % de Element.
        
        Matrix = getK(obj);
        displayEl(obj);
        
    end
        
end

