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
        hsv = rgb2hsv(image);
        H = hsv(:,:,1);
        S = hsv(:,:,2);
        V = hsv(:,:,3);
        
        H = mod(H + 0.3333, 1); % ainsi, la discontinuité de la teinte
        % ne se situe plus sur la teinte rouge mais sur la teinte bleue
        
        % Le masque est les pixels dont la teinte est proche de 0.33 ou
        % 0.67 (avant la translation de H, cela correspond à 0 et 0.33,
        % respectivement rouge et vert)
        mask = min(abs(H - 0.3333), abs(H - 0.6667)) < 0.1 ...
               & imbinarize(S) & imbinarize(V);
        % problème : les gobelets verts sont trop désaturés et foncés, or,
        % si on ne met pas de filtre sur S et V, les pixels
        % foncés/désaturés seront pris aussi...
        
    elseif strcmp(espaceUtilise, 'lab')
        lab = rgb2lab(image);
        L = lab(:,:,1);
        A = lab(:,:,2);
        B = lab(:,:,3);
        
        mask = B > 0.2*min(B(:)) & abs(A) > 0.3*max(abs(A(:)));
        mask = imclose(mask, strel('disk',1));
        mask = imopen(mask, strel('disk',1));
    else
        error("[pretraitement] '%s' n'est pas un espace couleur possible. Possibles : 'rgb', 'hsv', 'lab'", espaceUtilise);
    end
    
    imagePretraitee = mask .* image;
    
end
