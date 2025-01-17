function [ dst ] = seamCarving( src, newHeight, newWidth )
%SEAMCARVING Redimensionne une image en préservant son contenu
%   Ne supprime que les pixels ne contenant pas d'information
%   Calcule d'abord la carte d'energie de l'image (contenu)
%   Puis calcule des 'seam' à enlever de l'image,
%   par programmation dynamique
%   Attention : src et dst peuvent avoir un nombre quelconque de canaux (4
%   ou plus, par exemple).

    % On redimensionne horizontalement
    dst = resizeH( src, newWidth );
    
    % On redimensionne verticalement
    dst = permute( dst,[2,1,3] ); % on tourne de 90deg
    dst = resizeH( dst, newHeight );
    dst = permute( dst,[2,1,3] );
end

% redimensionne horizontalement une image
function [ dst ] = resizeH( src, newWidth )

    % Choisit entre enlever ou ajouter des pixels
    if newWidth < size(src,2)
        dst = shrinkH( src, newWidth );
    else
        dst = enlargeH( src, newWidth );
    end
end

% Supprime des seams verticales
function dst = shrinkH( src, newWidth )

    % TODO : Question 3
    dst = src;
    difference_of_width = size(src, 2) - newWidth;
    
    for w = 1:difference_of_width
        temp = ones(size(dst, 1), size(dst, 2) - 1, size(dst, 3));
        energy = getEnergy( dst );
        costs = pathsCost( energy );
        seam = getSeam(costs);
        for i = 1:size(dst, 1)
            temp(i, :, :) = [dst(i, 1:seam(i) - 1, :), dst(i, seam(i) + 1:end, :)];
        end
        dst = temp;
    end
end

% Duplique les pixels de seams verticales
function dst = enlargeH( src, newWidth )

    % TODO : Question 4
    %dst = imresize( src, [ size(src,1), newWidth ]);
    
    dst = src;
    difference_of_width = newWidth - size(src,2);
    
    energy = getEnergy(dst);
    
    enery_mul_factor = 1.6;
    
    for w = 1:difference_of_width
        
        costs = pathsCost(energy);
        seam = getSeam(costs);
        
        temp_dst = zeros(size(dst, 1), size(dst, 2) + 1, size(dst, 3));
        temp_energy = zeros(size(energy, 1), size(energy, 2) + 1);
        
        for i = 1:size(seam,1)
            temp_dst(i,:,:) = [dst(i, 1:seam(i, :), :), dst(i, seam(i):end, :)];
            
            temp_energy(i, :) = [energy(i, 1:seam(i)), energy(i, seam(i):end)];
            temp_energy(i, seam(i)) = temp_energy(i, seam(i)) * enery_mul_factor;
            temp_energy(i, seam(i) + 1) = temp_energy(i, seam(i) + 1) * enery_mul_factor;
        end      
        
        dst = temp_dst;
        energy = temp_energy;
    end    
    
end