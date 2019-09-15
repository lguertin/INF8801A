classdef descFourier
    %DESCFOURIER Descripteur de forme de Fourier
    %   calcule le contour de la forme, et retourne
    %   sa transformée de Fourier normalisée
    
    properties (Constant = true)
        nbPoints = 128; % nombre de points du contour
        descSize = 16; % fréquences du spectre à conserver
    end
    
    properties
       values; % spectre du contour (taille 'nbFreq') 
    end
    
    methods
         % constructeur (à  partir d'une image blanche sur noire)
         function dst = descFourier(shape)
            % TODO Question 1 :
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
            [number_of_points, number_of_dimensions] = size(contour);
            
            v = zeros(1, number_of_points);
            for j = 1:number_of_points
                v(j) = complex(contour(j, 1), contour(j, 2));                
            end
           
            x = 1:number_of_points;
            
            xq = linspace(1, number_of_points, descFourier.nbPoints);
            
            contour_sampled = interp1(x, v, xq);
            
            

%             Pour afficher les contours des objets avec les points echantillones
%             figure, plot(contour_sampled(:,2),contour_sampled(:,1),'g','LineWidth',2)
            fourrier_descriptors = fft(contour_sampled);
            
            fourrier_descriptors = abs(fourrier_descriptors);
            
            fourrier_descriptors(1) = [];
            
            fourrier_descriptors = fourrier_descriptors ./ fourrier_descriptors(1);
            
            
            
                
            dst.values = fourrier_descriptors;
            
         end
         
         % distance entre deux descripteurs
        function d = distance(desc1, desc2)
           
            d = mean(abs(desc1.values - desc2.values));
        end
    end
    
end

