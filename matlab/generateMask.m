function [mask, masks] = generateMask(I, shape, nROI, varargin)
%%
% GENERATEMASK - Generate mask of an image. 
%
% [MASK, MASKS] = GENERATEMASK(I, SHAPE, NROI)
%   Generates a mask on top of image I. The number of regions of
%   interest is given by NROI. The shape of the regions of interest is
%   given by the string SHAPE: rectangular ('rectangle'), ellipsoid
%   (including circle, 'ellipse'), irregular polygon ('polygon') or 
%   free-hand defined ('region'). The image is displayed in a new figure.
%   MASK is the overlap of all MASKS together.
%
% [MASK, MASKS] = GENERATEMASK(I, SHAPE, NROI, HFIG)
%   The image is displayed in the figure controlled by handle HFIG.
%
% Created October 1, 2013.
% Arturo Moncada-Torres
%   arturomoncadatorres@gmail.com
%   http://www.arturomoncadatorres.com


%%
% Define macros.
LINE_WIDTH = 4;


%%
% Manage additional (optional) inputs.
nvarargin = numel(varargin);
switch nvarargin
    case 0
        hFig  = figure();
        hAxes = gca;
    case 1
        hFig  = varargin{1};
        hAxes = axes('Parent',hFig);
    otherwise
        error('Incorrect number of optional inputs. For more information, see the help of this function.');
end


%%
% Original image.

% Image size.
[rows, cols] = size(I);

% Preallocate memory.
masks = zeros(rows, cols, nROI);

% Display original image (where the masks will be chosen).
imshow(I,[], 'Parent',hAxes);
hold('on');

for ii = 1:nROI
    
    % Instruction title.
    instructionString = sprintf('Select masking %s (%d of %d)', shape, ii, nROI);    
    title(instructionString, ...
        'HorizontalAlignment','center',...
        'FontName','Calibri', ...
        'FontSize', 12);
    
    switch lower(shape)
        
        case 'rectangle'
            % Select ROI with mouse (double click after each selection).
            selection = imrect;
            position{ii} = wait(selection);
            
            % Plot selected ROI.
            rectangle('Position',position{ii}, ...
                        'EdgeColor','r', ...
                        'LineWidth',LINE_WIDTH);
            
        case 'ellipse'
            % Select ROI with mouse (double click after each selection).
            selection = imellipse;
            position{ii} = wait(selection);
            
            % Plot selected ROI.
            plot(position{ii}(:,1),position{ii}(:,2),'r', 'LineWidth',LINE_WIDTH);
    
        case 'polygon'
            % Select ROI with mouse (double click after each selection).
            selection = impoly;
            position{ii} = wait(selection);
            
            % Plot selected ROI.
            plot(position{ii}(:,1),position{ii}(:,2),'r', 'LineWidth',LINE_WIDTH);
            
        case 'region'
            % Select ROI with mouse (double click after each selection).
            selection = imfreehand;
            position{ii} = wait(selection);
            
            % Plot selected ROI.
            plot(position{ii}(:,1),position{ii}(:,2),'r', 'LineWidth',LINE_WIDTH);
            
        otherwise
            error('Invalid shape. For more information, see the help for this function.');
    end

    % Create the actual mask.
    masks(:,:,ii) = selection.createMask;
end
hold('off');
close(hFig);


%%
% Generate (overlapped) mask.

% Sum up all masks together.
mask = sum(masks,3);

% In case some masks are overlapping.
mask(mask>1) = 1;