function [imagePretraitee] = pretraitement(image, espaceUtilise)
% Fait le pr�-traitement
    if nargin < 2, espaceUtilise = 'rgb'; end


    imageRedim = imresize(image, [ 480, 720 ]);
    
    % pr�-traitement
    if strcmp(espaceUtilise, 'rgb')
        
    elseif strcmp(espaceUtilise, 'hsv')
        
    elseif strcmp(espaceUtilise, 'lab')
        
    else
        error("[pretraitement] '%s' n'est pas un espace couleur possible. Possibles : 'rgb', 'hsv', 'lab'", espaceUtilise);
    end
    
    imagePretraitee = imageRedim;
end

