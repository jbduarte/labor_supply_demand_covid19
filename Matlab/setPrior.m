% prior for A
cA = [-0.6;0.6];
sigA = 0.6*ones(nA,1);
nuA = 3*ones(nA,1);
signA = [-1;1];
    % signA = 1 for elements constrained to positive 
    %       = -1 for elements constrained to be negative
    %       = 0 for elements not sign constrained
longA = [0; 0];
    % longA =1 for equations with long-run restrictions added
    %       = 0 for equations with no additional restrictions added
Ri = [kron(ones(1,nlags),[1 0]) 0];  
      % this makes shock #1 have zero long-run effect on variable 2 in
      % n = 2 variable system
Vi = 0.1;

anames = {' \beta'; ' \alpha'};

% prior for D
kappa = 2.0*ones(n,1);
% tau is determined from kappa and draw of A

% prior for B
eta = [eye(n) zeros(n,k-n)];
lambda0 = 0.2;
lambda1 = 1.0;
lambda3 = 100.0;

