function [ startFrame, endFrame ] = getBestLoop( src, minLength )
%GETBESTLOOP Calcule la paire de frames la plus ressemblante
%   minLength correspond à la taille minimale de la boucle vidéo
%   src correspond à une tableau 4D des pixels de la vidéo (w,h,col,frames)

    % TODO : Question 1
%     startFrame = 1;
%     endFrame = size(src,4);
    src = double(src)/255;
%     d = similarity(src(:,:,:,1), src(:,:,:,2), minLength);
    dist_matx = zeros(size(src,4));
    for frame = 1:size(src,4)
        for frame_compared = 1:size(src,4)
            dist_matx(frame, frame_compared) = similarity(src(:,:,:,frame), src(:,:,:,frame_compared));
        end
    end
    
    m = 3;
    filtered = imfilter(dist_matx, eye(m), 'circular');
    
    max_value = max(max(filtered));
    for frame = 1:size(src,4)
        for frame_compared = 1:size(src,4)
            if frame_compared <= frame + minLength && frame_compared >= frame - minLength
                filtered(frame, frame_compared) = max_value;
            end
        end
    end
    
    minMatrix = min(min(filtered));
    [ reversed_indexes, indexes] = find(filtered==minMatrix);
    startFrame = indexes(1);
    endFrame = indexes(2);
%     figure, imagesc(filtered)
end

function [ distance ] = similarity( frame_i, frame_j )
    temp = (frame_i - frame_j).^2;
    temp = sum(temp, 3);
    temp = sum(temp, 2);
    temp = sum(temp, 1);
    distance = sqrt(temp);
end

