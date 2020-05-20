function [classes] = classification(caracteristiques,dimensionimage)
    % cr�ation des vecteurs contenant les caract�ristiques des gobelets
    % exp�rimentaux
    % Entr�e: 
    % Sortie: image avec caract�ristiques inscrites sur les barycentres
    

    j=0;
    for k = 1:length(caracteristiques)
        
        if caracteristiques(k).Aire>20
            j=j+1;
            classes(j).couleur = caracteristiques(k).couleur;
            classes(j).Barycentre=caracteristiques(k).Barycentre;
            figure('visible', 'off');
            %cr�ation de la droite reliant le point d'intersection d�cid�
            %manuellement (35,384) et le barycentre des objets
            hold on,
            line([caracteristiques(k).Barycentre(1) 384],[caracteristiques(k).Barycentre(2) 35]);
            angle=atand((35-caracteristiques(k).Barycentre(2))/(caracteristiques(k).Barycentre(1)-384));

            %ligne � partir de l'angle
            x=round(caracteristiques(k).Barycentre(1)+100*sind(caracteristiques(k).Orientation+90));
            y=round(caracteristiques(k).Barycentre(2)+100*cosd(caracteristiques(k).Orientation+90));
            hold on,
            line([caracteristiques(k).Barycentre(1) x],[caracteristiques(k).Barycentre(2) y], 'Color','red');
            
            %comparaison des angles entre les deux lignes trac�es pour
            %d�cider debout ou couch�
            resultat(k)=caracteristiques(k).Orientation-angle;
            if resultat(k) < 5 && resultat(k) > -5 % marge de 5 degr�s
                classes(j).position = "debout";
            else
                classes(j).position = "couche";
            end      
        end
        
     close(figure);
    
        
end

