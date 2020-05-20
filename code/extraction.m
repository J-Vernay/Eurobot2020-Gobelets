function [Gobelets] = extraction(imagePretraitee,espaceUtilise,FlagStatistiques)
if nargin<3
    FlagStatistiques = 0;
end
% il doit y avoir autant de "caracteristiques(N)" que de gobelets
% détectés
img=rgb2gray(imagePretraitee);
moyenne=median(median(img));
img=img>moyenne; %Seuillage

%% Opérations morphologiques
contourext=imdilate(img,strel('disk',1));
contourext=contourext-img;
lpe=imfill(contourext,'holes');
lpe=tse_imsplitobjects(logical(lpe));
lpe=imopen(lpe, strel('disk',4));

f = lpe .* imagePretraitee;

%%
[l,c,~]=size(f);

%% Classification et recupération des valeurs des pixels
if (FlagStatistiques==1)
    [fs,~]=tse_imkmeans(f,3,0.01);
    if (espaceUtilise == "rgb")
        Iclasse2 = double(fs==2) .* (f);
        Iclasse3 = double(fs==3) .* (f);
        moyParCanalClasse2 = [ mean2(nonzeros(Iclasse2(:,:,1))), mean2(nonzeros(Iclasse2(:,:,2))), mean2(nonzeros(Iclasse2(:,:,3))) ]* 255;
        moyParCanalClasse3 = [ mean2(nonzeros(Iclasse3(:,:,1))), mean2(nonzeros(Iclasse3(:,:,2))), mean2(nonzeros(Iclasse3(:,:,3))) ]* 255;
        EcartTypeParCanalClasse2 = [ std2(nonzeros(Iclasse2(:,:,1))), std2(nonzeros(Iclasse2(:,:,2))), std2(nonzeros(Iclasse2(:,:,3))) ]* 255;
        EcartTypeParCanalClasse3 = [ std2(nonzeros(Iclasse3(:,:,1))), std2(nonzeros(Iclasse3(:,:,2))), std2(nonzeros(Iclasse3(:,:,3))) ]* 255;
        
    elseif (espaceUtilise == "hsv")
        Iclasse2 = (double(fs==2) .* rgb2hsv(f));
        Iclasse3 = (double(fs==3) .* rgb2hsv(f));
        %     Translation de H pour eviter la séparation du rouge entre 0 et 1
        for i = 1:l
            for j = 1:c
                if fs(i,j)==1
                    Iclasse2(i,j,:) = [NaN,NaN,NaN];
                    Iclasse3(i,j,:) = [NaN,NaN,NaN];
                elseif fs(i,j)==2
                    Iclasse3(i,j,:) = [NaN,NaN,NaN];
                elseif fs(i,j)==3
                    Iclasse2(i,j,:) = [NaN,NaN,NaN];
                elseif (f(i,j,1)==0 && f(i,j,2)==0 && f(i,j,3)==0 )
                    Iclasse2(i,j,:) = [NaN,NaN,NaN];
                    Iclasse3(i,j,:) = [NaN,NaN,NaN];
                else
                    if (Iclasse2(i,j,3)>0.2 && Iclasse2(i,j,1) < 0.8 )
                        Iclasse2(i,j,1) = Iclasse2(i,j,1) + 0.2;
                    elseif (Iclasse2(i,j,3)>0.2 && Iclasse2(i,j,1) > 0.8)
                        Iclasse2(i,j,1) = 1 - Iclasse2(i,j,1);
                    end
                    if (Iclasse3(i,j,3)>0.2 && Iclasse3(i,j,1) < 0.8 )
                        Iclasse3(i,j,1) = Iclasse3(i,j,1) + 0.2;
                    elseif (Iclasse3(i,j,3)>0.2 && Iclasse3(i,j,1) > 0.8)
                        Iclasse3(i,j,1) = 1 - Iclasse3(i,j,1);
                    end
                    
                end
            end
        end
        
        pixelsClasse2 = reshape(Iclasse2, [], 3);
        pixelsClasse3 = reshape(Iclasse3, [], 3);
        moyParCanalClasse2 = mean(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
        moyParCanalClasse3 = mean(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
        EcartTypeParCanalClasse2 = std(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
        EcartTypeParCanalClasse3 = std(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
        
    elseif (espaceUtilise == "lab")
        Iclasse2 = (logical(fs==2) .* rgb2lab(f));
        Iclasse3 = (double(fs==3) .* rgb2lab(f));
        
        f0 = f(:,:,1) == 0 & f(:,:,2) == 0 & f(:,:,3) == 0;
        
        Iclasse2(fs == 1 | fs == 3 | f0) = [NaN,NaN,NaN];
        Iclasse3(fs == 1 | fs == 2 | f0) = [NaN,NaN,NaN];
        
        pixelsClasse2 = reshape(Iclasse2, [], 3);
        pixelsClasse3 = reshape(Iclasse3, [], 3);
        moyParCanalClasse2 = mean(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
        moyParCanalClasse3 = mean(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
        
        EcartTypeParCanalClasse2 = std(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
        EcartTypeParCanalClasse3 = std(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
        
        
    end
    
    % Affichage pour recupération des statistiques
    [moyParCanalClasse2 ; moyParCanalClasse3; EcartTypeParCanalClasse2;EcartTypeParCanalClasse3]
end

% Déterminer la couleur dans le domaine :

%RGB
if (espaceUtilise == 'rgb')
    f2(:,:,1) =  double(f(:,:,1))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
    f2(:,:,2) =  double(f(:,:,2))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
    f2(:,:,3) =  double(f(:,:,3))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
    f3 = zeros(size(f2,1),size(f2,2));
    f3( f2(:,:,1)>0.35 & f2(:,:,2)<0.35 & f2(:,:,3)<0.35) = 1;
    f3( f2(:,:,1)<0.3 & f2(:,:,2)>0.3 & f2(:,:,3)>0.2 ) = 2;
    
%HSV
elseif (espaceUtilise == "hsv")
    
    f2 = rgb2hsv(f);
    f3 = f2(:,:,1);
    
    
    for i = 1:l
        for j = 1:c
            if ( f2(i,j,1) < 0.8 )
                f2(i,j,1) = f2(i,j,1) + 0.2;
            elseif (f2(i,j,1) > 0.8)
                f2(i,j,1) = 1 - f2(i,j,1);
            end
            
            if ((0.7 <f2(:,:,1)) & (f2(:,:,1) < 0.9)  & (f2(i,j,3)>0.3) )
                f3(i,j)=2;
            elseif ((0.5 <f2(:,:,1)) & (f2(:,:,1) < 0.7)  & (f2(i,j,3)>0.3) )
                f3(i,j)=1;
            else
                f3(i,j) = NaN;
            end
        end
    end
    
    
    f3 = zeros(size(f2,1),size(f2,2));
    f3( (0.5 <f2(:,:,2)) & (f2(:,:,2) < 0.7)  & (f2(i,j,3)>0.3)) = 1;
    f3( (0.7 <f2(:,:,2)) & (f2(:,:,2) < 0.9)  & (f2(i,j,3)>0.3)) = 2;
    
%% Lab
elseif (espaceUtilise == "lab")
    %Inconvenient : moins restrictif que les précédents
    f2 = rgb2lab(f);
    f3 = zeros(size(f2,1),size(f2,2));
    f3(14 <f2(:,:,2) & f2(:,:,2) < 86 & -13 < f2(:,:,3) & f2(:,:,3) < 77) = 1;
    f3(-60 < f2(:,:,2) & f2(:,:,2) < 0 & -18 < f2(:,:,3) & f2(:,:,3) < 30) = 2;
end

%% Extraction des autres caracteristiques

FBW = im2bw(f,0.145);

s = strel('disk',1);
fbin3 = imopen(FBW,s);


fLabel=bwlabel(fbin3,4);

Gobelets = struct('Aire',0,'Barycentre',0,'Orientation',0,'Perimetre',0,'couleur', "fond");

for i = (1:max(max(fLabel)))
    %Circularité non utilisée car l'option n'existait pas sur les versions
    %anterieures de matlab.
    Area = regionprops(fLabel==i,'Area');
    Aire = Area.Area;
    
    Centroid = regionprops(fLabel==i,'centroid');
    Barycentre = Centroid.Centroid;
    
    
    Orientation = regionprops(fLabel==i,'Orientation');
    OrientationGobelet = Orientation.Orientation;
    
    Perimeter = regionprops(fLabel==i,'Perimeter');
    PerimetreGlobal = Perimeter.Perimeter;
    
    [coord]=floor(Barycentre);
    
    
    if (f3(coord(2),coord(1)) == 1)
        couleur = "rouge";
    elseif (f3(coord(2),coord(1)) == 2)
        couleur = "vert";
    else
        couleur = "fond";
    end
    
    
    
    Caracteristiques = struct('Aire',Aire,'Barycentre',Barycentre,'Orientation',OrientationGobelet,'Perimetre',PerimetreGlobal,'couleur', couleur);
    Gobelets = [Gobelets;Caracteristiques];
    
end

end

