function [classes] = classification(caracteristiques,dimensionimage)
    % création des vecteurs contenant les caractéristiques des gobelets
    % expérimentaux
    % Entrée: 
    % Sortie: image avec caractéristiques inscrites sur les barycentres
    

    j=0;
    for k = 1:length(caracteristiques)
        
        if caracteristiques(k).Aire>20
            j=j+1;
            classes(j).couleur = caracteristiques(k).couleur;
            classes(j).Barycentre=caracteristiques(k).Barycentre;
            figure('visible', 'off');
            %création de la droite reliant le point d'intersection décidé
            %manuellement (35,384) et le barycentre des objets
            hold on,
            line([caracteristiques(k).Barycentre(1) 384],[caracteristiques(k).Barycentre(2) 35]);
            angle=atand((35-caracteristiques(k).Barycentre(2))/(caracteristiques(k).Barycentre(1)-384));

            %ligne à partir de l'angle
            x=round(caracteristiques(k).Barycentre(1)+100*sind(caracteristiques(k).Orientation+90));
            y=round(caracteristiques(k).Barycentre(2)+100*cosd(caracteristiques(k).Orientation+90));
            hold on,
            line([caracteristiques(k).Barycentre(1) x],[caracteristiques(k).Barycentre(2) y], 'Color','red');
            
            %comparaison des angles entre les deux lignes tracées pour
            %décider debout ou couché
            resultat(k)=caracteristiques(k).Orientation-angle;
            if resultat(k) < 5 && resultat(k) > -5 % marge de 5 degrés
                classes(j).position = "debout";
            else
                classes(j).position = "couche";
            end      
        end
        
     close(figure);
    
        
end

