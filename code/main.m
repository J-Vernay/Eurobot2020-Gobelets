%% Projet Couleur P004 - Fort Bayard
 
if ~isfolder('../resultats')
    mkdir('../resultats');
end

%% Chargement de la base d'image

fichiers = dir('../images/*.jpg');
dimensions = [ 480, 720, 3 ];
nbImages = length(fichiers);
images = zeros([dimensions, nbImages]);

nomsFichiers = strings(nbImages,1);
for i = 1:nbImages
    fprintf('Chargement %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    images(:,:,:,i) = double(imread(strcat('../images/', fichiers(i).name))) / 255;
    [~, nomsFichiers(i), ~] = fileparts(fichiers(i).name);
end

%% Prétraitement

viderDossier('../resultats/pretraitement');
imagesPretraitees = zeros([ dimensions, nbImages]);
for i = 1:nbImages
    fprintf('Prétraitement %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    [imagesPretraitees(:,:,:,i),mask] = pretraitement(images(:,:,:,i), 'rgb');
    imwrite(imagesPretraitees(:,:,:,i), sprintf('../resultats/pretraitement/%s.jpg', nomsFichiers(i)));
    imwrite(mask, sprintf('../resultats/pretraitement/_mask_%s.png', nomsFichiers(i)));
end

%% Extraction des caractéristiques

viderDossier('../resultats/caracteristiques');

caracteristiques = cell(nbImages, 1);

for i = 1:nbImages
    fprintf('Extraction %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    caracteristiques{i} = extraction(imagesPretraitees(:,:,i));
    writetable(struct2table(caracteristiques{i}), sprintf('../resultats/caracteristiques/%s.txt',nomsFichiers(i)));
end


%% Classification

viderDossier('../resultats/sortie');
dimensionimage=[480, 720];
for i = 1:nbImages
    fprintf('Classification %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    sortieObjets = classification(caracteristiques{i},dimensionimage);
    writetable(struct2table(sortieObjets),sprintf('../resultats/sortie/%s.txt',nomsFichiers(i)));
end
