function [classes] = classification(caracteristiques,dimensionimage)
    j=0;
    for k = 1:length(caracteristiques)
        
        if caracteristiques(k).Aire>20
            j=j+1;
            classes(j).couleur = caracteristiques(k).couleur;
            classes(j).Barycentre=caracteristiques(k).Barycentre;
        
        % 384 49 point d'intersection?
        
            hold on,
            line([caracteristiques(k).Barycentre(1) 384],[caracteristiques(k).Barycentre(2) 35]);
            angle=atand((35-caracteristiques(k).Barycentre(2))/(caracteristiques(k).Barycentre(1)-384));

            %ligne à partir de l'angle
            x=round(caracteristiques(k).Barycentre(1)+100*sind(caracteristiques(k).Orientation+90));
            y=round(caracteristiques(k).Barycentre(2)+100*cosd(caracteristiques(k).Orientation+90));
            hold on,
            line([caracteristiques(k).Barycentre(1) x],[caracteristiques(k).Barycentre(2) y], 'Color','red');
            %a=caracteristiques(k).Orientation;
            resultat(k)=caracteristiques(k).Orientation-angle;
            if resultat(k) < 5 && resultat(k) > -5
                classes(j).position = "debout";
            else
                classes(j).position = "couche";
            end      
        end
    
        
end

