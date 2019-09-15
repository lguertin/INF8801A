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
            
            center = [128, 128];
            [length_x, length_y] = size(shape);

            
            center_found = 0;
            for x = 1:length_x
                for y = 1:length_y
                    if shape(x, y) ~= 0
                        center_found = 1;
                        center = [x, y];
                        break
                    end
                end
                
                if center_found == 1
                    break
                end
            end
            
            contour = bwtraceboundary(shape, center, 'N');
%             figure, plot(contour(:,2),contour(:,1),'g','LineWidth',2)
%             keyboard
            

            [number_of_points, number_of_dimensions] = size(contour);
            
%             Echantillonner par 128
            
%             Zk = 0;
%             
%             for j = 1:number_of_points
%                 z = complex(contour(j, 1), contour(j, 2));
%                 i = complex(0, 1);
%                 
%                 Zk += 
%                 
%             end
           
            
            % TODO Question 1 :
%             Y = fft(X)
            dst.values = zeros(1,descFourier.descSize);
            
         end
         
         % distance entre deux descripteurs
        function d = distance(desc1, desc2)
           
            d = mean(abs(desc1.values - desc2.values));
        end
    end
    
end

