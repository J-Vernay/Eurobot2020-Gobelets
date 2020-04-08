function [imagePretraitee, mask] = pretraitement(image, espaceUtilise)
% Fait le pré-traitement
    if nargin < 2, espaceUtilise = 'rgb'; end
    
    % pré-traitement
    if strcmp(espaceUtilise, 'rgb')
        R = image(:,:,1);
        G = image(:,:,2);
        B = image(:,:,3);
        
        indices = find(B > R & B > G);
        R(indices) = 0; G(indices) = 0; B(indices) = 0;
        
        R = R / max(R(:));
        G = G / max(G(:));
        
        RG = abs(R-G);
        mask = imbinarize(RG);
        
    elseif strcmp(espaceUtilise, 'hsv')
        
        mask = ones(size([480 720]));
        
    elseif strcmp(espaceUtilise, 'lab')
        mask = ones(size([480 720]));
    else
        error("[pretraitement] '%s' n'est pas un espace couleur possible. Possibles : 'rgb', 'hsv', 'lab'", espaceUtilise);
    end
    
    imagePretraitee = mask .* image;
    
end
