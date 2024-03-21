classdef UI < handle
    
    properties 
    
        solver = Solver;   % Instanciando o solver
        nodes = {};        % Lista de nós
        elements = {};     % Lista de elementos
        K;                 % Matriz de rigidez do sistema
        data = [];         % Onde: data = [E,v,t]
        
        boundaryNodeList = [];   % Lista de nós estáticos
        boundaryForceList = [];  % Lista de forças aplicadas
        
        settings = Settings(4,"2D");    % Configuração inicial;
        
        % Onde:
        %  -> E = Módulo de Young (ou de elasticidade);
        %  -> v = Coeficiente de Poisson;
        %  -> t = Espessura da chapa/superfície;
        
    end
    
    methods

        function addNode(obj,node,nodeType)
           
            obj.nodes{end+1} = node;
            obj.addBoundaryNode(nodeType);
            
        end
        
        function removeForce(obj,index)
           
            obj.boundaryForceList(index) = [];
            
        end
        
        function removeNode(obj,index)
           
            obj.nodes{index} = {};
            obj.boundaryNodeList = [];
            
        end
        
        function addForce(obj,nodeNumber,orientation,magnitude,sense)
           
            % Formato = [gdl (+ ou -)magnitude];
            
            if (obj.settings.getGeometricSpace() == "2D")
            
                switch orientation
                    case "x"

                        obj.boundaryForceList(end+1,:) = [nodeNumber*2-1 magnitude*sense];

                    case "y"

                        obj.boundaryForceList(end+1,:) = [nodeNumber*2 magnitude*sense];

                end
                
            else
                
                switch orientation
                    case "x"

                        obj.boundaryForceList(end+1,:) = [nodeNumber*3-2 magnitude*sense];

                    case "y"

                        obj.boundaryForceList(end+1,:) = [nodeNumber*3-1 magnitude*sense];
                        
                    case "z"

                        obj.boundaryForceList(end+1,:) = [nodeNumber*3 magnitude*sense];

                end
                
                
            end
            
        end
        
        function addElement(obj,type,connectivity,data) 
            
            Nodes = num2cell(zeros(1,length(connectivity)));
            for i = 1:length(connectivity)
                Nodes{i} = obj.nodes{connectivity(i)};
            end
            
            switch type
                case ElementType.QUAD4
                    
                    obj.elements{end+1} = QUAD4(connectivity,Nodes,data(1),data(2),data(3));
                
                case ElementType.QUAD8    

                    obj.elements{end+1} = QUAD8(connectivity,Nodes,data(1),data(2),data(3));
                
                case ElementType.TRI3
                    
                    obj.elements{end+1} = TRI3(connectivity,Nodes,data(1),data(2),data(3));
                    
                case ElementType.HEX8
                    
                    obj.elements{end+1} = HEX8(connectivity,Nodes,data(1),data(2),data(3));
                    
            end

        
        end
        
        function [forces,displacements] = solve(obj)
           
            % Juntando todas as matrizes de rigidez:

            if (obj.settings.getGeometricSpace() == "2D")
                nGDL = 2 * length(obj.nodes);
            else
                nGDL = 3 * length(obj.nodes);    
            end
            
            obj.K = zeros(nGDL,nGDL);
            for i = 1:length(obj.elements)
               
               obj.K = Solver.concat(obj.elements{i}.getIndex(),obj.elements{i}.getK(obj.settings),obj.K,class(obj.elements{i}),obj.settings.getGeometricSpace());
               
            end

            % Resolvendo o sistema:
            
            free = [];
            nGDL = length(obj.nodes);
            for i = 1:nGDL
               
                    if (obj.settings.getGeometricSpace() == "2D")
                        
                        % Direção x:

                            if (obj.boundaryNodeList(i,1) == 0) 
                                free(end+1) = 2*i-1;
                            end

                        % Direção y:

                            if (obj.boundaryNodeList(i,2) == 0) 
                                free(end+1) = 2*i;
                            end
                    
                    else
                        
                        % Direção x:

                            if (obj.boundaryNodeList(i,1) == 0) 
                                free(end+1) = 3*i-2;
                            end

                        % Direção y:

                            if (obj.boundaryNodeList(i,2) == 0) 
                                free(end+1) = 3*i-1;
                            end
                        
                        % Direção z:
                        
                            if (obj.boundaryNodeList(i,3) == 0) 
                                free(end+1) = 3*i;
                            end
                        
                    end
                
            end
            
            obj.solver.setFreeGDLs(free);                 % Configurando os GDLs não passíveis de deslocamento
            obj.solver.setForces(obj.boundaryForceList);  % Configurando as forças aplicadas a determinados GDLs
            obj.solver.setMatrixK(obj.K);                 % Fornecendo a matriz de rigidez
            
            obj.K
            
            [forces,displacements] = obj.solver.solve();                           % Obtendo as respostas para o sistema
            
        end
        
        function nodes = getNodes(obj) 
           
            nodes = obj.nodes;
            
        end

        function elements = getElements(obj)

            elements = obj.elements;

        end

        function K = getK(obj)

            K = obj.K;

        end
        
        function boundaryNodeList = getBoundaryNodeList(obj)
            
            boundaryNodeList = obj.boundaryNodeList;
            
        end
        
        function forceList = getForceList(obj)
            
            forceList = obj.boundaryForceList;
            
        end
        
        function setGeometricSpace(obj,geometricSpace)
           
            obj.settings.setGeometricSpace(geometricSpace);
            
        end
        
    end    
    
    methods (Access = private)
    
        function addBoundaryNode(obj,nodeType)
           
            if (obj.settings.getGeometricSpace() == "2D")
            
                switch nodeType
                    case NodeType.PINNED

                        obj.boundaryNodeList(end+1,:) = [1 1];

                    case NodeType.ROLLERX

                        obj.boundaryNodeList(end+1,:) = [1 0];

                    case NodeType.ROLLERY

                        obj.boundaryNodeList(end+1,:) = [0 1];

                    case NodeType.FREE

                        obj.boundaryNodeList(end+1,:) = [0 0];

                end
            
            else
               
                switch nodeType
                    case NodeType.PINNED

                        obj.boundaryNodeList(end+1,:) = [1 1 1];

                    case NodeType.ROLLERX

                        obj.boundaryNodeList(end+1,:) = [1 0 0];

                    case NodeType.ROLLERY

                        obj.boundaryNodeList(end+1,:) = [0 1 0];
                        
                    case NodeType.ROLLERZ

                        obj.boundaryNodeList(end+1,:) = [0 0 1];

                    case NodeType.FREE

                        obj.boundaryNodeList(end+1,:) = [0 0 0];
                        
                    case NodeType.ROLLERXY

                        obj.boundaryNodeList(end+1,:) = [1 1 0];
                        
                    case NodeType.ROLLERXZ

                        obj.boundaryNodeList(end+1,:) = [1 0 1];
                        
                    case NodeType.ROLLERYZ

                        obj.boundaryNodeList(end+1,:) = [0 1 1];

                end
            
                
            end
            
        end
        
    end
    
end
