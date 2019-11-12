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
        temp = ones(size(dst, 1), size(dst, 2) - 1);
        energy = getEnergy( dst );
        costs = pathsCost( energy );
        seam = getSeam(costs);
        for i = 1:size(seam) % Devrait etre egale a 256
            index_largeur = 1;
            for pixel_in_line = 1:size(dst, 2)
                if pixel_in_line ~= seam(i)
                    temp = dst(i, index_largeur);
                end
                index_largeur = index_largeur + 1;
            end
        end
        dst = temp;
    end
    % Verifier la width de l'image finale (ajuster le for difference of
    % width en fonction
end

% Duplique les pixels de seams verticales
function dst = enlargeH( src, newWidth )

    % TODO : Question 4
    dst = imresize( src, [ size(src,1), newWidth ]);
    
end