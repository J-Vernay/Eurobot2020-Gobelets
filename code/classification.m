function [classes] = classification(caracteristiques,dimensionimage)

    for k = 1:length(caracteristiques)
        
        classes(k).x = caracteristiques(k).x;
        classes(k).y = caracteristiques(k).y;
        
        coefperspective=dimensionimage(2)-caracteristiques(k).y/dimensionimage(2);
        if abs(caracteristiques(k).teinteMoyenne - 0.3333) < 0.1
            classes(k).couleur = 'vert';
        else
            classes(k).couleur = 'rouge';
        end
        
        if abs(caracteristiques(k).x - 3) < 15
            classes(k).position = '/\';
        else if abs(caracteristiques(k).x - 3) > 50
                classes(k).position = '\/';
            else
                classes(k).position = '--';
            end
        end
            
            
         
    end
end

