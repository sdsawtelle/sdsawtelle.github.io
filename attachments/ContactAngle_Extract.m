function main()
% uses image analysis toolbox.

clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%      EDIT ME        %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


path='C:\Users\Sonya\Documents\My Box Files\MolT Project\150930_contactangle_baregold_glovebox\';
imtype='bmp';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path);
names=dir(strcat(path,'*.',imtype));

for i=1:length(names)
    
    close all;
    [pathstr,name,ext] = fileparts(names(i).name);
    I = imread(names(i).name);
    H = imshow(I);
    hold on;

    xs=zeros(3);
    ys=zeros(3);
   
    % obtain the three points: ordering is important!!!!!! First
    % point should be the leftmost reflection point. Second point should be
    % any point on the droplet edge circle. Third point should be rightmost
    % reflection point. before selecting each point you have the option to
    % zoom in as much as you like, then hit the enter button to cancel the
    % zoom functionality and select the point
   
    for j=1:3
        zoom on;   % use mouse button to zoom in or out
        % Press Enter to get out of the zoom mode.
        % CurrentCharacter contains the most recent key which was pressed after opening
        % the figure, wait for the most recent key to become the return/enter key
        waitfor(gcf,'CurrentCharacter',13)
        zoom off
        % get a point 
        [xs(j),ys(j)]=ginput(1);
        % reset the current character for the next zoom interaction
        set(gcf,'currentch',char(1))
        % reset the image to the full zoomed out view
        zoom out;
    end
    
    
    % matlab default for images is inverted y-axis (since pixel "#1" is on
    % top line) so use negative of the y-values for actual mathematically
    % manipulated points (because axes have handedness). also create the points "im_" for mapping back to the
    % true image coordinates. 
    im_p1 = [xs(1) ys(1) 0];
    im_p2 = [xs(2) ys(2) 0];
    im_p3 = [xs(3) ys(3) 0];

    p1 = [ys(1) xs(1) 0];
    p2 = [ys(2) xs(2) 0];
    p3 = [ys(3) xs(3) 0];

    
    %Find the center and radius of the circle defined by the three points
    t = p2-p1; u = p3-p1; v = p3-p2;
    w = cross(t,u);
    t2 = sum(t.^2); u2 = sum(u.^2); w2 = sum(w.^2);
    c = p1+(t2*sum(u.*v)*u-u2*sum(t.*v)*t)/(2*w2);
    r = 1/2*sqrt(t2*u2*sum(v.^2)/w2);


    % translate coordinate system so that center of circle is at 0,0,0
    p1_trans = p1 - c;
    p2_trans = p2 - c;
    p3_trans = p3 - c;


    %Use the Alternate Segment Theorem to get the angle between this chord
    %and the tangent line to this circle
    chordlength = norm(p1-p3);
    theta = asin(chordlength/(2*r));
    thetadeg(i) = theta*180/pi;

    
    % Draw the chord and tangent lines for verification by eye - note that
    % drawing must happen in the native image axis so swap the x and y
    % coordinates.
    chord = p3-p1 %make the chord vector
    rotmatrix = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1]; % make the tangent vector by rotating the chord vector by the contact angle!
    tangent = rotmatrix*transpose(chord)  % rotate the chord by the contact angle
    tangentpoint = tangent + transpose(p1) % then translate the tangent vector over so that it begins at point p1
    % first point for drawing chord is point p1
    % second point for drawing chord is p3
    line([im_p1(1),im_p3(1)],[im_p1(2),im_p3(2)],'Color','r','LineWidth',2); %chord
    % first point for drawing tangent is p1
    % second pt for drawing tangent is p1 + tangent vector = tangentpoint
    line([p1(2),tangentpoint(2)],[p1(1),tangentpoint(1)],'Color','r','LineWidth',2); %tangent
    
    % now draw the inferred circle (using the stupid image default y-axis)
    hold on;
    circle(c(2),c(1),r);
    
    % write out the contact angle on the figure
    mTextBox=annotation('textbox',[0.56 0.45 0.66 0.35],'LineStyle','none');
    set(mTextBox,'String',['Contact Angle = ',num2str(thetadeg(i),'%0.2f'),char(176)],'FitBoxToText','on','FontSize',12);
    
    savename=strcat(savepath,name,'_ContactAngle');
    saveas(H, savename,'png');
    
end

% plot out the contact angles with legend for visual inspection
HH = figure(i+1);
cmap=hsv(length(thetadeg));
for j=1:length(thetadeg)
plot(j,thetadeg(j),'o','color',cmap(j,:));
hold on;
end

xlabel('Samples','FontSize',16);
ylabel('Contact Angle (degrees)','FontSize',16);
titlestr=strcat('Contact Angles');
title(titlestr,'FontSize',15,'Interpreter','none');
set(gca,'fontsize',16);
leg=legend(names(:).name,'FontSize',8,'Location', 'Northwest');
set(leg,'Interpreter','none')
axis tight;
savename=strcat(savepath,'ContactAnglePlot');
saveas(HH, savename,'png');
saveas(HH, savename,'fig');

% create a .csv that saves the names of the images and the angles
T = table(transpose({names(:).name}),transpose(thetadeg),'VariableNames',{'SampleID';'AngleDegrees'});
writetable(T,'ContactAngleTable.csv');

end


% draws a circle whose center is [x,y] and radius is r
function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp);
end


