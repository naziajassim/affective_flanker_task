
function affective_flanker_analysis (infile)

% This function analyses the results of affective_flanker_experiment
% Original: Hameron script by Rebecca Lawson
% Source: ICN UCL Matlab course 19/02/2014, Cogent example script
% Modified for educational purposes by Nazia Jassim, 2016


load (infile)        	% Load data.mat: two structs p and results
                     	% Structs are a grouping of many variables of different data conditions


% Get the parameters from the loaded p struct
% This provides info on the size of the result table	 
nconditions  = p.numconditions;
nruns = p.numtrialreps;

% During the experiment the stimuli were shown in random order. However,
% for the analysis the data has to be sorted by group condition. 
% The results.trialstats table is sorted by condition (column 2 )
sortedbycondition = sortrows(results.trialstats,2) ;  


% Each column of the result table is stored into a vector
% The length of the vector equals nconditions x nruns
% cell2mat function is called to convert struct's cell into appropriate
% condition (int, double or boolean)

condition = cell2mat ( sortedbycondition(:,2) ); % 4 different groups/ conditions
hit   	= cell2mat ( sortedbycondition(:,3) );   % button press (T/F)
rt    	= cell2mat ( sortedbycondition(:,4) );   % reaction time

% The data structure is simplified further for analysis by reshaping the
% vectors of length nconditions x nruns into matrix of shape nruns x nconditions
% This way each column will contain only data of one particular condition

condition   = reshape(condition,  [nruns,nconditions]);
hit     	= reshape(hit,    	[nruns,nconditions]);
rt      	= reshape(rt,     	[nruns,nconditions]);

% Calculate mean and standard deviation for each condition
% Looping over n conditions, the average behavioural data is calculated

for i = 1:nconditions
	accuracy(i)      	= mean ( hit(:,i) ); % all rows of the ith column
	accuracy_stddev(i)   = std  ( hit(:,i) );
	rt_mean(i)       	= mean ( rt (:,i) );
	rt_stddev(i)     	= std  ( rt (:,i) );
end

% Bar chart: Mean accuracy rate against condition 
figure(1)
b=bar(accuracy);

% trick to personalize the color of each bar:
% Source: homepages.ulb.ac.be/~dgonze/INFO/matlab.html
ch=get(b,'children');
cd=repmat(1:numel(accuracy),5,1);
cd=[cd(:);nan];
set(ch,'facevertexcdata',cd);
colormap([0.33,0.42,0.18;0.60,0.80,0.20;0,0.50,0.50;0.25,0.88,0.82])

title('Conditions vs Accuracy Rate')
ylabel('Accuracy')
x_label = {'Congruent Happy', 'Incongruent Happy', 'Congruent Angry', 'Incongruent Angry'};
set(gca,'YGrid','on')                           	% horizontal grid lines
set(gca, 'XTick', 1:4, 'XTickLabel', x_label);  	% Set X labels
saveas(gca,'accuracy.jpg','jpg');               	% Save figure

% Bar chart: mean response time against condition with SD error bars
figure(2)
b = bar(rt_mean);
hold on
errorbar(rt_mean,rt_stddev,'k.')

% trick to personalize the colour of each bar:
% Source: homepages.ulb.ac.be/~dgonze/INFO/matlab.html
ch=get(b,'children');
cd=repmat(1:numel(rt_mean),5,1);
cd=[cd(:);nan];
set(ch,'facevertexcdata',cd);
colormap([0.33,0.42,0.18;0.60,0.80,0.20;0,0.50,0.50;0.25,0.88,0.82])


title('Conditions vs Reaction Time')
ylabel('Reaction time [ms]')
x_label = {'Congruent Happy', 'Incongruent Happy', 'Congruent Angry', 'Incongruent Angry'};
set(gca,'YGrid','on')                           	% horizontal grid lines
set(gca, 'XTick', 1:4, 'XTickLabel', x_label);  	% Set X labels
saveas(gca,'response_time.jpg','jpg');          	% Save figure

hold off


% % % ANOVA 2: two-way anova to see the main and interaction effects
% Factors congruence (congruent vs incongruent) vs valence (happy vs angry)

% Store reaction times of each condition
A = rt (:,1);        	% Congruent   Happy
B = rt (:,2);        	% Incongruent Happy
C = rt (:,3);        	% Congruent   Angry
D = rt (:,4);        	% Incongruent Angry


% Arrange reaction times according to factor (congruence and valence).
% The data for factor congruence in columns, &
% the data for factor valence in rows.
                   	 
                      	% M = observations
M = [A B ;           	% Congruent: A, C
 	C D];            	% Incongruent: B, D
                    	 
                     	% First column stacks reaction time of A & C
                     	% Similarly, second column contains rt of B & D


p_rt = anova2 (M, nruns); % Each condition has nruns




