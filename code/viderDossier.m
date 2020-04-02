function [] = viderDossier(cheminDossier)
%VIDERDOSSIER Vide le dossier spécifié ou le crée s'il n'existe pas
% PS : n
    if isdir(cheminDossier)
        fichiers = dir(cheminDossier);
        for k = 1:length(fichiers)
            if ~fichiers(k).isdir
                delete(fullfile(cheminDossier, fichiers(k).name));
            end
        end
    else
        mkdir(cheminDossier);
    end
end

