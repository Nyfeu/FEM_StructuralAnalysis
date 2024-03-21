classdef QUAD4 < Element

    % Um elemento QUAD4 é um elemento plano (de chapa) formado por quatro nós.
    
    methods
        
        % Constructor:
        
            function obj = QUAD4(index,nodes,E,v,t)
            
                obj = obj@Element(index,nodes,E,v,t,4);
            
            end
        
        % Getters:
            
            function MatrixK = getK(obj,settings)
                
                [vksi,w] = settings.getGPs(); 
                veta=vksi;
                
                coordinates = zeros(length(obj.nodes),2);
                for ii=1:length(obj.nodes)
                    node = obj.nodes{ii};
                    coordinates(ii,:) = node.getCoordinates();
                end
                
                x = coordinates(:,1);
                y = coordinates(:,2);
                
                D = (obj.E/(1-obj.v^2))*[1 obj.v 0; obj.v 1 0; 0 0 (1-obj.v)/2];
                MatrixK=zeros(8,8);
                
                for ii=1:length(veta)
                    
                    for jj=1:length(veta)
                        
                        ksi = vksi(ii); eta=veta(jj);
                        
                        J(1,1)=0.25*(-(1-eta)*x(1)+(1-eta)*x(2)+(1+eta)*x(3)-(1+eta)*x(4));
                        J(1,2)=0.25*(-(1-eta)*y(1)+(1-eta)*y(2)+(1+eta)*y(3)-(1+eta)*y(4));
                        J(2,1)=0.25*(-(1-ksi)*x(1)-(1+ksi)*x(2)+(1+ksi)*x(3)+(1-ksi)*x(4));
                        J(2,2)=0.25*(-(1-ksi)*y(1)-(1+ksi)*y(2)+(1+ksi)*y(3)+(1-ksi)*y(4));

                        detJ=J(1,1)*J(2,2)-J(1,2)*J(2,1);
                        
                        Q=[J(2,2) -J(1,2)    0       0;
                            0      0      -J(2,1)   J(1,1);
                         -J(2,1)  J(1,1)  J(2,2)   -J(1,2)]/detJ;
                     
                        G=0.25*[-(1-eta)   0    (1-eta)   0   (1+eta)  0  -(1+eta)   0;
                                -(1-ksi)   0   -(1+ksi)   0   (1+ksi)  0   (1-ksi)   0;
                                  0   -(1-eta)   0   (1-eta)  0    (1+eta)  0  -(1+eta);
                                  0   -(1-ksi)   0  -(1+ksi)  0    (1+ksi)  0   (1-ksi)];
                              
                        B=Q*G;
                        
                        MatrixK=MatrixK+w(ii)*w(jj)*B'*D*B*obj.t*detJ;
                        
                    end
                    
                end
                
            end
            
            function displayEl(obj)
                fprintf("\n\n(QUAD4) > (%d,%d,%d,%d)\n",obj.index(1),obj.index(2),obj.index(3),obj.index(4));
            end
            
    end
end

