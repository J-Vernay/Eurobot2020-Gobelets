%% Projet Couleur P004 - Fort Bayard
clear all; close all;
if ~isfolder('../resultats')
    mkdir('../resultats');
end

% ////////////////////////////////////////////////////////////////
% ////////////////////////////////////////////////////////////////


%% Chargements des fichiers disponibles

% On ne rÃ©cupÃ¨re que les images qui ont une vÃ©ritÃ© terrain.
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


% ////////////////////////////////////////////////////////////////
% ////////////////////////////////////////////////////////////////

%% Chargement de la base d'image
Espace = 'lab';
fichiers = dir('../images/*.jpg');
dimensions = [ 480, 720, 3 ];

% 
% nbImages = length(fichiers);
% images = zeros([dimensions, nbImages]);
% 
% nomsFichiers = strings(nbImages,1);
% for i = 1:nbImages
%     fprintf('Chargement %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
%     images(:,:,:,i) = double(imread(strcat('../images/', fichiers(i).name))) / 255;
%     [~, nomsFichiers(i), ~] = fileparts(fichiers(i).name);
% end

%% Prétraitement

viderDossier('../resultats/pretraitement');
imagesPretraitees = zeros([ dimensions, nbImages]);
for i = 1:nbImages
    fprintf('Prétraitement %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    [imagesPretraitees(:,:,:,i),mask] = pretraitement(images(:,:,:,i), Espace);
    imwrite(imagesPretraitees(:,:,:,i), sprintf('../resultats/pretraitement/prtrt_%s.jpg', nomsFichiers(i)));
    imwrite(mask, sprintf('../resultats/pretraitement/mask_%s.png', nomsFichiers(i)));
    imwrite(~mask .* images(:,:,:,i), sprintf('../resultats/pretraitement/inv_%s.png', nomsFichiers(i)));
end

%% Extraction des caractéristiques

viderDossier('../resultats/caracteristiques');

caracteristiques = cell(nbImages, 1);

for i = 1:nbImages
    fprintf('Extraction %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    caracteristiques{i} = extraction(imagesPretraitees(:,:,:,i),Espace);
    writetable(struct2table(caracteristiques{i}), sprintf('../resultats/caracteristiques/%s.txt',nomsFichiers(i)));
end


%% Classification

viderDossier('../resultats/sortie');
dimensionimage=[480, 720];
comptErreur=0;
comptRouge=0;
comptVert=0;
comptFond=0;
for i = nbImages-1:nbImages-1
    fprintf('Classification %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    sortieObjets{i} = classification(caracteristiques{i},dimensionimage);
    writetable(struct2table(sortieObjets{i}),sprintf('../resultats/sortie/%s.txt',nomsFichiers(i)));
    figure;imagesc(imagesPretraitees(:,:,:,i));
    figure;imagesc(verites(:,:,:,i));
    figure;imagesc(images(:,:,:,i));
    
    [~,taille]= size( sortieObjets{i} );
    i
    for j = 1:taille
        coord = sortieObjets{i}(j).Barycentre;
        x = floor(coord(1));
        y = floor(coord(2));
        imageValidation = verites(:,:,:,i);
        if sortieObjets{i}(j).couleur =="rouge" && imageValidation(y,x,1)==1
            "rougeOK";
            comptRouge=comptRouge+1;
        elseif sortieObjets{i}(j).couleur =="vert" && imageValidation(y,x,2)==1
            "vertOK";
            comptVert=comptVert+1;
        elseif sortieObjets{i}(j).couleur =="fond" && imageValidation(y,x,2)==0 && imageValidation(y,x,1)==0
            "fondOK";
            comptFond=comptFond+1;
        else
            "erreur";
            coord
            comptErreur=comptErreur+1;

        end
    end

    
  
end
    
    comptErreur
    comptRouge
    comptVert
    comptFond
%% résultat sur image

viderDossier('../resultats/resultatimage');
for i = 1:nbImages
    fprintf('création images résultats %d/%d (%.1f%%)\n',i,nbImages, 100*(i-1)/nbImages);
    Resultatimage(sortieObjets{i},images(:,:,:,i),nomsFichiers(i));
    
end