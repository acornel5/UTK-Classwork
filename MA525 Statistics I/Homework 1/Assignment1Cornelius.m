% This script contains the various functions that were used during this
% homework project.

%% Sphere analysis:

% Define equations for the surface area and volume
sphereSurfaceArea = @(radius) 4*pi*radius.^2;
sphereVolume = @(radius) 4/3*pi*radius.^3;
assert(sphereSurfaceArea(2) == 16 * pi);
assert(sphereVolume(2) == 32/3*pi);


% Define equation for the surface area and volume of sphere
sphereSAV = @(radius)[sphereSurfaceArea(radius) sphereVolume(radius)];
assert(all(sphereSAV(2) == [16*pi 32/3*pi]));


% Create figure demonstrating how the surface area and volume relate:
radii = (0:1e-9:1e-6)';% Radii in meters from 0 to 1 micrometer as a column vector
sphereDimensions = sphereSAV(radii);
surfaceAreas = sphereDimensions(:,1);
volumes = sphereDimensions(:,2);

figure
clf
subplot(2,2,1)
sgtitle('Sphere surface area and volume for radii from 0:1{\mu}m')
plot(radii*10^6, surfaceAreas*10^12)
title('Surface area')
xlabel('Radius ({\mu}m)')
ylabel('Surface area ({\mu}m^2)')
subplot(2,2,2)
plot(radii*10^6, volumes*10^18)
title('Volume')
xlabel('Radius ({\mu}m)')
ylabel('Volume ({\mu}m^3)')
subplot(2,2,3)
plot(surfaceAreas*10^12, volumes*10^18)
title('Surface area vs volume')
xlabel('Surface area ({\mu}m^2)')
ylabel('Volume ({\mu}m^3)')


% Create similar functions for cubes
% Define equations
cubeSurfaceArea = @(sideLength) 6*sideLength.^2;
cubeVolume = @(sideLength) sideLength.^3;
cubeSAV = @(radius)[cubeSurfaceArea(radius) cubeVolume(radius)];
assert(cubeSurfaceArea(2) == 24);
assert(cubeVolume(2) == 8);
assert(all(cubeSAV(2) == [24 8]));


%% Analyze E. coli data
load e_coli_volume_area.mat a v

% Create function to estimate radii/side length from surface area
sphereRadiusFromSurfaceArea = @(surfaceArea) (surfaceArea / (4 * pi)).^0.5;
cubeSideLengthFromSurfaceArea = @(surfaceArea) (surfaceArea / 6).^0.5;
assert(2==sphereRadiusFromSurfaceArea(16 * pi));
assert(2==cubeSideLengthFromSurfaceArea(24));

% Calculate expected radii/side lengths
cellSphereRadii = sphereRadiusFromSurfaceArea(a);
cellCubeSideLengths = cubeSideLengthFromSurfaceArea(a);

% Create comparison figure
figure
clf
hold on
plot(v);
plot(cellSphereVolumes)
plot(cellCubeVolumes)
hold off
xlabel('Cell number')
ylabel('Volume ({\mu}m^3)')
title('Comparison of actual and theoretical volumes for {\it E. Coli} cells')
legend(["Actual" "Spherical" "Cubical"], 'location', 'northwest')

% Calculate the volume errors
disp(['Average absolute volume error (sphere): ' num2str(mean(abs(v - cellSphereVolumes)), 3) ' μm^3'])
disp(['Average absolute volume error (cube): ' num2str(mean(abs(v - cellCubeVolumes)),3) ' μm^3'])


%% Draw categorical
% Define a categorical distribution. The first column is the
% categories, and the second column is their relative weights. The
% weights do not need to be normalized: the DrawCategorical function
% will normalize them automatically. This distribution is intended to
% show a weighted 6 sided die with a higher probability of rolling a 6.
categoricalDistribution = [1 1; 2 1; 3 1; 4 1; 5 1; 6 2];
sampleCount = 100000;

% Calculate the number of expected values for each category
expectedCounts = categoricalDistribution(:,2) .* sampleCount ./ (sum(categoricalDistribution(:,2)));

% Draw values
drawnVals = DrawCategorical(categoricalDistribution, sampleCount);

% Create figure
f = figure(1);
clf
h = histogram(drawnVals);
xlabel('Value')
ylabel('# of samples')
hold on
for i = 1:size(categoricalDistribution,1)
    plot([h.BinEdges(i) h.BinEdges(i+1)], [expectedCounts(i) expectedCounts(i)], 'color', 'red', 'LineWidth', 2)
end
hold off
legend(["Sampled histogram", 'Expected'], 'Location', 'northwest')


%% Simulate drawing from the Cauchy distribution
sigma = 2;
mu = 1;

cauchyValues = DrawCauchy(mu, sigma, 100000);
figure
clf
h = histogram(cauchyValues,"BinEdges", -100:100);
hold on
xlim([-10 10])
xVals = -10:0.01:10;
pdfVals = 1./(pi*sigma).*1./(1+((xVals - mu)/sigma).^2);
plot(xVals, pdfVals/max(pdfVals)*max(h.Values));
legend(["Sampled histogram", 'Expected'], 'Location', 'northwest')


%% Simulate drawing from the normal distribution using Box-Muller
normVals = DrawBoxMuller(5,3,100000);

figure
clf
h=histogram(normVals);
hold on
x = -5:0.01:15;
y = 100000 * 1/(3*sqrt(2*pi)) * exp(-1/2*((x-5)/3).^2);
y = y*max(h.Values)/max(y);
plot(x,y)
legend(["Sampled histogram", 'Expected'], 'Location', 'northwest')


%% Calculate the error variances of the two detectors
load TTTR_calibration.mat
varA = (1/length(wA)*sum(wA.^2));
varB = (1/length(wB)*sum(wB.^2));


%% Calculate the exponential dropoff rate
load TTTR_experiment.mat

stdA = sqrt(varA);
stbB = sqrt(varB);

% Evaluate the likelihood of wA for values of lambda from 0.1 to 5  
x = 0.1:0.1:5;
for i = 1:length(x)
    wALikelihood(i) = LikelihoodOfWA(x(i), wA, stdA);
end


function val = LikelihoodOfWA(lambda, wA, sigma)
    val = 1;
    
    % Function to calculate the probability of a single point. Since it
    % can't be integrated from -infinity to infinity numerically, it is
    % evaluated from -1000 to 1000. This is sufficient for this since it is
    % more than 10 standard deviations on the normal error distribution
    % (and thus everything outside of that will effectively be zero.)
    pOfW = @(w, sigma, lambda) integral(@(d)lambda ./ (sigma .* sqrt(2*pi)).*exp(-1/2.*((w-d)./sigma).^2-lambda.*d), -100, 100);

    for i = 1:length(wA)
        val = val * (pOfW(wA(i), sigma, lambda));
    end
end
