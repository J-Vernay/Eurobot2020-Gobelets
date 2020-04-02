function [classes] = classification(caracteristiques)

    for k = 1:length(caracteristiques)
        
        classes(k).x = caracteristiques(k).x;
        classes(k).y = caracteristiques(k).y;
        
        if abs(caracteristiques(k).teinteMoyenne - 0.3333) < 0.1
            classes(k).couleur = 'vert';
        else
            classes(k).couleur = 'rouge';
        end
        
        classes(k).position = '/\';
    end
    
    
    
end

