classdef descFourier
    %DESCFOURIER Descripteur de forme de Fourier
    %   calcule le contour de la forme, et retourne
    %   sa transform�e de Fourier normalis�e
    
    properties (Constant = true)
        nbPoints = 128; % nombre de points du contour
        descSize = 16; % fr�quences du spectre � conserver
    end
    
    properties
       values; % spectre du contour (taille 'nbFreq') 
    end
    
    methods
         % constructeur (� partir d'une image blanche sur noire)
         function dst = descFourier(shape)
             
            % Vous pouvez utiliser les fonctions matlab :
            % bwtraceboundary, interp1, etc..
            
            % TODO Question 1 :
            dst.values = zeros(1,descFourier.descSize);
            
         end
         
         % distance entre deux descripteurs
        function d = distance(desc1, desc2)
           
            d = mean(abs(desc1.values - desc2.values));
        end
    end
    
end

