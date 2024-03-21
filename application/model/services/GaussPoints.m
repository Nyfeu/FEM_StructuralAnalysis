classdef GaussPoints < handle

    % Classe responsável por gerenciar os pontos de Gauss.
    
    properties
       
        qtdPontos;  % Quantidade de pontos de Gauss.
        
    end
    
    methods
        
        % Constructors:
        
            function obj = GaussPoints(qtd)
                obj.qtdPontos = qtd;
            end
            
            
        % Getters
        
            function [vksi,w] = getGPs(obj)
                
                switch obj.qtdPontos

                    case 2 

                        w=[1; 1];
                        vksi=[-sqrt(1/3);sqrt(1/3)]; 

                    case 3

                        w=[5/9; 8/9; 5/9];
                        vksi=[-sqrt(3/5);0;sqrt(3/5)]; 

                    case 4

                        w=[(18-sqrt(30))/36; (18+sqrt(30))/36; (18+sqrt(30))/36; (18-sqrt(30))/36];
                        vksi=[-sqrt((3/7)+(2/7)*sqrt(6/5)); -sqrt((3/7)-(2/7)*sqrt(6/5)); sqrt((3/7)-(2/7)*sqrt(6/5)); sqrt((3/7)+(2/7)*sqrt(6/5))]; 

                end
                
            end
            
        % Setters:
        
            function setGP(obj,qtd)
                obj.qtdPontos = qtd;
            end
        
    end
end

