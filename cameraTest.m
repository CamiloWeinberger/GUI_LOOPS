%% camera     display('owowowo');
v = videoinput('gige', 1, 'Mono12');
s = v.Source;
s.FrameRate = 30;
s.Offset = 0;  
s.PacketSize = 9000;

s.Gain = 256;
app.cameraMem = s;
%%
s.FrameRate = 100;
s.Exposure = 2000;
v.FramesPerTrigger = inf;
freq = 64;
stop(v);
start(v);
steps = 128;
idx = 1;
while 1
% v.FramesAvailable
if v.FramesAvailable >= steps
data1 = getdata(v, steps);
data(:,:,idx)  = sum(data1,4);
idx = idx+1
% imagesc(data);axis image
end
end
