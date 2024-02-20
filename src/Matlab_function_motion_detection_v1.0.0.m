function GetMotion(PathVideo)
% Filter out all still sequences from a set of video files and create a
% summary video including only the detected motion sequences.
% 
% PathVideo The path to the folder which contain the mp4 video files to
% process.
%
% Citation:
% Droissart V., Azandi L., Onguene E. R., Savignac M.,  Smith T.B., Deblauwe
% V. 2021. A low cost, modular, open-source camera trap system to study
% plant-insect interactions. Methods in Ecology and Evolution
% 

VideoList = dir(fullfile(PathVideo,'\*.mp4')); % list all mp4 files in PathVideo
Tresh=3; % rms treshold above which a frame is detected as motion (6 with red band)
Buffer=1; % number of seconds to keep before and after detection.

% Get area to inspect
ThisVideoID=min(10,size(VideoList,1));
ThisVideo = VideoReader(fullfile(VideoList(ThisVideoID).name));
FrameRate=ThisVideo.FrameRate;
disp(['Video Framerate is ',num2str(FrameRate),' frames/s']);
tmp = readFrame(ThisVideo);
h=figure('position',1.0e+03 *[0.0314 0.1058 1.2360 0.6560]);
imagesc(tmp),axis image,title('Please, left-click on two corner of the area of analysis')
[x,y] = ginput(2); % require user input
x=round(sort(x));y=round(sort(y));
close(h);
AOI=false(ThisVideo.Height,ThisVideo.Width); % Area of analysis (user defined)
AOI(y(1):y(2),x(1):x(2))=true;
AOIn=sum(AOI(:)); % number of elements in AOI

% Initialize the final video file
if exist(fullfile(PathVideo,'SummaryVideo.mp4'), 'file') == 2 % if summary video file already exists
    delete(fullfile(PathVideo,'SummaryVideo.mp4')) % remove the file
end
MergedVideo = VideoWriter(fullfile(PathVideo,'SummaryVideo'),'MPEG-4'); % mp4 is both the fastest to write and the highest compression rate
MergedVideo.FrameRate=FrameRate;
open(MergedVideo);
FrameID3=0; % number of frames recorded in MergedVideo

for ThisVideoID=1:size(VideoList,1) % for each video
  disp([datestr(now),' Loading ',VideoList(ThisVideoID).name,' ',num2str(ThisVideoID),'/',num2str(size(VideoList,1)),' Frame ',num2str(FrameID3)])
  
  % Read the first frame
  FrameID=1; % this is the frame ID of tmp
  ThisVideo = VideoReader(fullfile(VideoList(ThisVideoID).name));
  BufferFrames=round(Buffer*ThisVideo.FrameRate); % number of frames to take before and after detection
  tmp = readFrame(ThisVideo);
  tmp = insertText(tmp,[0 0],[VideoList(ThisVideoID).name,' ',datestr(datetime(0,0,0,0,0,FrameID/ThisVideo.FrameRate),'HH:MM:SS')],'TextColor','white','FontSize',15,'BoxOpacity',0.2);
   
  % Initialize variables
  FrameID2=BufferFrames*2; % frame ID since last detected motion
  BufferVideo=zeros([ThisVideo.Height,ThisVideo.Width,3,BufferFrames],'uint8'); % buffer: the last BufferFrames frames
  
  % Read the video
  while hasFrame(ThisVideo)
    % write the frame in the buffer
    id=mod(FrameID-1,BufferFrames)+1; % linear index of the frame tmp
    BufferVideo(:,:,:,id)=tmp;
    BufferVideoInd=[id:-1:1,BufferFrames:-1:id+1];
    % read the new frame
    tmp2 = readFrame(ThisVideo);
    tmp2 = insertText(tmp2,[0 0],[VideoList(ThisVideoID).name,' ',datestr(datetime(0,0,0,0,0,FrameID/ThisVideo.FrameRate),'HH:MM:SS')],'TextColor','white','FontSize',15,'BoxOpacity',0.2);
    
    if FrameID2<BufferFrames % if a motion has been detected recently
      writeVideo(MergedVideo,tmp2);
      FrameID3=FrameID3+1; 
      % Compute diference
      diff1=tmp2(:,:,3)-tmp(:,:,3);
      diff1=diff1(AOI); % only keep user sellected area
      diff2=rms(diff1);
      % Detect motion
      if diff2>Tresh && FrameID>ThisVideo.FrameRate
        FrameID2=1;
      else
        FrameID2=FrameID2+1;
      end
    elseif FrameID2==BufferFrames*2 % if a motion has not been detected recently
      % Compute diference
      diff1=tmp2(:,:,3)-tmp(:,:,3);
      diff1=diff1(AOI); % only keep user sellected area
      diff2=rms(diff1);
      % Detect motion
      if diff2>Tresh && FrameID>ThisVideo.FrameRate % if a motion is detected
        disp(['Frame ',num2str(FrameID),', Amplitude = ',num2str(diff2)])
        % record previous frames
        if FrameID<=BufferFrames % if the buffer is not yet full
          writeVideo(MergedVideo,BufferVideo(:,:,:,fliplr(id:-1:1)));
          FrameID3=FrameID3+id;
        else
          writeVideo(MergedVideo,BufferVideo(:,:,:,fliplr(BufferVideoInd)));
          FrameID3=FrameID3+length(BufferVideoInd);
        end
        FrameID2=1;
      end
    else
      FrameID2=FrameID2+1;
    end
    tmp=tmp2;
    FrameID=FrameID+1;
  end
end
close(MergedVideo)
disp([datestr(now),' Done - Frame ',num2str(FrameID3)])
