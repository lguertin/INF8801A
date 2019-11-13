function [ seam ] = getSeam( costs )
%GETSEAM Retourne la seam verticale (un indice par ligne) de coût minimal
%   Remonte les coûts calculés pas la fonction "pathsCost"

    % TODO : Question 2
    h = size(costs,1);
    seam = ones(h,1);
    
    % Find the minimum index of the costs matrix for the start of the
    % algorithm
    idx = find(costs(h, :) == min(costs(h, :)));
    seam(h) = idx;
    
    i = h - 1;
    while i > 0
        % Find the 3 upper neighbours values of idx
        indexes = [Inf, Inf, Inf];
        if idx > 1
            indexes(1) = costs(i, idx - 1);
        end
        
        indexes(2) = costs(i, idx);
        
        if idx < size(costs, 2)
            indexes(3) = costs(i, idx + 1);
        end
        
        idx = idx - 2 + find(indexes == min(indexes));
        
        seam(i) = idx;
        
        i = i - 1;
    end
end

