% clear all
% close all
clc

Filt =  {'Axicon','Pyr'};

for i =1:2
Ffilter = Filt{i};
display(Ffilter)


name = ['13-Apr-2022Test_' Ffilter '_mod5'];
load(['./saveData/' name '.mat']);

if ~exist('zer');zer = zernike(2:size(sm,2)+1,'resolution',200).modes;end


figure(4);
if findstr(name,'Pyr')
    pup = (I_0/max(I_0(:)) >  .3); imagesc(pup); axis image
elseif findstr(name,'Axicon')
    pup = (I_0/max(I_0(:)) >  .1); imagesc(pup); axis image
end
sm_n = sm./sum(sm,1);
sp_n = sp./sum(sp,1);
I_0 = I_0/sum(I_0(:));

sp_n  = sp_n-I_0(:);
sm_n  = sm_n-I_0(:);
S = (sp_n-sm_n)*0.5/0.1;

h=figure(1);
h.Color = [1 1 1];
h.Position = [122 118 1212 587];
idx =floor(linspace(1,size(S,2),8))
for jdx = 1:length(idx)
subplot(2,4,jdx)
imagesc(reshape(S(:,idx(jdx)),size(I_0)).*pup);axis image;axis off
title(['mode = ' num2str(idx(jdx))]);
end


h=figure(2);colormap('jet')
h.Color = [1 1 1];
h.Position = [122 118 1212 572];
total = 6;
% pup = 1;
for idx = 1:total
subplot(3,total,idx);
imagesc(reshape(zer(:,idx),[200 200]),'AlphaData',reshape(zer(:,idx),[200 200])~=0);
axis image;axis off;title(['Zn = ' num2str(idx)])
if findstr(name,'Pyr')
    subplot(3,total,idx+total); imagesc(1.*reshape(S(:,idx),size(I_0)));axis image;axis off;
elseif findstr(name,'Axicon')
    subplot(3,total,idx+2*total);imagesc(1.*reshape(S(:,idx),size(I_0)));axis image;axis off;
end
end

%%
Tf1 = S'*S;
Tf2 = S(pup,:)'*S(pup,:);
if i == 1
    h=figure(3);
else
    h=figure(5);
end

colormap('jet')
h.Color = [1 1 1];
h.Position = [230 162 880 596];
subplot(221),imagesc(Tf1);axis image;title('Imat.*pupil')
subplot(222),imagesc(Tf2);axis image;title('Imat(pupil,:)')
subplot(2,2,[3 4]),
hold off;errorbar(diag(Tf1),std(Tf1-eye(size(Tf1)).*Tf1),'b-','LineWidth',2);
hold on; errorbar(diag(Tf2),std(Tf2-eye(size(Tf2)).*Tf2),'r-','LineWidth',2);
xlim([1 54])
legend(['Imat fullframe'],['Imat(pupil,:)']);title(Ffilter);



end