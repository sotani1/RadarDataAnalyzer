%v = VideoReader('2017_J72A_ADAS_US_0310_1336.avi');
currAxes = axes;
%while hasFrame(v)
%    vidFrame = readFrame(v);
%    image(vidFrame, 'Parent', currAxes);
%    currAxes.Visible = 'off';
%    pause(1/v.FrameRate);
%end
%xyloObj = VideoReader('2017_J72A_ADAS_US_0310_1336.avi');
xyloObj = v;

vidWidth = xyloObj.Width;
vidHeight = xyloObj.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

k = 1;
while hasFrame(xyloObj)
    mov(k).cdata = readFrame(xyloObj);
    k = k+1;
end

hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);

movie(hf,mov,1,xyloObj.FrameRate);
