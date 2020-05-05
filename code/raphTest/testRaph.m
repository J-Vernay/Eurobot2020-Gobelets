clear all;
close all;
%%

for i=1:21
    image=imagesPretraitees(:,:,:,i);
    figure; subplot(1,2,1); imshow(image,[]);
   %%
    img=rgb2gray(image);
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
    contourext=imdilate(img,strel('disk',5));
    contourext=contourext-img;
    %figure(6),imshow(contourext,[]);
    
    lpe=imfill(contourext,'holes');
    %lpe=imclearborder(lpe);
    lpe=tse_imsplitobjects(logical(lpe));
    subplot(1,2,2);imshow(lpe,[]);

end
