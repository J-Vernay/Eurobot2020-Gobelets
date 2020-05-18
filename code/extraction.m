function [Gobelets] = extraction(imagePretraitee,espaceUtilise)
% exemple de sortie
% il doit y avoir autant de "caracteristiques(N)" que de gobelets
% d�tect�s
% figure; subplot(1,2,1); imshow(imagePretraitee,[]);
img=rgb2gray(imagePretraitee);
moyenne=median(median(img));
img=img>moyenne; %Seuillage
% 
% for i=1:size(img,1)
%     for j=1:size(img,2)
%         if img(i,j)>moyenne
%             img(i,j)=1;%img(i,j);
%         else
%             img(i,j)=0;
%         end
%     end
% end
%  figure; subplot(1,2,1); imshow(img,[]);
%% Op�rations morphologiques
contourext=imdilate(img,strel('disk',1));
contourext=contourext-img;
lpe=imfill(contourext,'holes');
lpe=tse_imsplitobjects(logical(lpe));
lpe=imopen(lpe, strel('disk',4));
% subplot(1,2,2);imshow(lpe,[]);

f = lpe .* imagePretraitee;

%%
[l,c,~]=size(f);

%% //////////////////////////////////////////////////////////
%% //////////////////////////////////////////////////////////

%% Classification et recup�ration des valeurs des pixels
[fs,centers]=tse_imkmeans(f,3,0.01);
% figure(5); imshow(fs,[]);
if (espaceUtilise == "rgb")
    Iclasse1 = double(fs==1) .* (f); % Fond
    Iclasse2 = double(fs==2) .* (f);
    Iclasse3 = double(fs==3) .* (f);
    moyParCanalClasse2 = [ mean2(nonzeros(Iclasse2(:,:,1))), mean2(nonzeros(Iclasse2(:,:,2))), mean2(nonzeros(Iclasse2(:,:,3))) ]* 255;
    moyParCanalClasse3 = [ mean2(nonzeros(Iclasse3(:,:,1))), mean2(nonzeros(Iclasse3(:,:,2))), mean2(nonzeros(Iclasse3(:,:,3))) ]* 255;
    EcartTypeParCanalClasse2 = [ std2(nonzeros(Iclasse2(:,:,1))), std2(nonzeros(Iclasse2(:,:,2))), std2(nonzeros(Iclasse2(:,:,3))) ]* 255;
    EcartTypeParCanalClasse3 = [ std2(nonzeros(Iclasse3(:,:,1))), std2(nonzeros(Iclasse3(:,:,2))), std2(nonzeros(Iclasse3(:,:,3))) ]* 255;
    
elseif (espaceUtilise == "hsv")
    Iclasse1 = (double(fs==1) .* rgb2hsv(f)); % Fond
    Iclasse2 = (double(fs==2) .* rgb2hsv(f));
    Iclasse3 = (double(fs==3) .* rgb2hsv(f));
    %     Translation de H pour eviter la s�paration du rouge
    for i = 1:l
        for j = 1:c
            if fs(i,j)==1
                Iclasse1(i,j,:) = [NaN,NaN,NaN];
                Iclasse2(i,j,:) = [NaN,NaN,NaN];
                Iclasse3(i,j,:) = [NaN,NaN,NaN];
            elseif fs(i,j)==2
                Iclasse3(i,j,:) = [NaN,NaN,NaN];
            elseif fs(i,j)==3
                Iclasse2(i,j,:) = [NaN,NaN,NaN];
            elseif (f(i,j,1)==0 && f(i,j,2)==0 && f(i,j,3)==0 )
                Iclasse1(i,j,:) = [NaN,NaN,NaN];
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
    %     moyParCanalClasse2 = [ mean(mean(Iclasse2(:,:,1),"omitnan"),"omitnan"), mean(mean(Iclasse2(:,:,2),"omitnan"),"omitnan"), mean(mean(Iclasse2(:,:,3),"omitnan"),"omitnan") ];
    moyParCanalClasse2 = mean(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
    moyParCanalClasse3 = mean(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
    %     moyParCanalClasse3 = [  mean(mean(Iclasse3(:,:,1),"omitnan"),"omitnan"), mean(mean(Iclasse3(:,:,2),"omitnan"),"omitnan"), mean(mean(Iclasse3(:,:,3),"omitnan"),"omitnan") ];
    
    EcartTypeParCanalClasse2 = std(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
    EcartTypeParCanalClasse3 = std(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
    
elseif (espaceUtilise == "lab")
    Iclasse1 = (double(fs==1) .* rgb2lab(f)); % Fond
    Iclasse2 = (logical(fs==2) .* rgb2lab(f));
    Iclasse3 = (double(fs==3) .* rgb2lab(f));
    
    for i = 1:l
        for j = 1:c
            if fs(i,j)==1
                Iclasse1(i,j,:) = [NaN,NaN,NaN];
                Iclasse2(i,j,:) = [NaN,NaN,NaN];
                Iclasse3(i,j,:) = [NaN,NaN,NaN];
            elseif fs(i,j)==2
                Iclasse3(i,j,:) = [NaN,NaN,NaN];
            elseif fs(i,j)==3
                Iclasse2(i,j,:) = [NaN,NaN,NaN];
                
            elseif(f(i,j,1)==0 && f(i,j,2)==0 && f(i,j,3)==0 )
                Iclasse1(i,j,:) = [NaN,NaN,NaN];
                Iclasse2(i,j,:) = [NaN,NaN,NaN];
                Iclasse3(i,j,:) = [NaN,NaN,NaN];
            end
        end
    end
    
    pixelsClasse2 = reshape(Iclasse2, [], 3);
    pixelsClasse3 = reshape(Iclasse3, [], 3);
    %     moyParCanalClasse2 = [ mean(mean(Iclasse2(:,:,1),"omitnan"),"omitnan"), mean(mean(Iclasse2(:,:,2),"omitnan"),"omitnan"), mean(mean(Iclasse2(:,:,3),"omitnan"),"omitnan") ];
    moyParCanalClasse2 = mean(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
    moyParCanalClasse3 = mean(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
    %     moyParCanalClasse3 = [  mean(mean(Iclasse3(:,:,1),"omitnan"),"omitnan"), mean(mean(Iclasse3(:,:,2),"omitnan"),"omitnan"), mean(mean(Iclasse3(:,:,3),"omitnan"),"omitnan") ];
    
    EcartTypeParCanalClasse2 = std(pixelsClasse2(~isnan(pixelsClasse2(:, 1)),:));
    EcartTypeParCanalClasse3 = std(pixelsClasse3(~isnan(pixelsClasse3(:, 1)),:));
    
    
    
    % mean(mean(Iclasse2(:,:,1),"omitnan"),"omitnan")
end


[moyParCanalClasse2 ; moyParCanalClasse3; EcartTypeParCanalClasse2;EcartTypeParCanalClasse3];

%% //////////////////////////////////////////////////////////
%% //////////////////////////////////////////////////////////



% D�terminer la couleur dans le domaine :

%RGB
if (espaceUtilise == 'rgb')
    f2(:,:,1) =  double(f(:,:,1))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
    f2(:,:,2) =  double(f(:,:,2))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
    f2(:,:,3) =  double(f(:,:,3))./double(f(:,:,1)+f(:,:,2)+f(:,:,3));
%     f3=f2(:,:,1);
    f3 = zeros(size(f2,1),size(f2,2));
    f3( f2(:,:,1)>0.5 & f2(:,:,2)<0.2 & f2(:,:,3)<0.2) = 1; 
    f3( f2(:,:,1)<0.3 & f2(:,:,2)>0.3 & abs(f2(:,:,2)-f2(:,:,3))<0.25 ) = 2;

    for i = 1:l
        for j = 1:c
            if (f2(i,j,1)>0.5 && f2(i,j,2)<0.2 && f2(i,j,3)<0.2)
                f3(i,j,:) = 1;
            elseif (f2(i,j,1)<0.3 && f2(i,j,2)>0.3 && abs(f2(i,j,2)-f2(i,j,3))<0.25 )
                f3(i,j,:) = 2;
            else
                f3(i,j,:) = NaN;
            end
        end
    end
    
    
    
%     figure; imshow(f3,[]);
    
    
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
            
            if (f2(i,j,1)>0.5) && (f2(i,j,2)>0.5 && f2(i,j,3)>0.3)
                f3(i,j)=2;
            elseif (f2(i,j,1)<0.4) && f2(i,j,2)>0.5 && f2(i,j,3)>0.3
                f3(i,j)=1;
            else
                f3(i,j) = NaN;
            end
        end
    end
%     f4 = hsv2rgb(f3);
%     figure(101); imagesc(f4);
    
    %% Lab
elseif (espaceUtilise == 'lab')
    %Inconvenient : moins restrictif que les pr�c�dents
    f2 = rgb2lab(f);
%     f3 = f2;
    f3 = zeros(size(f2,1),size(f2,2));
    f3(-60 < f2(:,:,2) & f2(:,:,2) < 0 & -18 < f2(:,:,3) & f2(:,:,3) < 30) = 1; 
    f3(14 <f2(:,:,2) & f2(:,:,2) < 86 & -13 < f2(:,:,3) & f2(:,:,3) < 77) = 2;
%     for i = 1:l
%         for j = 1:c
%             if (  (f2(i,j,2)<86 && f2(i,j,2)>14) && (f2(i,j,3)<77 && f2(i,j,3)>-13) )
%                 f3(i,j,:)=2;
%             elseif ((f2(i,j,2)<0 && f2(i,j,2)>-60) && (f2(i,j,3)<30 && f2(i,j,3)>-18))
%                 f3(i,j,:)=1;
%             else
%                 f3(i,j,:) = NaN;
%             end
%         end
%     end
%     f4 = lab2rgb(f3);
%     figure; imagesc(f3);
end



%% Extraction des autres caracteristiques

FBW = im2bw(f,0.145);
% figure(2)
% imshow(FBW);
s = strel('disk',1);
fbin3 = imopen(FBW,s);


fLabel=bwlabel(fbin3,4);
% figure(3);
% imshow(fLabel,[]);colorbar; colormap jet;
Gobelets = struct('Circularite',0,'Aire',0,'Barycentre',0,'Orientation',0,'Perimetre',0,'couleur', "fond");

for i = (1:max(max(fLabel)))
    
    %circularite = regionprops(fLabel==i,'Circularity');
    %ValeurCircularite = circularite.Circularity;
    ValeurCircularite=0;
    
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
    
   
        if (f3(coord(2),coord(1)) == 1)
            couleur = "rouge";
        elseif (f3(coord(2),coord(1)) == 2)
            couleur = "vert";
        else
            couleur = "fond";
        end
  
    
    
    Caracteristiques = struct('Circularite',ValeurCircularite,'Aire',Aire,'Barycentre',Barycentre,'Orientation',OrientationGobelet,'Perimetre',PerimetreGlobal,'couleur', couleur);
    Gobelets = [Gobelets;Caracteristiques];
    
end







end

