function [caracteristiques] = extraction(imagePretraitee)
    % exemple de sortie
    % il doit y avoir autant de "caracteristiques(N)" que de gobelets
    % détectés
    
    caracteristiques(1).x = 20;
    caracteristiques(1).y = 30;
    caracteristiques(1).teinteMoyenne = 0;
    
    caracteristiques(2).x = 50;
    caracteristiques(2).y = 120;
    caracteristiques(2).teinteMoyenne = 0.333;
end

