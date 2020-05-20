function [] = Resultatimage(SortieObjets,image,nomsFichiers)
    % création d'image pour vérifier visuellement les réaultats
    % Entrée: vecteurs d'informations de potentiels gobelets
    % Sortie: vecteurs des gobelets expérimentaux et leurs
    %caractéristiques
    

    %création des images avec des * pour rouge et des + pour vert
    figure('visible', 'off')
    imshow(image)
    hold on
    for k = 1:length(SortieObjets)
        if SortieObjets(k).couleur=="vert"
            plot(SortieObjets(k).Barycentre(1),SortieObjets(k).Barycentre(2) , 'k*');
        else if SortieObjets(k).couleur=="rouge"
            plot(SortieObjets(k).Barycentre(1),SortieObjets(k).Barycentre(2) , 'k+');
            end
        end
    end
    F = getframe ;
    % save the image:
    imwrite(F.cdata, sprintf('../resultats/resultatimage/%s_couleur.jpg',nomsFichiers));
    close(figure);
    
    %création des images avec ° pour debout et <| pour couché
    figure('visible', 'off')
    imshow(image)
    hold on
    for k = 1:length(SortieObjets)
        if SortieObjets(k).position =="debout"
            plot(SortieObjets(k).Barycentre(1),SortieObjets(k).Barycentre(2) , 'ko');
        else if SortieObjets(k).position =="couche"
                plot(SortieObjets(k).Barycentre(1),SortieObjets(k).Barycentre(2) , 'k<');
            else
                plot(SortieObjets(k).Barycentre(1),SortieObjets(k).Barycentre(2) , 'b*');
            end
        end
    end
    G = getframe ;
    % save the image:
    imwrite(G.cdata, sprintf('../resultats/resultatimage/%s_position.jpg',nomsFichiers));
    close(figure)
end