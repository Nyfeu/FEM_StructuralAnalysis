classdef HEX8 < Element

    % Um elemento HEX8 é um elemento tridimensional (sólido) formado por oito nós.
    
    methods
        
        % Constructor:
        
            function obj = HEX8(index,nodes,E,v,t)
                
                obj = obj@Element(index,nodes,E,v,t,8);
            
            end
        
        % Getters:
            
            function MatrixK = getK(obj,settings)
                
                [vksi,w] = settings.getGPs(); 
                veta=vksi;
                vmu = vksi;
                
                coordinates = zeros(length(8),3);
                for ii=1:length(obj.nodes)
                    node = obj.nodes{ii};
                    coordinates(ii,:) = node.getCoordinates();
                end
                
                x = coordinates(:,1);
                y = coordinates(:,2);
                z = coordinates(:,3);
                
                Y = obj.E / (2*(1+obj.v));
                lambda = obj.E * obj.v / ((1+obj.v)*(1-2*obj.v));

                D = [2*Y+lambda lambda lambda 0 0 0;
                     lambda 2*Y+lambda lambda 0 0 0;
                     lambda lambda 2*Y+lambda 0 0 0;
                     0 0 0 Y 0 0;
                     0 0 0 0 Y 0;
                     0 0 0 0 0 Y];     %  Definição da matriz de elasticidade.

                MatrixK=zeros(24,24);      %  Pré-alocação da variável acumuladora.
                
                %  Percorre o vetor de eta:

                for ii=1:length(veta)

                    %  Percorre o vetor de ksi:

                    for jj=1:length(vksi)

                        %  Percorre o vetor de mu:

                        for kk=1:length(vmu)

                            %  Pré-alocação e reset das matrizes J e G:

                            J = zeros(3,3);
                            G = zeros(9,24);

                            %  Define o ponto atual:

                            ksi = vksi(ii); eta = veta(jj); mu = vmu(kk);


                                %  Matriz com as derivadas das funções de forma:

                                    % -> Primeira linha em relação a ksi
                                    % -> Primeira linha em relação a eta
                                    % -> Primeira linha em relação a mu

                                    %  OBS.: a matriz tem 8 colunas, que é a quantidade
                                    %  de funções de forma.

                                P = [((eta - 1)*(mu + 1))/8, -((eta - 1)*(mu - 1))/8, ((eta + 1)*(mu - 1))/8, -((eta + 1)*(mu + 1))/8, -((eta - 1)*(mu + 1))/8, ((eta - 1)*(mu - 1))/8, -((eta + 1)*(mu - 1))/8, ((eta + 1)*(mu + 1))/8;
                                     ((ksi - 1)*(mu + 1))/8, -((ksi - 1)*(mu - 1))/8, ((ksi - 1)*(mu - 1))/8, -((ksi - 1)*(mu + 1))/8, -((ksi + 1)*(mu + 1))/8, ((ksi + 1)*(mu - 1))/8, -((ksi + 1)*(mu - 1))/8, ((ksi + 1)*(mu + 1))/8;
                                     ((ksi - 1)*(eta - 1))/8, -((ksi - 1)*(eta - 1))/8, ((ksi - 1)*(eta + 1))/8, -((ksi - 1)*(eta + 1))/8, -((ksi + 1)*(eta - 1))/8, ((ksi + 1)*(eta - 1))/8, -((ksi + 1)*(eta + 1))/8, ((ksi + 1)*(eta + 1))/8];


                                % Calcular o Jacobiano e a matriz Z:

                                for ic = 1:8

                                    for ij = 1:3

                                        J(ij,1) = J(ij,1) + P(ij,ic)*x(ic);
                                        J(ij,2) = J(ij,2) + P(ij,ic)*y(ic);
                                        J(ij,3) = J(ij,3) + P(ij,ic)*z(ic);

                                        G(ij, 3 * ic - 2) = P(ij,ic);
                                        G(ij + 3, 3 * ic - 1) = P(ij,ic);
                                        G(ij + 6, 3 * ic) = P(ij,ic);

                                    end


                                 end

                            A = inv(J);

                            Q = [A(1,1) A(1,2) A(1,3) 0 0 0 0 0 0;
                                 0 0 0 A(2,1) A(2,2) A(2,3) 0 0 0;
                                 0 0 0 0 0 0 A(3,1) A(3,2) A(3,3);
                                 A(2,1) A(2,2) A(2,3) A(1,1) A(1,2) A(1,3) 0 0 0;
                                 0 0 0 A(3,1) A(3,2) A(3,3) A(2,1) A(2,2) A(2,3);
                                 A(3,1) A(3,2) A(3,3) 0 0 0 A(1,1) A(1,2) A(1,3)]; 



                            B = Q * G;

                            MatrixK = MatrixK + w(ii) * w(jj) * w(kk) * B' * D * B * det(J);

                        end

                    end
                    
                end
                
            end
            
            function displayEl(obj)
                fprintf("\n\n(HEX8) > (%d,%d,%d,%d,%d,%d,%d,%d)\n",obj.index(1),obj.index(2),obj.index(3),obj.index(4),obj.index(5),obj.index(6),obj.index(7),obj.index(8));
            end
            
    end
end

