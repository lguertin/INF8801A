% Fonction principale du TP sur le filtre bilat�ral

clc
clear all
close all

%% Denoising
% Il s'agit d'une simple application du filtre bilat�ral.

noise = rgb2hsv(imread('../data/taj-rgb-noise.jpg'));
figure;
imshow(noise(:,:,3)); title('Image originale (bruit�e)');


% TODO Question 1 :
filtered = bilateralFilter(noise(:,:,3), [], 0, 1, 12, 0.2);
figure;
imshow(filtered); title('Image filtr�e');

%% Tone mapping
% Il s'agit de compresser la plage d'intensit�es d'une image en pr�servant
% les d�tails. Pour cela, on diminue les contrastes globaux en conservant
% les contrastes locaux.

% lecture de l'image hdr (� partir de 3 expositions diff�rentes)
srcFolder = '../data/hdr/memorial/'; ext = '.png';
src = double(imread([srcFolder 'low' ext])) + double(imread([srcFolder 'mid' ext])) + double(imread([srcFolder 'high' ext]));

% normalisation
src = src - min(src(:));
src = src./max(src(:));
figure; imshow(src); title('Réduction uniforme linéaire')

% Filtrage avec filtres Gaussien et bilatéral (Question 2)
noise_bi = rgb2hsv(src);
filtered = bilateralFilter(noise_bi(:,:,3), [], 0, 1, 16, 0.2);
norm_src_bi = noise_bi(:,:,3) - filtered;

norm_src_bi = norm_src_bi - min(norm_src_bi(:));
norm_src_bi = norm_src_bi./max(norm_src_bi(:));

rec = noise_bi;
rec(:,:,3) = norm_src_bi;
figure;
imshow(hsv2rgb(rec)); title('Image filtr�e avec passe haut Bilateral');

% Gaussien

noise_ga = rgb2hsv(src);
filtered = imgaussfilt(src(:,:,3), 30);
norm_src_ga = noise_ga(:,:,3) - filtered;

norm_src_ga = norm_src_ga - min(norm_src_ga(:));
norm_src_ga = norm_src_ga./max(norm_src_ga(:));

ga = noise_ga;
ga(:,:,3) = norm_src_ga;
figure;
imshow(hsv2rgb(ga)); title('Image filtr�e avec passe haut Gaussien');