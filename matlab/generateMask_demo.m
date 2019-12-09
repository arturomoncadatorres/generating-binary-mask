%%
% GENERATEMASK_DEMO - Demo for the function generateMask.
%
% Created October 9, 2013.
% Arturo Moncada-Torres
%   arturomoncadatorres@gmail.com
%   http://www.arturomoncadatorres.com


%%
% Preliminaries.
clc;
clear all;
close all;


%%
% Define execution parameters.

% MASK_SHAPE defines the shape of the ROI to use for the masking.
% Possible values are:
%   'rectangle' Rectangle
%   'ellipse'   Ellipse (including circle)
%   'polygon'   Irregular polygon
%   'region'    Free hand
shape = 'ellipse';

% Number of regions of interest.
nROI = 3;


%%
% Read example image.
I = imread('../images/lena.jpg');


%%
% Generate masks.
[mask, masks] = generateMask(I, shape, nROI);


%%
% Mask image.
masked = double(I) .* mask;


%%
% Display results.

figure();

subplot(1,3,1);
imshow(I, []);
title('Original image');

subplot(1,3,2);
imshow(mask, []);
title('Masks (overlapped)');

subplot(1,3,3);
imshow(masked, []);
title('Masked image)');