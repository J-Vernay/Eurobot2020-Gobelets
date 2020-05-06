function [M, Rand] = matConfusion(verite, obtenu, pixelsAGarder)
% Retourne la matrice de confusion 2x2.
% M = [  Vérite = Obtenu =0     Vérité=0, Obtenu=1 ;
%        Vérite=1, Obtenu=0     Vérité = Obtenu =1 ]
    masque1 = verite(:);
    masque2 = obtenu(:);
    if nargin < 3; pixelsAGarder = ones(size(verite)); end
    masquePxGarde = logical(pixelsAGarder(:));
    
    if length(masque1) ~= length(masque2) || length(masque1) ~= length(masquePxGarde)
        error('[matConfusion] Les tailles ne correspondent pas !');    
    end
    
    
    M = zeros(2,2);
    M(1,1) = sum(~masque1 & ~masque2  & masquePxGarde);
    M(1,2) = sum(~masque1 & masque2   & masquePxGarde);
    M(2,1) = sum(masque1 & ~masque2   & masquePxGarde);
    M(2,2) = sum(masque1 & masque2    & masquePxGarde);
end