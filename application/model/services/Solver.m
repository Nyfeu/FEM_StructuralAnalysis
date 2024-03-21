classdef Solver < handle

    % Esta classe define os parâmetros necessários para a solução da
    % anaálise estática estrutural no sistema definido.
    
    properties (Access = private)
       
        forcesList = [];
        indexFreeGDLs = [];
        matrixK;
        
    end
    
    methods
        
        function setFreeGDLs(obj,gdlsIndex)
           
            obj.indexFreeGDLs = gdlsIndex;
            
        end
        
        function setMatrixK(obj,K)
            
            obj.matrixK = K;
        
        end
        
        function setForces(obj,forces)
            
            obj.forcesList = forces;
            
        end
        
        function [forces,displacements] = solve(obj)
            
            nGDL = length(obj.matrixK(:,1));             % Quantidade de graus de liberdade
            gdl = length(obj.indexFreeGDLs);    % Quantidade de graus livres
            
            FG = zeros(nGDL,1);
            for i = 1:length(obj.forcesList)
                FG(obj.forcesList(i,1)) = obj.forcesList(i,2); 
            end
            
            Kfree = zeros(gdl,gdl);
            Ffree = zeros(gdl,1);
            
            index = obj.indexFreeGDLs;
            
            for n = 1:gdl
                Ffree(n) = FG(index(n));
                for j=1:gdl
                    Kfree(n,j)=obj.matrixK(index(n),index(j));
                end
            end
            
            x = Kfree \ Ffree;
            
            displacements = zeros (nGDL,1);
            for n=1:gdl
                displacements(index(n))=x(n); 
            end
            
            FG = obj.matrixK * displacements;
            
            forces = FG;
            
        end
        
        function stress = calculateStress(obj)
           
            
            
        end
        
    end
    
    methods (Static)
       
        function K = concat(index,matrix,K,class,geometricSpace)
            
            if (geometricSpace == "2D")
            
                aux = [];
                for j = 1:length(index)
                   node = index;
                   aux(end+1) = node(j) * 2 - 1;
                   aux(end+1) = node(j) * 2;
                end

                newIndex = aux;
                if (class == "QUAD8")

                        jj = 1;
                        for ii=1:2:8
                            newIndex(1,jj*2-1) = aux(ii*2-1);
                            newIndex(1,jj*2) = aux(ii*2);
                            jj = jj + 1;
                        end

                        for ii=2:2:8
                            newIndex(1,jj*2-1) = aux(ii*2-1);
                            newIndex(1,jj*2) = aux(ii*2);
                            jj = jj + 1;
                        end

                end

                for x = 1:length(matrix(1,:))
                    for y = 1:length(matrix(:,1))
                       K(newIndex(x),newIndex(y)) = K(newIndex(x),newIndex(y)) + matrix(x,y); 
                    end
                end
            
            else
                
                aux = [];
                for j = 1:length(index)
                   node = index;
                   aux(end+1) = node(j) * 3 - 2;
                   aux(end+1) = node(j) * 3 - 1;
                   aux(end+1) = node(j) * 3;
                end
                
                newIndex = aux;
                
                for x = 1:length(matrix(1,:))
                    for y = 1:length(matrix(:,1))
                       K(newIndex(x),newIndex(y)) = K(newIndex(x),newIndex(y)) + matrix(x,y); 
                    end
                end
                
            end
                
        end
        
    end
    
end

