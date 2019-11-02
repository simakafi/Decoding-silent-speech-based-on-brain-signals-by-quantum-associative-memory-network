
%% EXAMPLE OF REINFORCEMENT LEARNING WITH A NEURAL NETWORK

% There are many kinds of reinforcement learning.  This example shows how
% a neural network can be trained to choose actions that produce the
% highest reward (i.e. reinforcement).  For this problem it is assumed
% that rewards are from 0 (no reward) to 1 (desired reward).

% This could be generalized to a [-1 +1] range if including
% negative rewards (negative reinforcement) is needed.

% Solution Summary
% 1. Train network 1 to predict the reward of different actions.
% 2. Train network 2 to internally choose actions it estimates will produce the best reward.
% 3. Extract the subnetwork of network 2 that chooses the best actions.


%% STEP 1 - Train neural network to predict reward for different
% inputs and different contexts.

x1 = rand(1,1000);  % Different contexts - we can't control this
x2 = rand(1,1000);  % Different actions - we will be able to control this
t = 1-abs(x1-x2);   % Measure of good/reward from 0 to 1 resulting from x1 and x2

% The real examples of context x1, actions x2 and resulting
% rewards t would be collected data, and the relationship between
% them would be unknown.

net1 = feedforwardnet(10);
net1.inputs{1}.processFcns = {};
net1.outputs{2}.processFcns = {};
net1.numInputs = 2;
net1.inputConnect(1,2) = true;
net1.layers{2}.transferFcn = 'logsig';

% Train network to predict reward for context x1 and action x2
net1.trainParam.epochs = 50; % Shorten training for this simple example
net1 = train(net1,{x1;x2},{t});
y = net1({x1;x2});
accuracy = perform(net1,t,y{1})
view(net1)

%% STEP 2 - Train second neural network to take context and choose
% the input to the first network that maximizes the good/reward value.

% This is done by adding a two-layer network infront of the
% reward prediction network.

net2 = feedforwardnet([10 1 10]);
net2.inputs{1}.processFcns = {};
net2.outputs{4}.processFcns = {};
net2.inputs{1}.size = 1;
net2.layers{4}.size = 1;
net2.layers{2}.transferFcn = 'logsig';
net2.layers{4}.transferFcn = 'logsig';
net2.inputConnect(3,1) = true;


% Copy 1st network into 3rd/4th layers of 2nd network.
% And turn off learning for these layers
net2.IW{3,1} = net1.IW{1,1};
net2.LW{3,2} = net1.IW{1,2};
net2.b{3} = net1.b{1};
net2.LW{4,3} = net1.LW{2,1};
net2.b{4} = net1.b{2};
net2.inputWeights{3,1}.learn = false;
net2.layerWeights{3,2}.learn = false;
net2.biases{3}.learn = false;
net2.layerWeights{4,3}.learn = false;
net2.biases{4}.learn = false;
view(net2)

% Train the first two layers of net2 to produces the right action
% for the second network to expect the best "good" results (represented by 1's)

rewardTarget = ones(1,1000);    % Always want the reward to be 1
net1.trainParam.epochs = 50;    % Shorten training for this simple example
net2 = train(net2,x1,rewardTarget);
predictedReward = net2(x1);
averagePredictedReward = mean(predictedReward)

%% STEP 3 - Now extract the first two layers to get the network that
% takes context and generates the action designed to maximize reward.

numInputs = 1;
numLayers = 2;
biasConnect = [1;1];
inputConnect = [1;0];
layerConnect = [0 0; 1 0];
outputConnect = [0 1];
net3 = network(numInputs,numLayers,biasConnect,inputConnect,layerConnect,outputConnect);
net3.performFcn = 'mse';
net3.inputs{1}.size = 1;
net3.layers{1}.size = 10;
net3.layers{2}.size = 1;
net1.layers{1}.transferFcn = 'tansig';
net3.IW = net2.IW(1:2,:);
net3.LW = net2.LW(1:2,1:2);
net3.b = net2.b(1:2);
view(net3)

% Test the action network
x2 = net3(x1);              % Choose the action to take from context
y = net1([x1;x2]);          % Predicted reward
actualGood = 1-abs(x1-x2);  % Actual reward
