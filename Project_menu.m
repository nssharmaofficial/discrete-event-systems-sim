%% Project of Discrete Event Systems – A.A. 2021/22
% Made by Ancilli Tommaso, Brisudova Natasa, Graziuso Natalia, Lazzeri Sean Cesare
% Group #07

%%
clc
clear
close all

%% data
q=2/5; % prob to go to M2 

% time to reach steady state
t_delta_range = [10, 15]; %minutes 
delta = 0.001; % + or -

m = 3; %number of events
n = 11; % number of states

ename = {'a','d1','d2'}; % original names of the events
xname = {'1','2','3','4','5','6','7','8','9','10','11'}; % original names of the states

%% initialization
pi0 = [1 0 0 0 0 0 0 0 0 0 0]; % random pi0

%second question's parameter
eps = 0.61; %must belong to [0,1]
pi_range = [(1-eps)/n,(1+eps)/n];

%rates by choice trial and error
lambda=0.8; % arrivals/minutes
mu1=0.55; % services/minutes
mu2=0.55;  % services/minutes

%transition rate matrix
Q=[-lambda q*lambda (1-q)*lambda 0 0 0 0 0 0 0 0;
    mu2 -lambda-mu2 0 q*lambda (1-q)*lambda 0 0 0 0 0 0;
    0 mu1 -lambda-mu1 0 q*lambda (1-q)*lambda 0 0 0 0 0;
    0 mu2 0 -mu2 0 0 0 0 0 0 0;
    0 0 mu2 0 -lambda-mu1-mu2 0 q*lambda (1-q)*lambda mu1 0 0;
    0 0 0 0 mu1 -mu1 0 0 0 0 0;
    0 0 0 0 mu2 0 -mu1-mu2 0 0 mu1 0;
    0 0 0 0 0 mu2 0 -mu1-mu2 0 0 mu1;
    0 mu2 0 0 0 0 0 0 -lambda-mu2 q*lambda (1-q)*lambda;
    0 0 0 mu2 0 0 0 0 0 -mu2 0;
    0 0 0 0 mu2 0 0 0 0 0 -mu2                                 ];

%% computing pi by using theorem
pi=([Q'; ones(1,n)]\[zeros(n,1);1]);

%% Data for MonteCarlo's method

% Definition of the logical model
model.m = m;  % number of events
model.n = n; % number of states

model.p = zeros(n,n,m); % transition probabilities

% event a = 1
model.p(:,1,1) = [ 0 ; q ; 1-q ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,2,1) = [ 0 ; 0 ; 0 ; q ; 1-q ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,3,1) = [ 0 ; 0 ; 0 ; 0 ; q ; 1-q ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,4,1) = [ 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,5,1) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; q ; 1-q ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,6,1) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,7,1) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,8,1) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,9,1) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; q ; 1-q ]; % vector n x 1
model.p(:,10,1) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 1 ; 0 ]; % vector n x 1
model.p(:,11,1) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 1 ]; % vector n x 1

% event d1 = 2
model.p(:,1,2) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ]; % vector n x 1
model.p(:,2,2) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ];
model.p(:,3,2) = [ 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,4,2) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ];
model.p(:,5,2) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ]; % vector n x 1
model.p(:,6,2) = [ 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,7,2) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 1 ; 0 ]; % vector n x 1
model.p(:,8,2) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 1 ]; % vector n x 1
model.p(:,9,2) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ];
model.p(:,10,2) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ];
model.p(:,11,2) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ];

% event d2 = 3
model.p(:,1,3) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ]; % vector n x 1
model.p(:,2,3) = [ 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,3,3) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ];
model.p(:,4,3) = [ 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,5,3) = [ 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,6,3) = [ NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ; NaN ];
model.p(:,7,3) = [ 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,8,3) = [ 0 ; 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,9,3) = [ 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,10,3) = [ 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1
model.p(:,11,3) = [ 0 ; 0 ; 0 ; 0 ; 1 ; 0 ; 0 ; 0 ; 0 ; 0 ; 0 ]; % vector n x 1

model.p0 = pi0';

%% question's choice
question = menu('Solution to question:','2','3','4','5','6','7');
switch question
    case 1
        question_2
    case 2 
        question_2
        question_3
    case 3
        question_2
        question_4
    case 4 
        question_5
    case 5
        question_2
        question_6
    case 6
        question_2
        question_7
end


