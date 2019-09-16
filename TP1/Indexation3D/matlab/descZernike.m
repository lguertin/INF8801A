classdef descZernike
    %DESCZERNIKE Descripteur de forme de Zernike
    %   Utilise les moments de Zernike :
    %   on convolue la forme avec chaque polyn�me    
    
    properties (Constant = true) % variables statiques
        
        resolution = 256; % resolution en pixels des polyn�mes
        maxOrder = 10; % ordre maximal des polyn�mes
        % tableau contenant tous les polyn�mes de zernike
        polynoms = descZernike.getPolynoms();
        descSize = size(descZernike.polynoms,3); % nombre de valuers de moments
    end
    
    methods (Static = true)
        
        % retourne le polyn�me de zernike d'ordres suivants :
        % n -> ordre radial
        % m -> order angulaire
        function polynom = getPolynom( m, n )
            
            w = descZernike.resolution;
            
            % TODO Question 2 :      
            x = linspace(-1, 1, w);
            y = linspace(-1, 1, w);
            
            [X, Y] = meshgrid(x,y);
            
            r = sqrt(X.^2 + Y.^2);
            theta = atan2(Y,X);
            
            r(r>1)=0;

            R = zeros(w,w);
                           
            for k = 0 : (m-abs(n))/2
                R = R + (-1).^k * (factorial(m-k)) / (factorial(k) * factorial((m+abs(n))/2 - k) * factorial((m-abs(n))/2 - k)) * r.^(m-2*k);
            end
            
            R(R>1)=0;
         
            polynom = R .* exp(1j*n.*theta);
        end
        
        % calcule tout un set de polyn�mes de Zernike
        function polynoms = getPolynoms()
           
            polynoms = descZernike.getPolynom(0,0);
            for m = 1:descZernike.maxOrder
                for n = m:-2:0
                   polynom = descZernike.getPolynom( m, n );
                   polynoms(:,:,end+1) = polynom;
                end
            end
        end
        
        % redimensionne et translate une forme sur le disque unitaire
        function dst = rescale(shape)
             
             shape = double(shape);
             
             h = size(shape,1);
             w = size(shape,2);
             
             % on calcule le centre de la forme
             yCoords = repmat(linspace(1,h,h)',[1 w]);
             xCoords = repmat(linspace(1,w,w),[h 1]);
             % barycentre
             yCenter = round(mean(mean(shape.*yCoords))/mean(mean(shape)));
             xCenter = round(mean(mean(shape.*xCoords))/mean(mean(shape)));
             
             % on calcule le rayon maximal de la forme
             xCoords = xCoords-xCenter; yCoords = yCoords-yCenter;
             rCoords = (xCoords.*xCoords + yCoords.*yCoords).^0.5;
             rValues = rCoords.*(shape./max(shape(:)));
             rMax = floor(max(rValues(:)));
             
             % on recentre et redimensionne la forme
             dst = shape( max(1,yCenter-rMax) : min(yCenter+rMax,h), ...
                 max(1,xCenter-rMax) : min(xCenter+rMax,w) );
             dst = imresize(dst,size(shape));
        end
    end
    
    properties
       values; % r�ponses aux polyn�mes de Zernike
    end
    
    methods
        
         % constructeur (� partir d'une image blanche sur noire)
         function dst = descZernike(shape)
             
             % TODO Question 2 :
             dst.values = zeros(1,descZernike.descSize);

             s = shape;
             s(s>0) = 1;
                          
             for order = 1:descZernike.descSize
                 Mnm = sum(descZernike.polynoms(:,:,order) .* s);
                 Mnm = Mnm / (descZernike.resolution * descZernike.resolution);
                 dst.values(order) = Mnm;
             end
         end
         
        % distance entre deux descripteurs
        function d = distance(desc1, desc2)
            d = mean(abs(desc1.values - desc2.values));
        end
    end
end

