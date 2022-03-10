function ANN(x1,x2)
%% Basic Artificial Neural Network 'By Hand'
% This program takes a 2-dimensional input and predicts an output based on weights and
% functions

%% 0 layers; no weights; no biases

%summation node
out = x1*x2;

%output activation function
y=out;

%output 
% ([0,0] --> [0])
% ([1,0] --> [0])
% ([0,1] --> [0])
% ([1,1] --> [1])
fprintf('OUTPUT1 = %d \n',y)

%% 1 layer (2 nodes); 6 weights; 3 biases

%weights to hidden layer
%wij = input i; node j
w11=1;
w12=1;
w21=1;
w22=1;

%weights from hidden layer
%wj = node j
w1=1;
w2=1;

%biases
b1=1;
b2=1;
b3=0;

%hidden layer computation with sin activation function
h1 = sin(x1*w11 + x2*w21 + b1);
h2 = sin(x1*w12 + x2*w22 + b2);

%output layer with rounding activation function
out = h1*w1 + h2*w2 +b3;
y=round(out);

%output
% ([0,0] --> [2])
% ([1,0] --> [2])
% ([0,1] --> [2])
% ([1,1] --> [0])
fprintf('OUTPUT2 = %d \n',y)

%% 1 layer (2 nodes); 6 weights; 3 biases

%weights to hidden layer
%wij = input i; node j
w11=0.1;
w12=0.5;
w21=0.1;
w22=0.5;

%weights from hidden layer
%wj = node j
w1=1;
w2=1;

%biases
b1=1;
b2=0.1;
b3=0.4;

%hidden layer computation with tanh activation function
h1 = tanh(x1*w11 + x2*w21 + b1);
h2 = tanh(x1*w12 + x2*w22 + b2);

%output layer
out = h1*w1 * h2*w2 +b3;

%output layer function
if out<1
    y=0;
else
    y=1;
end

%output
% ([0,0] --> [0])
% ([1,0] --> [0])
% ([0,1] --> [0])
% ([1,1] --> [1])
fprintf('OUTPUT3 = %d \n',y)

%% 1 layer (2 nodes); 6 weights; 3 biases

%weights to hidden layer
%wij = input i; node j
w11=1;
w12=1;
w21=0.5;
w22=1;

%weights from hidden layer
%wj = node j
w1=0.5;
w2=0.5;

%biases
b1=0.01;
b2=0.01;
b3=0.05;

%hidden layer computation with sigmoid activation function
h1 = 1/(1+exp(-(x1*w11 + x2*w21 + b1)));
h2 = 1/(1+exp(-(x1*w12 + x2*w22 + b2)));

%output layer
out = h1*w1 + h2*w2 + b3;

%output layer function
if out<0.75
    y=0;
else
    y=1;
end

%output
% ([0,0] --> [0])
% ([1,0] --> [0])
% ([0,1] --> [0])
% ([1,1] --> [1])
fprintf('OUTPUT4 = %d \n',out)