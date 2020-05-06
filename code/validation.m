%% Projet Couleur P004 - Fort Bayard
%% Script de validation
 
if ~isfolder('../resultats')
    mkdir('../resultats');
end

%% Chargements des fichiers disponibles

% On ne récupère que les images qui ont une vérité terrain.
fichiers = dir('../verite_terrain/*.png');
dimensions = [ 480, 720, 3 ];
nbImages = length(fichiers);
images = zeros([dimensions, nbImages]);
verites = zeros([dimensions, nbImages]);
nomsFichiers = strings(nbImages,1);

for i = 1:nbImages
    fprintf('Chargement %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    [~, nomsFichiers(i), ~] = fileparts(fichiers(i).name);
    images(:,:,:,i) = double(imread(sprintf('../images/%s.jpg', nomsFichiers(i)))) / 255;
    verites(:,:,:,i) = double(imread(sprintf('../verite_terrain/%s.png', nomsFichiers(i)))) / 255;
end
Espaces = { 'rgb', 'hsv', 'lab' };

Resultats = table('Size',[nbImages*length(Espaces),7], ...
       'VariableTypes', { 'string', 'string', 'uint64', 'uint64', 'uint64', 'uint64', 'double' }, ...
       'VariableNames', { 'NomImage', 'EspaceCouleur', 'PreTr_VN', 'PreTr_FN', 'PreTr_FP', 'PreTr_VP', 'PreTr_Jaccard' });

%% Test du prétraitement

iter = 0;
for i = 1:nbImages    
    for i_espace = 1:length(Espaces)
        iter = iter + 1;
        espace = Espaces{i_espace};
        
        fprintf('%s %s (%.1f%%)\n', nomsFichiers(i), espace, 100*(iter-1)/(nbImages*length(Espaces)));
        
        [~, masque] = pretraitement(images(:,:,:,i), espace);
        
        % Les gobelets ont un de leurs canaux à 1 (canal rouge ou vert)
        % tandis que les pixels du fond ont tous leurs canaux à 0
        binverite = max(verites(:,:,:,i),[],3) == 1; 
        
        
        % Les différences à 1 pixel près n'ont pas d'importance pour nous,
        % car cela veut juste dire que le prétraitement a considéré un peu
        % moins large que la vérité terrain par exemple, ce qui n'est pas
        % directement en lien avec le prétraitement en lui-même.
        % C'est pourquoi on fait une ouverture pour enlever ces
        % micro-différences.
        differences = binverite ~= masque;
        differencesNotables = imopen(differences, strel('disk',2));
        pxAGarder = differences == differencesNotables; % matrice qui vaut 1 sauf quand différences pas notables
        
        M = matConfusion(binverite, masque, pxAGarder);
        
        Jaccard = M(2,2) / (M(1,2) + M(2,1) + M(2,2));
        
        
        Resultats(iter,:) = { nomsFichiers(i), espace, M(1,1), M(1,2), M(2,1), M(2,2), Jaccard };
    end
end

Resultats