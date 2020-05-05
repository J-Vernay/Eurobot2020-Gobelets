function [caracteristiques] = extraction(imagePretraitee)
    % exemple de sortie
    % il doit y avoir autant de "caracteristiques(N)" que de gobelets
    % détectés
     figure; subplot(1,2,1); imshow(imagePretraitee,[]);
   %%
    img=rgb2gray(imagePretraitee);
    moyenne=median(median(img));
    for i=1:size(img,1)
        for j=1:size(img,2)
            if img(i,j)>moyenne
                img(i,j)=1;%img(i,j);
            else
                img(i,j)=0;
            end
        end
    end
    img=imopen(img,strel('disk',3));
    
    %% Opérations morphologiques
    contourext=imdilate(img,strel('disk',3));
    contourext=contourext-img;
    %figure(6),imshow(contourext,[]);
    
    lpe=imfill(contourext,'holes');
    %lpe=imclearborder(lpe);
    lpe=tse_imsplitobjects(logical(lpe));
    subplot(1,2,2);imshow(lpe,[]);
%%   
    caracteristiques(1).x = 20;
    caracteristiques(1).y = 30;
    caracteristiques(1).teinteMoyenne = 0;
    
    caracteristiques(2).x = 50;
    caracteristiques(2).y = 120;
    caracteristiques(2).teinteMoyenne = 0.333;
end

