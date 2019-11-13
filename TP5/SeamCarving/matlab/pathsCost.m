function [ costs ] = pathsCost( energy )
%PATHCOST Retourne le tableau avec l'énergie cumulée minimale pour 
%   atteindre le bord du haut (avec une seam) en partant de chacun des 
%   pixels. Obtenue par programmation dynamique (du haut vers le bas).

    % TODO : Question 2
    costs = zeros(size(energy));
    
    energy_size = size(energy);
    
    costs(1, :) = energy(1, :);
    
    for i = 2:energy_size(1)
        for j = 1:energy_size(2)
            temp = zeros(3,1);
            
            if i-1 > 0
                if j-1 > 0
                    temp(1) = costs(i-1, j-1);
                end
                
                temp(2) = costs(i-1, j);
                
                if j+1 < energy_size(2)
                    temp(3) = costs(i-1, j+1);
                end
            end
            
            temp(temp==0) = Inf;
            
            costs(i, j) = energy(i,j) + min(temp);
        end
    end

end

