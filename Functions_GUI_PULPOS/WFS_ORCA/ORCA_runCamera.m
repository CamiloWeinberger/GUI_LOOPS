%% Run camera for alignment
nIter = 50000;
nFrames = 1;
threshold = 100;
% Size of one quadrant
nq = size(im_dark,1)/2;
x0 = nq+0.5;
y0 = nq+0.5;
[X,Y] = meshgrid(1:2*nq,1:2*nq);
amp = -10;

for n=1:nIter
    amp = -amp; %slm_pupil.phasemap = TIP*amp; pause(1/45);
    posx = 160;
    posy = 125;
%     sqare = 900;
    frame = grabHamamatsuFrame(cam,im_dark,1);
%     frame = frame(posy:posy+sqare,posx:posx+sqare);
%     subplot(2,3,[1 2 4 5])
figure(123)
    imagesc(frame);
    axis square tight;
    colorbar() ;
    title(sprintf('frame #%g of %g',n,nIter))
    colormap(hot)
    drawnow limitrate
    disp(sum(frame(:)))
%     xp = sum(sum(X.*frame))/sum(sum(frame))-x0;
%     yp = sum(sum(Y.*frame))/sum(sum(frame))-y0;
%     
%     subplot(2,3,3)
%     pyramidCentring(xp,yp,20)
%     drawnow limitrate
%     
%     subplot(2,3,6)
%     F=.9*ones(1,240);
%     F(frame(120,:)<threshold)=0;
%     plot(F)
%     hold on
%     F=.9*ones(240,1);
%     F(frame(:,120)<threshold)=0;
%     plot(F)
%     plot([120 120],[0 1])
%     hold off
%     drawnow limitrate
    %figure(1);plot(diag(frame));ylim([-6.5 -3]*1e04);xlim([0 3000]);drawnow;

    
end