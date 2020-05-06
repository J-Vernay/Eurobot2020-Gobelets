f=(imread('../images/capture32Detourée.bmp'));
figure(1)
imshow(f);
espaceUtilise = "rgb"; %"rgb","hsv","lab";

% idx = knanmeans(f,3);

%% //////////////////////////////////////////////////////////
%% //////////////////////////////////////////////////////////
 
%% Nuage de points 3D
% fr = f(:,:,1); fv = f(:,:,2); fb = f(:,:,3);
% figure(2), plot3(fr(:),fv(:),fb(:),'.'); grid('on')
% title('Nuage de points 3D');
% xlabel('Rouge'); ylabel('Vert'); zlabel('Bleu');
% 
% % Nuages projetés en 2D
% rv=zeros(256,256,3,'uint8');
% rb=zeros(256,256,3,'uint8');
% for i=1:size(f,1)
%     for j=1:size(f,2)
%         rv(256-f(i,j,2),f(i,j,1)+1,:)=f(i,j,:);
%         rb(256-f(i,j,3),f(i,j,1)+1,:)=f(i,j,:);
%     end
% end
% figure(3), imshow(rv);title('plan RV');
% xlabel('Rouge'); ylabel('Vert');
% figure(4), imshow(rb);title('plan RB');
% xlabel('Rouge'); ylabel('Bleu');


%% Classification et recupération des valeurs des pixels
[fs,centers]=tse_imkmeans(f,3,0.01);
figure(5); imshow(fs,[]);
Iclasse1 = uint8(fs==1) .* (f); % Fond
Iclasse2 = uint8(fs==2) .* (f);
Iclasse3 = uint8(fs==3) .* (f);

moyParCanalClasse2 = [ mean2(nonzeros(Iclasse2(:,:,1))), mean2(nonzeros(Iclasse2(:,:,2))), mean2(nonzeros(Iclasse2(:,:,3))) ];
moyParCanalClasse3 = [ mean2(nonzeros(Iclasse3(:,:,1))), mean2(nonzeros(Iclasse3(:,:,2))), mean2(nonzeros(Iclasse3(:,:,3))) ];
EcartTypeParCanalClasse2 = [ std2(nonzeros(Iclasse2(:,:,1))), std2(nonzeros(Iclasse2(:,:,2))), std2(nonzeros(Iclasse2(:,:,3))) ];
EcartTypeParCanalClasse3 = [ std2(nonzeros(Iclasse3(:,:,1))), std2(nonzeros(Iclasse3(:,:,2))), std2(nonzeros(Iclasse3(:,:,3))) ];

[moyParCanalClasse2 ; moyParCanalClasse3; EcartTypeParCanalClasse2;EcartTypeParCanalClasse3]


% % double(fs==2) .* ones(l,c,3);
% test1(:,:,1) = fs==1;
% test1(:,:,2) = fs==1;
% test1(:,:,3) = fs==1;
% Iclass2(test1==1)=NaN;
% Iclass1(Iclass1)=NaN;
% figure(6); imshow(Iclass2,[]);

%% //////////////////////////////////////////////////////////
%% //////////////////////////////////////////////////////////























[l,c,~]=size(f);
% Déterminer la couleur dans le domaine :
%RGB
if (espaceUtilise == "rgb")
f2(:,:,1) =  double(f(:,:,1))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
f2(:,:,2) =  double(f(:,:,2))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
f2(:,:,3) =  double(f(:,:,3))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
f3=f2;
for i = 1:l
    for j = 1:c
        if (f2(i,j,1)>0.5 && f2(i,j,2)<0.2 && f2(i,j,3)<0.2)
            f3(i,j,:) = [1,0,0];
        elseif (f2(i,j,1)<0.3 && f2(i,j,2)>0.3 && abs(f2(i,j,2)-f2(i,j,3))<0.25 )
            f3(i,j,:) = [0,1,0];
        else
            f3(i,j,:) = [NaN,NaN,NaN];
        end
    end
end
figure; imshow(f3,[]);
%HSV
elseif (espaceUtilise == "hsv")

f2 = rgb2hsv(f);
f3 = f2;
for i = 1:l
    for j = 1:c
        if (f2(i,j,1)>0.4 && f2(i,j,1)<0.6) && (f2(i,j,2)>0.5 && f2(i,j,3)>0.3)
            f3(i,j,:)=[0.4,1,1];
        elseif (f2(i,j,1)<0.1 || f2(i,j,1)>0.9) && f2(i,j,2)>0.5 && f2(i,j,3)>0.3
            f3(i,j,:)=[0,1,1];
        else
            f3(i,j,:) = [NaN,NaN,NaN];
        end
    end
end
f4 = hsv2rgb(f3);
figure; imshow(f4,[]);

%Lab
elseif (espaceUtilise == "lab")
%Inconvenient : moins restrictif que les précédents
f2 = rgb2lab(f);
f3 = f2;
for i = 1:l
    for j = 1:c
        if (f2(i,j,2)<0 && f2(i,j,1)>10)
            f3(i,j,:)=[60,-50,0];
        elseif (f2(i,j,2)>0.5 && f2(i,j,1)>10)
            f3(i,j,:)=[60,70,60];
        else
            f3(i,j,:) = [NaN,NaN,NaN];
        end
    end
end
f4 = lab2rgb(f3);
figure; imshow(f4,[]);
end



%% Extraction des autres caracteristiques

FBW = im2bw(f,0.145);
figure(2)
imshow(FBW);
s = strel('disk',1);
fbin3 = imopen(FBW,s);


fLabel=bwlabel(fbin3,4); 
figure(3);
imshow(fLabel,[]);colorbar; colormap jet;
Gobelets = struct("Circularite",0,"Aire",0,"Barycentre",0,"Orientation",0,"Perimetre",0,"couleur", "fond");   

for i = (1:max(max(fLabel)))
    
    circularite = regionprops(fLabel==i,'Circularity');
    ValeurCircularite = circularite.Circularity;
    
    Area = regionprops(fLabel==i,'Area');
    Aire = Area.Area;
    
    Centroid = regionprops(fLabel==i,'centroid');
    Barycentre = Centroid.Centroid;
    
    %     EquivDiameter = regionprops(fLabel,'EquivDiameter');
    
    Orientation = regionprops(fLabel==i,'Orientation');
    OrientationGobelet = Orientation.Orientation;
    
    Perimeter = regionprops(fLabel==i,'Perimeter');
    PerimetreGlobal = Perimeter.Perimeter;
    %     MaxFeretProperties = regionprops(fLabel,'MaxFeretProperties');
    %     MinFeretProperties = regionprops(fLabel,'MinFeretProperties');
    %      Caracteristiques = struct("Gobelet",i,"Caracteristiques",struct("Circularite",ValeurCircularite,"Aire",Aire,"Barycentre",Barycentre,"Orientation",OrientationGobelet,"Perimetre",PerimetreGlobal,"couleur", couleur));
    [coord]=floor(Barycentre);
    if (espaceUtilise == "rgb")
        % Code pour determiner la couleur du gobelet
        if f3(coord(2),coord(1),:) == [1,0,0]
            couleur = "rouge";
        elseif f3(coord(2),coord(1)) == [0,1,0]
            couleur = "rouge";
        else
            couleur = "fond";
        end
        
    elseif (espaceUtilise == "hsv")
        if f3(coord(2),coord(1)) == [0.4,1,1]
            couleur = "rouge";
        elseif f3(coord(2),coord(1)) == [0,1,1]
            couleur = "rouge";
        else
            couleur = "fond";
        end
        
    elseif (espaceUtilise == "lab")
        if f3(coord(2),coord(1)) == [60,-50,0]
            couleur = "rouge";
        elseif f3(coord(2),coord(1)) == [60,70,60]
            couleur = "rouge";
        else
            couleur = "fond";
        end
    end
    
    
    Caracteristiques = struct("Circularite",ValeurCircularite,"Aire",Aire,"Barycentre",Barycentre,"Orientation",OrientationGobelet,"Perimetre",PerimetreGlobal,"couleur", couleur);
    Gobelets = [Gobelets;Caracteristiques];
    
end

% Acceder aux données d'un gobelet: 
% Gobelets(i).Circularite
% Gobelets(i)
 
