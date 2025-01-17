% Pour cette question, vous devez impl�menter la fonction descGist.m qui prend en entr�e une image
% (� mettre en niveaux de gris) et qui retourne la r�ponse de l�image � 30 filtres de Gabor (6 angles
% et 5 �chelles, c.f. figure 1). La valeur absolue de la r�ponse de chaque filtre est moyenn�e sur les
% r�gions de l�image correspondant � une grille de 4x4 (attention � la mani�re dont vous moyennez ;
% n�utilisez pas de filtre Nearest). Nous obtenons donc un total de 480 valeurs. Ces valeurs peuvent
% �tre affich�es sous forme de graphique avec la fonction descGist.display() qui vous est donn�e (c.f.
% figure 2).


classdef descGist
   %DESCGIST Descripteur d'images GIST
   % dédié aux scènes extérieures
    
   % variables Statiques
   properties (Constant)
       
       nbOri = 6; % nombre d'orientation de filtres
       nbScales = 5; % nombre d'échelles de filtres
       gridSize = 4; % taille de la grille de filtres
   
       filterSize = 64; % taille des kernels
       imageSize = 128; % plus petit côté de l'image
       filters = descGist.getGabors(); % kernels des filtres de Gabor
   end
   
   properties
       
       % réponses des divers filtres :
       % [ grilleY, grilleX, échelle, orientation ]
       values;
   end
    
   methods (Static)
       
       % retourne un set de filtres (tableau à 4 dimensions)
       % [ y, x, échelle, orientation ]
       function filters = getGabors()
           
        filters = zeros( descGist.filterSize, descGist.filterSize, descGist.nbScales, descGist.nbOri );
        % TODO : Question 1
        
        pas = 180 / 6;
        lda = 32; % longueur d'onde (en pixels)
        sigmaX = 16; % gaussienne dans le sens de l'onde (px)
        sigmaY = 32; % gaussienne perpendiculaire à l'onde (px)
        for n = 0:5
            filters(:, :, 1, n + 1) = descGist.getGabor(deg2rad(n * pas), lda, sigmaX, sigmaY);
            for k = 1:4
                filters(:, :, k + 1, n + 1) = descGist.getGabor(deg2rad(n * pas), lda / (k * 2), sigmaX / (k * 2), sigmaY / (k * 2));
            end
        end
       end
       
       % retourne un filtre de Gabor
       function dst = getGabor( ...
                   theta, ... % angle de rotation (en radians)
                   lda, ... % longueur d'onde (en pixels)
                   sigmaX, ... % gaussienne dans le sens de l'onde (px)
                   sigmaY ... % gaussienne perpendiculaire à l'onde (px)
               )
           
           fS = descGist.filterSize;
           
           % coordonnées spatiales x,y
           x = repmat(linspace(-fS/2,fS/2, fS),[fS 1]);
           y = x';
           
           % coordonnées orientées par theta
           x2 = x .* cos(theta) + y .* sin(theta);
           y2 = - x .* sin(theta) + y .* cos(theta);
           
           % onde de fréquence donnée par lambda
           wave = sin( 2 * pi * x2 / lda );
           
           % pondération par une gaussienne
           dst = 1/(2*pi*sigmaX*sigmaY) .* ... % normalisation
               exp(-x2.*x2./(2*sigmaX*sigmaX)) .* ... % dans le sens de l'onde
               exp(-y2.*y2./(2*sigmaY*sigmaY)) .* ... % perpendiculaire à l'onde
               wave;
       end
       
       % affiche tous les filtres de Gabor (intensité modifiée pour l'affichage)
       function displayFilters()
           
            f = descGist.filters;
            w = size(f,1); h = size(f,2);
            n = size(f,3); m = size(f,4);
            s = zeros(w*n,h*m);
            for y = 1:n
               for x = 1:m
                  filter = f(:,:,y,x);
                  filter = filter / max(abs(filter(:))); % normalisation
                  s((y-1)*w+1:y*w,(x-1)*h+1:x*h) = filter; 
               end
            end
            imshow(uint8((128+128*s/max(abs(s(:)))))); 
       end
   end
   
   methods
       
       % constructeur (image quelconque en entrée)
       function dst = descGist(src)
       
           % si l'image est en couleur, on la convertit en gris
           if size(src,3)>1, src = rgb2gray(src); end;
           
           % on la convertit en doubles
           src = double(src);
           
           % on redimensionne l'image
           minSize = min(size(src,1),size(src,2));
           src = imresize(src, descGist.imageSize / minSize);
           
           % réponses à chaque filtres de Gabor
           dst.values = zeros( descGist.gridSize, descGist.gridSize, descGist.nbScales, descGist.nbOri);
           
           % TODO : Question 1
           
           filters = descGist.getGabors();
           for y = 1:descGist.nbOri     
               for x = 1:descGist.nbScales
                filtered_src = imfilter(src, filters(:, :, x, y), 'replicate');
                filtered_src = abs(filtered_src);
                dst.values(:, :, x, y) = imresize(filtered_src, [4 4], 'bilinear');
               end
           end
           
       end
       
       % distance entre deux descripteurs
       function d = distance(desc1,desc2)
          diff = desc1.values(:)-desc2.values(:);
          d = mean(mean(diff.*diff));
       end
       
       % affiche les valeurs du descripteur sous la forme suivante :
       % grille spatial dans l'image
       % chaque case représente le spectre de l'image
       % un fragment du spectre correspond à un filtre de Gabor
       function dst = display(desc)
           
           scales = size(desc.values,3);
           angles = size(desc.values,4);
           gridS = size(desc.values,1);
           
           % taille du résultat
           s = 256;
           
           % coordonnées spatiales du diagramme
           x = repmat(linspace(-1,1,s),[s,1]);
           y = x';
           theta = atan2(y,x);
           r = sqrt(x.*x+y.*y);
           
           dst = zeros(s*gridS,s*gridS);
           
           for i = 1:gridS
               for j = 1:gridS
                   
                   % diagramme spectral des réponses des filtres
                   diagram = zeros(s,s);
                   for scale = 1:scales
                      for angle = 1:angles
                          
                          % fragment du spectre
                          frag = zeros(s,s)+1;
                          angleValue = (angle-1)*pi/angles; % angle du filtre
                          angleDist = min(abs(theta - angleValue),abs(theta+2*pi-angleValue));
                          frag(angleDist > pi/angles/2) = 0;
                          frag(r < 0.8*((scale-1)/(scales))^0.7 +0.1 ) = 0;
                          frag(r > 0.8*((scale)/(scales))^0.7 +0.1 ) = 0;

                          % symmétrie
                          frag = frag + flip(flip(frag,1),2);

                          % diagramme des réponses de filtres sur une case
                          % de l'image
                          diagram = diagram + frag .* desc.values(i,j,scales+1-scale,angle);
                      end
                   end
                   
                   % on remplit la case de la grille
                   dst( (i-1)*s+1 : i*s, (j-1)*s+1 : j*s ) = diagram;
               end
           end
           
       end
   end
    
end
