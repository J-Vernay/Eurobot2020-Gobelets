f=imread('../images/capture201.jpg');
figure(1)
imshow(f);

% idx = kmeans(f,3);







FBW = im2bw(f,0.145);
figure(2)
imshow(FBW);
s = strel('disk',1);
fbin3 = imopen(FBW,s);


fLabel=bwlabel(fbin3,4); 
figure(3);
imshow(fLabel,[]);colorbar; colormap jet;
Gobelets = struct("Circularite",0,"Aire",0,"Barycentre",0,"Orientation",0,"Perimetre",0);   

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
%      Caracteristiques = struct("Gobelet",i,"Caracteristiques",struct("Circularite",ValeurCircularite,"Aire",Aire,"Barycentre",Barycentre,"Orientation",OrientationGobelet,"Perimetre",PerimetreGlobal));   
Caracteristiques = struct("Circularite",ValeurCircularite,"Aire",Aire,"Barycentre",Barycentre,"Orientation",OrientationGobelet,"Perimetre",PerimetreGlobal);   
Gobelets = [Gobelets;Caracteristiques];
end

% Acceder aux données d'un gobelet: 
% Gobelets(i).Circularite
% Gobelets(i)
 
