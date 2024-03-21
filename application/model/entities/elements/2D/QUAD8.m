classdef QUAD8 < Element

    % Um elemento QUAD8 é um elemento plano (de chapa) formado por oito nós.
    
    methods
        
        % Constructor:
        
            function obj = QUAD8(index,nodes,E,v,t)
                
                obj = obj@Element(index,nodes,E,v,t,8);
            
            end
        
        % Getters:
            
            function MatrixK = getK(obj,settings)
                
                [vksi,w] = settings.getGPs(); 
                veta=vksi;
                
                coordinates = zeros(length(8),2);
                
                jj = 1;
                for ii=1:2:8
                    node = obj.nodes{ii};
                    coordinates(jj,:) = node.getCoordinates();
                    jj = jj + 1;
                end
                
                for ii=2:2:8
                    node = obj.nodes{ii};
                    coordinates(jj,:) = node.getCoordinates();
                    jj = jj + 1;
                end
                
                x = coordinates(:,1);
                y = coordinates(:,2);
                
                D = (obj.E/(1-obj.v^2))*[1 obj.v 0; obj.v 1 0; 0 0 (1-obj.v)/2];
                MatrixK = zeros(16,16);
                
                %  Percorre o vetor de eta:

                for ii=1:length(veta)

                    %  Percorre o vetor de ksi:

                    for jj=1:length(vksi)

                        %  Define o ponto atual:

                        ksi = vksi(ii); eta=veta(jj);

                        %  Calcula os jacobianos para a matriz Q no ponto atual:

                        J(1,1)=0.25*((1-eta)*(2*ksi+eta)*x(1)+(1-eta)*(2*ksi-eta)*x(2)+(1+eta)*(2*ksi+eta)*x(3)+(1+eta)*(2*ksi-eta)*x(4))-ksi*(1-eta)*x(5)+0.5*(1-eta^2)*x(6)-ksi*(1+eta)*x(7)+0.5*(eta^2-1)*x(8);
                        J(1,2)=0.25*((1-eta)*(2*ksi+eta)*y(1)+(1-eta)*(2*ksi-eta)*y(2)+(1+eta)*(2*ksi+eta)*y(3)+(1+eta)*(2*ksi-eta)*y(4))-ksi*(1-eta)*y(5)+0.5*(1-eta^2)*y(6)-ksi*(1+eta)*y(7)+0.5*(eta^2-1)*y(8);
                        J(2,1)=0.25*((1-ksi)*(ksi+2*eta)*x(1)+(1+ksi)*(-ksi+2*eta)*x(2)+(1+ksi)*(ksi+2*eta)*x(3)+(1-ksi)*(-ksi+2*eta)*x(4))-0.5*(1-ksi^2)*x(5)-eta*(1+ksi)*x(6)+0.5*(1-ksi^2)*x(7)+eta*(ksi-1)*x(8);
                        J(2,2)=0.25*((1-ksi)*(ksi+2*eta)*y(1)+(1+ksi)*(-ksi+2*eta)*y(2)+(1+ksi)*(ksi+2*eta)*y(3)+(1-ksi)*(-ksi+2*eta)*y(4))-0.5*(1-ksi^2)*y(5)-eta*(1+ksi)*y(6)+0.5*(1-ksi^2)*y(7)+eta*(ksi-1)*y(8);

                        detJ=J(1,1)*J(2,2)-J(1,2)*J(2,1);

                        Q=[J(2,2) -J(1,2)    0       0;
                            0      0      -J(2,1)   J(1,1);
                         -J(2,1)  J(1,1)  J(2,2)   -J(1,2)]/detJ;

                        %  Cálcula a matriz G no ponto atual:

                        G=[0.25*(1-eta)*(2*ksi+eta)   0    0.25*(1-eta)*(2*ksi-eta)    0   0.25*(1+eta)*(2*ksi+eta)   0   0.25*(1+eta)*(2*ksi-eta)    0    -ksi*(1-eta)      0    0.5*(1-eta^2)    0    -ksi*(1+eta)     0   0.5*(eta^2-1)   0;
                           0.25*(1-ksi)*(ksi+2*eta)   0    0.25*(1+ksi)*(-ksi+2*eta)   0   0.25*(1+ksi)*(ksi+2*eta)   0   0.25*(1-ksi)*(-ksi+2*eta)   0    -0.5*(1-ksi^2)    0    -eta*(1+ksi)     0   0.5*(1-ksi^2)    0   eta*(ksi-1)     0;
                           0   0.25*(1-eta)*(2*ksi+eta)   0    0.25*(1-eta)*(2*ksi-eta)    0   0.25*(1+eta)*(2*ksi+eta)  0   0.25*(1+eta)*(2*ksi-eta)    0    -ksi*(1-eta)      0    0.5*(1-eta^2)    0   -ksi*(1+eta)     0   0.5*(eta^2-1);
                           0   0.25*(1-ksi)*(ksi+2*eta)   0    0.25*(1+ksi)*(-ksi+2*eta)   0   0.25*(1+ksi)*(ksi+2*eta)  0   0.25*(1-ksi)*(-ksi+2*eta)   0    -0.5*(1-ksi^2)    0    -eta*(1+ksi)     0   0.5*(1-ksi^2)    0   eta*(ksi-1)];

                        %  Cálcula a matriz B - deslocamento-deformação:

                        B=Q*G;      

                        %  Acumula a matriz de rigidez:

                        MatrixK = MatrixK+w(ii)*w(jj)*B'*D*B*obj.t*detJ;

                    end

                end
                
            end
            
            function displayEl(obj)
                fprintf("\n\n(QUAD8) > (%d,%d,%d,%d,%d,%d,%d,%d)\n",obj.index(1),obj.index(2),obj.index(3),obj.index(4),obj.index(5),obj.index(6),obj.index(7),obj.index(8));
            end
            
    end
end

