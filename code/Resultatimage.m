function [] = Resultatimage(SortieObjets,image,nomsFichiers)
    % cr�ation d'image pour v�rifier visuellement les r�aultats
    % Entr�e: vecteurs d'informations de potentiels gobelets
    % Sortie: vecteurs des gobelets exp�rimentaux et leurs
    %caract�ristiques
    

    %cr�ation des images avec des * pour rouge et des + pour vert
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
    
    %cr�ation des images avec � pour debout et <| pour couch�
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