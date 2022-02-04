function [E,X,T] = simprobdes(model,V)

%
% SIMPROBDES simulates a discrete event system described by a
%   stochastic timed automaton
%
%     [E,X,T] = simprobdes(model,V)
%
%     MODEL: structure describing the state automaton
%       'm' (1 x 1): number of events
%       'n' (1 x 1): number of states
%       'p' (n x n x m): 3-D matrix describing the transition probabilities
%           p(x'|x,e) (use NaN if event e is not possible in state x)
%       'p0' (n x 1): vector of probabilities of the initial state
%
%     V (m x L): matrix describing the clock structure
%
%     E: event sequence [ e1 e2 e3 ... eL ]
%
%     X: state sequence [ x0 x1 x2 x3 ... xL ]
%
%     T: time sequence [ t0 t1 t2 t3 ... tL ]
%
%     Version: 2020.02.06
%

% Check input arguments
if (nargin < 2),
    error('Argument V is missing')
end

if ~isstruct(model),
    error('Argument MODEL should be a structure')
end

if ~isfield(model,'m'),
    error('Field ''m'' of argument MODEL is missing')
end

if ~isfield(model,'n'),
    error('Field ''n'' of argument MODEL is missing')
end

if ~isfield(model,'p'),
    error('Field ''p'' of argument MODEL is missing')
end

if ~isfield(model,'p0'),
    error('Field ''p0'' of argument MODEL is missing')
end

m = model.m;
n = model.n;
p = model.p;
p0 = model.p0;

if ~isreal(m)|~isscalar(m)|(m<1)|any(m-round(m)),
    error('Field ''m'' of argument MODEL must be a positive integer')
end

if ~isreal(n)|~isscalar(n)|(n<1)|any(n-round(n)),
    error('Field ''n'' of argument MODEL must be a positive integer')
end

if ~isreal(p)|(size(p,1)~=n)|(size(p,2)~=n)|(size(p,3)~=m),
    error('Field ''p'' of argument MODEL must be an n x n x m 3-D real matrix')
end
for x = 1:n,
    for e = 1:m,
        if any(isnan(p(:,x,e))),
            if (~all(isnan(p(:,x,e)))),
                error('Field ''p'' of argument MODEL: if a column p(:,x,e) contains at least one NaN, all other elements in the column must be NaN')
            end
        elseif any(p(:,x,e) < 0)|(sum(p(:,x,e))~=1),
            error('Field ''p'' of argument MODEL: a column p(:,x,e) must contain nonnegative reals summing up to 1')
        end
    end
end

if ~isreal(p0)|(size(p0,1)~=n)|(size(p0,2)~=1),
    error('Field ''p0'' of argument MODEL must be a n x 1 real vector')
end
if any(p0 < 0)|(sum(p0)~=1),
    error('Field ''p0'' of argument MODEL must contain nonnegative reals summing up to 1')
end

if ~isreal(V)|(size(V,1)~=m)|(size(V,2)==0)|any(any(V<0)),
    error('Argument ''V'' must be a m x L matrix of nonnegative reals')
end

% Initialization
L = size(V,2); % length of clock sequences and maximum event index
Gamma = zeros(n,m);
for x = 1:n,
    for e = 1:m,
        if ~isnan(p(1,x,e)), % this check is enough, thanks to the preliminary control on NaN values
            Gamma(x,e) = 1;
        end
    end
end
x0 = randsample(n,1,true,p0); % initial state
s = zeros(1,m); % event scores
y = Inf*ones(1,m); % residual lifetimes
for e = 1:m,
    if Gamma(x0,e),
        s(e) = 1;
        y(e) = V(e,s(e));
    end
end

% Simulation
E = zeros(1,L);
X = [ x0 zeros(1,L) ];
T = zeros(1,L+1);
exitflag = 0;

for k = 1:L,
    % Select the next event
    [ymin,enext] = min(y);
    E(k) = enext;
    
    % Time instant of the next event
    T(k+1) = T(k) + ymin;
    
    % Compute the next state
    X(k+1) = randsample(n,1,true,p(:,X(k),E(k)));
    
    % Update the scores
    for e = 1:m,
        if ((e==E(k))&Gamma(X(k+1),e))|(~Gamma(X(k),e)&(Gamma(X(k+1),e))),
            s(e) = min(s(e)+1,L); % 'min' is used just to avoid that s(e) exceeds L when k = L
        end
    end
    
    % Update the residual lifetimes
    for e = 1:m,
        if ((e==E(k))&Gamma(X(k+1),e))|(~Gamma(X(k),e)&(Gamma(X(k+1),e))),
            y(e) = V(e,s(e));
        elseif (Gamma(X(k),e)&(e~=E(k))&(Gamma(X(k+1),e))),
            y(e) = y(e)-ymin;
        else
            y(e) = Inf;
        end
    end
end