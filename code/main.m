%% Projet Couleur P004 - Fort Bayard
 

%% Chargement de la base d'image

fichiers = dir('../images/*.jpg');
dimensionsEntree = [ 1944, 2592, 3 ];
nbImages = length(fichiers);
images = zeros([dimensionsEntree, nbImages]);

nomsFichiers = strings(nbImages,1);
for i = 1:nbImages
    images(:,:,:,i) = double(imread(strcat('../images/', fichiers(i).name))) / 255;
    [~, nomsFichiers(i), ~] = fileparts(fichiers(i).name);
end

%% Prétraitement

viderDossier('../resultats/pretraitement');

dimensionsApresPretraitement = [ 480, 720, 3 ];
imagesPretraitees = zeros([ dimensionsApresPretraitement, nbImages]);
for i = 1:nbImages
    imagesPretraitees(:,:,:,i) = pretraitement(images(:,:,:,i), 'rgb');
    imwrite(imagesPretraitees(:,:,:,i), sprintf('../resultats/pretraitement/%s.png', nomsFichiers(i)));
end

%% Extraction des caractéristiques

viderDossier('../resultats/caracteristiques');

caracteristiques = cell(nbImages, 1);

for i = 1:nbImages
    caracteristiques{i} = extraction(imagesPretraitees(:,:,i));
    writetable(struct2table(caracteristiques{i}), sprintf('../resultats/caracteristiques/%s.txt',nomsFichiers(i)));
end


%% Classification

viderDossier('../resultats/sortie');

for i = 1:nbImages
    sortieObjets = classification(caracteristiques{i});
    writetable(struct2table(sortieObjets),sprintf('../resultats/sortie/%s.txt',nomsFichiers(i)));
end
