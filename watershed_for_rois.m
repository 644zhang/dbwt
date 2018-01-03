functiondir=cd;
%x=imread('F:\segdata\test2\t21_3.tiff');
%x=imread('F:\segdata\labeldatazxy\trainy\trainy1.tiff');
imglen=1;
bound=cell(1,imglen);
center=cell(1,imglen);
mask=cell(1,imglen);
bound_small=cell(1,imglen);%small region that's to be growning
center_small=cell(1,imglen);
mask_small=cell(1,imglen);
rmset=cell(1,imglen);
smallobj=cell(1,imglen);  %smallobjcenter that needed to be complemented
diff_small=cell(1,imglen);%seeds that are needed to be growned importantly
folder={'wt2','wt3','wt4','wt41','wt5','wt51'};
lens=[180,55,200,200,289,288];
for j=1:length(folder)
    for ii=1:lens(j)
        m= imread(strcat('/home/zxy/dbwt/dbwtimg/',folder{j},'/re_',int2str(ii-1),'.tiff')); 
        m=255-m;
        bw=m;
        bw2 = ~bwareaopen(~bw,100,8);%�?连�?区域下，消除面积小于100的对象（小点�?%h=fspecial('sobel');%获得纵方向的sobel滤波算子，用于边缘提�?%fd=double(bw2);%double使数据变成双精度  
        D = -bwdist(~bw2); %距离变换�?%temp=-bwdist(im2);
        mask1 = imextendedmin(D,1.5); %imextendedmin函数确定小于某阈值的极小�? %test.jpg的阈值为0.95左右较好  %fcn1.png的阈值为0.0975左右 
        D2 = imimposemin(D,mask1);  
        Ld2 = watershed(D2);
        bw3 = bw2;
        bw3(Ld2 == 0) = 0;
        [Lbw4,numbw4]=bwlabeln(bw3);%把每个连通域贴上标签,Lbw4为贴标签之后的矩�?    
        stats=regionprops(bw3,'all');
        bw4 = ismember(Lbw4, find([stats.Area] >3));
        stats=regionprops(bw4,'all');
        areas=[stats.Area];
        [arearesult,areaindex]=sort(areas,'descend');
        rects=cat(1,stats.BoundingBox);
        zzd=zeros(length(stats),2);
        bound{ii}=zeros(length(stats),4);
        center{ii}=zeros(length(stats),2);
        mask{ii}=cell(1,length(stats));
        for i=1:length(stats)
            bound{ii}(i,:)=ceil(stats(i).BoundingBox);
            zzd(i,:)=stats(i).Centroid;
            center{ii}(i,:)=stats(i).Centroid;
            mask{ii}{i}=stats(i).Image;
        end
        zzdi=zzd;
        n=0;
        small=[];
        smalllocate=[];
        for i=1:length(stats)
            if stats(i).Area<600
                smalllocate=[smalllocate,i];
                if stats(i).Area<10
                    n=n+1;
                    small=[small,i];
                end
            end
        end
        distance_maxtrix= pdist2(zzd,zzd,'euclidean');
        DIST=distance_maxtrix;
        distance_maxtrix(find(distance_maxtrix==0))=[];
        n=0;
        for iter=1:1
            for i=1:size(zzd,1)-1
                for j=i+1:size(zzd,1)
                    if zzd(i,1)&&zzd(j,1)&&norm(zzd(i,:)-zzd(j,:))<max(distance_maxtrix)/mean(distance_maxtrix)*10
                        zzd(j,:)=[0,0];
                    end
                end
            end
        end
        rm=find(zzd(:,1)==0);
        small=[small,rm'];
        small=unique(small);
        rmset{ii}=small;
        full=1:length(stats);
        diff=setdiff(full,small);%the complement set
        diff_small{ii}=setdiff(smalllocate,small);  %return values whitch are in smalllocate but not in small(need to be removed)
        zzd(find(zzd(:,1)==0),:)=[];
        smallobj{ii}=center{ii}(diff_small{ii},:);
        bound_small{ii}=bound{ii}(diff,:);
        center_small{ii}=center{ii}(diff,:);
        for ij=1:length(diff)
            mask_small{ii}{ij}=mask{ii}{diff(ij)};
        
        end


        stats1=stats(diff);
        segimg=zeros(size(bw));

    end
    save(strcat(folder{j},'.mat'),'bound_small','mask_small','center_small','smallobj','center','bound','rmset','mask','smallobj','diff_small');
end
