% Examples for BME 6717 MATLAB Module: intermediate data handling




%% Passing Functions As Arguments

% Examine the differences between () for a variable and a function

% define a function of interest
fcn1 = @(x)     3*sin(x);
fcn2 = @(x)     (x-2).^3/30 - x + 1;
% explore extra inputs!
fcn3 = @(x,p)   p(1) + p(2)*x + p(3)*x.^2 + p(4)*x.^3; 

% use functions for plotting
q = 0:0.05:4*pi;
figure
plot(q,fcn1(q), q,fcn2(q), q,fcn3(q,[3 1 -0.25 0]))
grid on

help('fzero')
fzero(fcn1,2)
fzero(fcn3,2)   % fzero expecting only 1 argument!
fzero( @(x) fcn3(x,[3 1 -0.25 0]), 2)   % note that we have a function within a function

% See also: ODE solvers



%% Simple Unique Example
% each sample has a class, or label
sampleLabel = randi(15,[20 1]);              
sampleValue = randn(size(sampleLabel)) + sqrt(sampleLabel/3);
data = [sampleLabel, sampleValue];

% how to compute the mean of each class?
% a) loop through each data point
% b) loop through each label

[C,ia,ic] = unique(data(:,1));

% how many unique classes are there?
fprintf('\nThere are %i unique classes.\n',length(C))
% perhaps the 3rd data point appears strange - what are the locations
% of all other members of that class?
labelNum = C(ic(3));    % 3rd appearing
fprintf('The mean of all members of class %g is %2.3g.\n\n',...
    labelNum, mean(data(ic==ic(3),2)) )


% we can do everything in one line with accumarray (later)


%% Cell Arrays: Collecting Dice Rolls in Array
% track all rolls needed to get a 6
n = 1e4;
rolls = cell(n,1);
for k=1:n
    cr = 0;
    while cr~=6
        cr = randi(6);
        rolls{k}(end+1) = cr;
    end
end
% explore what the cell looks like, and peer into a few elements with ()
% and {} indexing
% can also repeat the analysis without while loop using randi and find 6

% Lengths
nrs = zeros(n,1);
for k=1:n
    nrs(k) = length(rolls{k});
end
figure
subplot(2,1,1); histogram(nrs); title(sprintf('median # of rolls: %2.3g',median(nrs)))

nrs = cellfun(@length,rolls);
subplot(2,1,2); histogram(nrs); title(sprintf('median # of rolls: %2.3g',median(nrs)))


% show error for non-uniform output
cellfun(@(u) u==6,rolls,'UniformOutput' , false)





%% Accumarray: Measuring under different conditions
% suppose we measure the response of a sample under 4 different conditions
conds = [1 12 1.8 2.3];     % condition means
n = 1e3;
resp = nan(n,2);            % discuss nans
for k=1:n
    resp(k,2) =  randi(length(conds));
    resp(k,1) = 3*randn+conds(resp(k,2));
end

% object oriented programing idea: reorganize data to make analysis
% directly on the data object easier for what we want to do

% construct new object with loop
respCell = cell(4,1);
for k=1:length(conds)
    ix = resp(:,2)==k;          % find index
    respCell{k} = resp(ix,1);   % populate cell with needed values
end

% return to cell array
sum(cellfun(@length,respCell))  % ensure we have all trials       
cellfun(@mean,respCell)         % find means
    
% reproduce results with accumarray (on original structure!)
accumarray(resp(:,2),resp(:,1),[],@mean)






%% Generate mixed data for cellarray example
% decide on cell properties
spkfcn = @(t,p) max(0, (t-p(1)).*exp(-(t-p(1))/p(2)) );     % data function
spfp = [1 0.2; 1.5 0.4; 3, 0.08];                           % cell parameters
t=0:0.1:6;                                                  % recording times

CellData = cell(140,3);
for k=1:size(CellData,1)
    type = randi(size(spfp,1));     % decide what type of cell
    flag = 1;                       % conditioning flag
    while flag==1
        CellData{k,1} = spfp(type,:) + randn(1,2)/25;   % input parameters (with noise)
        CellData{k,2} = sprintf('Cell Type %g',type);   % Cell type
        CellData{k,3} = spkfcn(t,CellData{k,1});
        flag = any(CellData{k,3}>1);
    end
end
    
% look at individual rows
% investigate the traces with concatenation
V = CellData{1,3}       % obtain data from element
V = CellData{1:3,3}     % try to obtain multiple data records

tmp = [1,2,3]
Vhc = [CellData{1:3,3}]
size(Vhc)
Vvc = vertcat(CellData{1:3,3})
size(Vvc)


% get everything together for plotting
V = vertcat(CellData{:,3});
figure; subplot(2,1,1); plot(V')
xlabel('time'); ylabel('signal amplitude')

% how many from each cell type?
[C,~,ic] = unique(CellData(:,2));   % groups
accumarray(ic,ic,[],@length)        % take a look at how many there are per group


subplot(2,1,2); hold on
cmp = parula(3);
for i=1:3
    plot( vertcat(CellData{ic==i,3})', 'color',cmp(i,:) )
end


% compute average max signal amplitude for each class
accumarray(ic, cellfun(@max, CellData(:,3)), [], @mean)








