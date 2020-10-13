% Homework2_Cornelius.m
% 2020-10-11
% 
% This file contains the various plots and calculations used to construct
% the second homework assignment for MA525. It requires the two .mat files
% normal_normal.mat and geo_beta.mat. Note that some variables are
% overwritten as the file runs, so to check their values pause the
% calculation after each problem.

%% Problem 1


% Define the prior and posterior functions
load normal_normal;
v=1;
M=0;
V=10;
prior = @(mu)1./(sqrt(2*pi*V)).*exp(-1/(2*V).*(mu-M).^2);

vStar = V*v/(V*length(w)+v);
muStar = (V*length(w)*mean(w)+v*M)/(V*length(w)+v);
posterior =  @(mu)1./(sqrt(2*pi*vStar)).*exp(-1/(2*vStar).*(mu-muStar).^2);

% Create figure
figure
clf
fplot(prior, [-10 10])
hold on
fplot(posterior, [-10 10])
xlabel('\mu')
ylabel('\it{p(\mu)}')
legend(["Prior \it{p(\mu)}" "Posterior \it{p(\mu|\omega_{1:N})}"])
title('Comparison of prior and posterior distributions for \mu')

% Evaluate probability of mu being less than 0:
disp(['Prior probability of mu<0: ' num2str(integral(prior, -100, 0))])
disp(['Posterior probability of mu<0: ' num2str(integral(posterior, -100, 0))])


%% Problem 2

% Define the prior and posterior functions
load geo_beta.mat;
prior = @(x) (x.^(1-1).*(1-x).^(1-1))./beta(1,1);
posterior = @(x) (x.^(1+length(w)-1).*(1-x).^(1+sum(w)-1))./(beta(1+length(w), 1+sum(w)));

% Validate the normalization factor
integral(prior, 0, 1);
integral(posterior, 0, 1);

% Create figure
figure
clf
fplot(prior, [0 1])
hold on
fplot(posterior, [0 1])
xlabel('\pi')
ylabel('\it{p(\pi)}')
legend(["Prior \it{p(\pi)}" "Posterior \it{p(\pi|\omega_{1:N})}"])
title('Comparison of prior and posterior distributions for \pi')

% Evaluate probability of pi being greater than 0.15
disp(['Prior probability of pi>0.15: ' num2str(integral(prior, 0.15, 1))])
disp(['Posterior probability of pi>0.15: ' num2str(integral(posterior, 0.15, 1))])

% Numerically check the max value of the posterior
posterior(13/176)
posterior(14/176)
posterior(15/176)