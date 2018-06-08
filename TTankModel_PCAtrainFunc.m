%% TTankModel PCA training function
% This function uses NOC data from the two tank system and trains the PCA model
% that will be used for fault detection

function outTr = TTankModel_PCAtrainFunc(X)

% Determine size of X
[N, ~] = size(X);

% scale Xu_train, obtain stdev and mean
[X_tr, mu_u, sigma_u] = zscore(X);

% Apply PCA
[P, T, L, ~, explained] = pca(X_tr,'Centered', false);

% Number of retained variances
% retaining the components that represent 95% of the variance
cumExp = cumsum(explained);
A = find(cumExp>95,1,'first');

% Retaining variables
PA = P(:, 1:A);
LA = L(1:A);
TA = T(:, 1:A);
X_recon = TA*PA'; % reconstructing the data

% Detection stats
% // modified Hotelling's Tstat calculation
MHT = zeros(N, 1);
for i = 1: N
    MHT(i) = sum(TA(i, :).^2./LA');
end

% MHT critical calculation
MHTcrit = prctile(MHT, 99); % threshold assumed to be 99th percentile of MHT

% // SPE calculation
Qstat = zeros(N,1);
for i = 1:N
    Qstat(i) = sum((X_tr(i, :) - X_recon(i, :)).^2);
end

% SPE critical calculation
Qcrit = prctile(Qstat, 99); % threshold assumed to be 99th percentile of SPE

% Packing the variables
outTr =struct('mu_u',mu_u, 'sig_u',sigma_u,'PA', PA, 'LA', LA, 'A', A, 'TA', TA, 'Q', Qstat, 'MHT', MHT, 'MHTcrit', MHTcrit, 'Qcrit', Qcrit); 
end








