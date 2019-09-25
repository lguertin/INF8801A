function [ dst ] = poissonBlending( src, target, alpha )
%POISSONBLENDING Effectue un collage avec la méthode de Poisson
%   Remplit la zone de 'src' où 'alpha'=0 avec le laplacien de 'target'

    % Le problème de Poisson s'énonce par :
    % 'le laplacien de src est égal à celui de target là où alpha=0'
    % Pour résoudre ce problème, on utilise la méthode de Jacobi :
    % à chaque itération, un pixel est égal à la moyenne de ses voisins +
    % la valeur du laplacien cible
    
    % TODO Question 2 :
    alpha = double(repmat(alpha,[1,1,3]));
    alpha = alpha./max(alpha(:));
    
    alpha(alpha > 0.3) = 1;
    alpha(alpha <= 0.3) = 0;
    
%     dst = double(src) .* alpha + double(target) .* (1-alpha);
%     dst = uint8(dst);

    dst = double(src);
    target = double(target);
    
    laplacien = imfilter(target, [0,-1/4,0;-1/4,1,-1/4;0,-1/4,0], 'replicate');
    
    for k = 0 : 10000
        sumfq = imfilter(dst, [0,1/4,0;1/4,0,1/4;0,1/4,0], 'replicate');

        dst = sumfq + laplacien;
        
        dst(alpha==1) = src(alpha==1);
    end
    
    dst = uint8(dst);
end

