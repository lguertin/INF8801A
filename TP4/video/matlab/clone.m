function [ dst ] = clone( src, nbClones )
%CLONE Clone les personnages d'une boucle
%   src : frames de la vidéo (w,h,col,frames)
%   nbClones : nombre de clones (=0 si aucun clonage)

    % arguments par défault
    if nargin < 2, nbClones = 2; end
    
    % TODO : Question 2
    
    src = double(src) / 255;
    background = mean(src, 4);
    
    nb_frames = size(src,4);
    dst_between_clone_frames = floor(nb_frames / nbClones);
    
    dst = repmat(background,1,1,1,49);
    
    mvts_seg_mask = mean(abs(src - dst), 3);
    
    mask_ratio = 0.085;
    mvts_seg_mask(mvts_seg_mask < mask_ratio) = 0;
    mvts_seg_mask(mvts_seg_mask >= mask_ratio) = 1;
   
    mvts_seg = src .* mvts_seg_mask;
    
    for frame = 1:nb_frames
        for clone = 1:nbClones
            frame_offset = frame + (clone - 1) * dst_between_clone_frames;
            while (frame_offset > nb_frames)
                frame_offset = frame_offset - nb_frames;
            end
            
            dst(:,:,:,frame) = dst(:,:,:,frame) .* (1 - mvts_seg_mask(:,:,:,frame_offset)) + mvts_seg(:,:,:,frame_offset);
        end
    end

end

