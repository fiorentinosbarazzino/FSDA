function add2spm(H,AX,BigAx,varargin)
%add2spm adds objects (personalized clickable multilegends and text labels) to the scatter plot matrix
%
%
%<a href="matlab: docsearchFS('add2spm')">Link to the help function</a>
%
%
%
%  Required input arguments:
%
%            H   : handles to the lines on the graphs. 2D or 3D array. H is an array of handles to the
%                   lines on the graphs. The array's third dimension
%                   corresponds to groups in the grouping variable. 
%                   For more details see the output arguments of gplotmatrix. 
%           AX   : handles to the axes of the individual plots. Matrix.  AX is a
%                   matrix of handles to the axes of the individual plots.
%                   For more details see the output arguments of gplotmatrix. 
%          BigAx :  handle to big (invisible) axes framing the
%                   entire plot matrix. Scalar. 
%                   For more details see the output arguments of gplotmatrix. 
%
%  Optional input arguments:
%
%  labeladd :   add labels for a group of units. Char.
%               Default is '', i.e. no
%               labels are added to the symbols inside each scatter.
%               If set to '1', add labels to the units of the last data
%               group (or the group with the largest value of the grouping
%               variable) in each panel of the scatter matrix. The labels
%               which are added are based on the content of the 'UserData'
%               field of the last group. This can be achieved by means of
%               instruction set(H(:,:,end), 'UserData' , unit_labels),
%               where unit_labels is a column vector of numbers or strings.
%               See last example below for a concrete case.
%               Example - 'labeladd','1'
%               Data Types - char
%  userleg  :   user legend. Char.
%               It is used to control the legend of the plot.
%               - Default is ''. In this case, existing legends are left as
%                 they are and simply made clickable; however, if there is
%                 no legend, a default one is created using the syntax
%                 'Group 1', 'Group 2', etc.
%               - If it is set to '1', the legends are updated depending on
%                 the context of use and are made clickable. The context is
%                 determined by the occurence of specific words in the Tag
%                 of the current figure. The strings/contexts currently
%                 addressed are:
%                 'outlier' (for 'Outliers' and 'Normal units'),
%                 'brush'   (for 'Brushed units 1', 'Brushed units 2', etc.),
%                 'group'   (for 'Group 1', 'Group 2', etc.),
%                 ''         i.e. the Tag of the figure is not defined;
%                            in this case the legend takes the values in
%                            the DisplayName property of the scatter
%                            matrix. This is determined by the 'group'     
%                            option of the spmplot or gplotmatrix functions. 
%               - If it is a cell of strings, e.g. {'FIAT' ; 'BMW' ; 'VOLVO'},
%                 then such strings are used for the legend.
%               Example - 'userleg','1'
%               Data Types - char
%
% Output:
%
% More About:
%
%   add2spm is essentially used within FSDA function spmplot.m. However its
%   logic can be also demonstrated with MATLAB function gplotmatrix.m, as in
%   the examples below.
%
% As default add2spm makes legends in the existing scatter plot matrix
% clickable or creates a clickable multilegend if the legend does not
% exist.
%
% Using varargin it is possible to:
% 1. Personalize the legend of groups in the scatterplot matrix. See option
%    'userleg'.
% 2. Add labels of the units belonging to the last data group (or to the
%   group with the largest value in the grouping variable) of each scatter
%   (panel). See option 'labeladd'.
%
% See also spmplot
%
%
% Copyright 2008-2015.
% Written by FSDA team
%
%<a href="matlab: docsearchFS('add2spm')">Link to the help function</a>
% Last modified 06-Feb-2015

% Examples:

%
%{
    %% add2spm with all default options.
    % load Fisher iris  data
    load fisheriris;
    % Create scatter plot matrix with specific legends
    [H,AX,BigAx]=gplotmatrix(meas,[],species);
    % [H,AX,BigAx]=gplotmatrix(meas,[],species,[],[],[],[],'grpbars')
    add2spm(H,AX,BigAx)
%}

%{ 
    % add2spm with optional arguments.
    % Use of userleg variable. Set some multivariate data and some groups.
    y = randn(100,3);
    group = ones(100,1); group(1:10,1) = 444; group(11:20,1) = 777;

    % Make a scatterplot using gplotmatrix defaults.
    % The legends automatically created are '1','444' and '777'.
    [H,AX,BigAx] = gplotmatrix(y,[],group,'brk','.ox');

    % with add2spm with default options, the gplotmatrix legends
    % will become clickable.
    add2spm(H,AX,BigAx);

    % by running add2spm with option 'userleg' set to '1', and by setting
    % the figure Tag to a string containing the word 'group', the clickable
    % legends will become 'group 1', 'group 2' and 'group 3'.
    [H,AX,BigAx] = gplotmatrix(y,[],group,'brk','.ox');
    set(gcf, 'Tag', 'this is a string with group')
    add2spm(H,AX,BigAx,'userleg','1');

    % by running add2spm with 'userleg', {'my group 1' ; 'my group 4' ; 'my
    % group 7'} the legends change as desired.
    [H,AX,BigAx] = gplotmatrix(y,[],group,'brk','.ox');
    add2spm(H,AX,BigAx,'userleg',{'FIAT' ; 'BMW' ; 'VOLVO'});

    % Now create a group on units contaminated by outliers. By running
    % add2spm with option 'userleg' set to '1', and by setting the figure
    % Tag to a string containing the word 'outlier', the clickable legends
    % become 'normal units' and 'outliers'. Remark: the keep the proper
    % order of the legends, it is sufficient to reserve for the outlier id
    % variable the largest id number.
    y = randn(100,2); y(25:35,:) = y(25:35,:) + 10;
    group = ones(100,1);group(25:35,1) = 5;
    figure('Tag','this is a dataset with outliers');
    [H,AX,BigAx] = gplotmatrix(y,[],group,'br','ox');
    add2spm(H,AX,BigAx,'userleg','1');

%}

%{
    %% Use of labeladd.
    
    close all;
    % 'labeladd' is set to '1' to add labels found in the UserData
    % property of the last group in each panel of the scatter matrix.
    % It can be retrieved from H(1,end,end) (i.e. first row, last column,
    % last group of the scatter matrix handles).

    y = rand(100,3);
    group = ones(100,1); group(1:5,1) = 5; group(10:15,1) = 10;
    [H,AX,BigAx] = gplotmatrix(y,[],group,'brk','.ox');

    % column vector of labels is set to the integers from 1 to size of last
    % data group
    labels = (1:numel(get(H(1,end,end),'YData')))';

    % assign labels to the 'UserData' property of the last data group
    set(H(:,:,1), 'UserData' , labels);

    % try add2spm with 'labeladd' option set to '1'
    add2spm(H,AX,BigAx,'labeladd','1');

%}
%

%% Beginning of code
H=double(H);

options=struct('labeladd','','userleg','');
UserOptions=varargin(1:2:length(varargin));
% Write in structure 'options' the options chosen by the user
if ~isempty(UserOptions)
    for i=1:2:length(varargin);
        options.(varargin{i})=varargin{i+1};
    end
end
labeladd = options.labeladd;
userleg  = options.userleg;

% force to build default legends if there are no legends in the scatterplot
if ~isappdata(AX(1,end),'LegendPeerHandle');
    userleg = '1';
end

% These are the legends already in the plot
legplot = get(getappdata(AX(1,end),'LegendPeerHandle'),'String');

% if 'userleg' is empty, use the legend already in the plot.
if isempty(userleg)
    legnew = legplot;
end

% if 'userleg' is a cell of string, use such strings as user-defined legends
if ~isempty(userleg) && iscell(userleg)
    legnew = userleg;
end

% set the 'DisplayName' property for the two cases above
if isempty(userleg) || (~isempty(userleg) && iscell(userleg))
    % the new legends
    nleg = numel(legnew);
    % modify the DisplayName field so that to hide/show the groups 
    if ishandle(H(1,1,1)) && ~verLessThan('matlab','8.5.0')
        histstyle= get(H(1,1,1),'DisplayStyle');
    else
        histstyle='histogram';
    end
    %if verLessThan('matlab', '8.5.0')
    switch histstyle
        case {'histogram' , 'bar'}
            H(:,:,1) = ~eye(size(H,1)).*H(:,:,1);
            newH = reshape(H,numel(H)/nleg,nleg);
            for i = 1 : nleg
                set(newH(newH(:,1)~=0,i),'DisplayName',legnew{i});
            end
        case 'stairs'
        % from MATLAB R2015a, if there is more than one group, the scatter
        % matrix generated by gplotmatrix displays by default the outlines
        % of grouped histograms (see 'stairs' option). In this case, we
        % show/hide the histograms stairs.
        for i = 1 : nleg
            HH = H(:,:,i) ;
            set(HH(:),'DisplayName',legnew{i});
        end
    end
    set(gcf,'Name','Scatter plot matrix with groups highlighted');
end

% if 'userleg' is '1', set context sensitive group-specific legends.
% The context is determined by the occcurence of specific words in the Tag
% of the current figure. The currently addressed strings/contexts are
% 'outlier' (for outliers/normal units), 'brush' (for Brushed units 1,
% Brushed units 2, etc.) and 'group' (for 'Group 1, Group 2, etc.).
if ~isempty(userleg) && ischar(userleg) && strcmp(userleg,'1')
    
    % add multilegend
    v = size(AX,2);
    leg = get(getappdata(AX(1,end),'LegendPeerHandle'),'String');
    nleg = numel(leg);
    
    if ndims(H) == 3
        % The third dimension of H is to distinguish the groups. In the next
        % 'if' statement we use two equivalent ways to deal with H, considering
        % that the diagonal of the scatter matrix is dedicated to the
        % histograms.
        if nleg == 2 && ~isempty(strfind(lower(get(gcf, 'Tag')),'outlier'))
            set(H(H(:,:,2)~=0),'DisplayName','Normal units');
            linind      = sub2ind([v v],1:v,1:v);
            outofdiag   = setdiff(1:v^2,linind);
            lin2ind     = outofdiag+v^2;
            set(H(lin2ind),'DisplayName','Outliers');
        else
            % Assign to this figure a name
            set(gcf,'Name','Scatter plot matrix with groups highlighted');
            % Reset the handles of the main diagonal (histograms) to zero.
            H(:,:,1) = ~eye(size(H,1)).*H(:,:,1);
            % Now reshape the handles array to make it more manageable: while H
            % is a 3-dimensional array with the third dimension associated to
            % the groups, newH is 2-dimensional with columns associated to the
            % lines of the scatterplot and lines associated to the groups.
            newH = reshape(H,numel(H)/nleg,nleg);
            if strcmp(get(gcf, 'Tag'),'pl_spm') || ~isempty(strfind(lower(get(gcf, 'Tag')),'brush'))
                % set the legend of the unbrushed units
                set(newH(newH(:,1)~=0),'DisplayName','Unbrushed units');
                % set the legend of the brushed units
                for i = 2 : nleg
                    set(newH(newH(:,1)~=0,i),'DisplayName',['Brushed units ' num2str(i-1)]);
                end
            elseif ~isempty(strfind(lower(get(gcf, 'Tag')),'group'))
                for i = 1 : nleg
                    set(newH(newH(:,1)~=0,i),'DisplayName',['Group ' num2str(i)]);
                end
            else
                % here the tag is empty: in this case take the legends
                % provided by the user
                for i = 1 : nleg
                    %leguser = get(getappdata(AX(1,end),'LegendPeerHandle'),'String');
                    set(newH(newH(:,1)~=0,i),'DisplayName',legplot{i});
                end
            end
        end
    else
        % In this case there are no groups in the data
        set(setdiff(H(:),diag(H)),'DisplayName','Units')
    end
    
    % Get the final legends
    legnew = get(getappdata(AX(1,end),'LegendPeerHandle'),'String');
end

% Now update the legends in the plot and make them clickable.
hLines  = findobj(AX(1,end), 'type', 'line');
if ~isempty(legnew)
    clickableMultiLegend(sort(double(hLines)), legnew{:});
end
% Remark:
% hLines is an array of handles before R2014b and a HG2 object wirh R2014b
% Therefore, sort(hLines) has been modified with sort(double(hLines)) to
% guarantee the correct sorting of the legends in both cases.

%% histogram in the diagonal
% tag the histogram group patches with the group labels. The tag is used in
% clickablemultilegend to show/hide the legends.
if verLessThan('matlab','8.4.0')
    h = findobj(AX, 'Type','patch');
else
    h = findobj(AX, 'Type','Bar');
    %h2 = findobj(AX, 'DisplayStyle','stairs');
end
% h = findobj(AX, '-not','Type','Line','-not','Type','Axes');


for z=1:nleg
    if length(h) == nleg*size(AX,2)
        set(h(repmat(1:nleg,1,size(AX,2))==z),'Tag',legnew{nleg-z+1});
        %set(h2(repmat(1:nleg,1,size(AX,2))==z),'Tag',legnew{nleg-z+1});
    else
        set(h,'Tag','');
    end
end

%% boxplot in the diagonal
% if there is no histogram, and therefore h is empty, then there is a
% boxplot. In this case we have to set the 'DisplayName' property of the
% boxplot groups, which is used in clickablemultilegend to show/hide the
% legends.
h = findobj(gcf,'Tag',['boxplot' num2str(1)]);
if ~isempty(h)
    for z=1:nleg
        h = findobj(gcf,'Tag',['boxplot' num2str(z)]);
        set(h,'DisplayName',legnew{z});
    end
end

%% add labels to the last selected group

if strcmp('1',labeladd)
    % We need to add objects (the labels) to the scatterplots
    fig = ancestor(BigAx,'figure');
    set(fig,'NextPlot','add');
    set(AX,'NextPlot','add');
    % The UserData field of the last selected group of H(:,:,end) contains
    % the indices of the last selected units.
    nbrush = get(H(end,1,end), 'UserData');
    
    % Below there is an alternative inefficient code to extract brushed
    % units
    % a=findobj(H1,'Type','Line');
    % nbrush=[a.UserData];
    % nbrush=nbrush(:,1);
    
    % AX has as many columns as the variables in the scatterplot data
    v = size(AX,2);
    for i = 1:v
        for j = 1:v
            if i ~=  j;
                % Set AX(i) the current axes
                set(fig,'CurrentAxes',AX(i,j));
                % Add the id labels for the units in last group.
                XDataLast = get(H(i,j,end),'XData');
                YDataLast = get(H(i,j,end),'YData');
                htxt=text(XDataLast,YDataLast,num2str(nbrush,'% d'),'HorizontalAlignment', 'Center','VerticalAlignment','Top');
                % Remark DisplayName with releases>2014a does not work
                % anymore. It must bre replaced by String
                %  if  isempty(userleg)
                %      %set(htxt, 'String', legplot{end});
                %      %set(htxt, 'String', legnew{end});
                %  end
                set(htxt,'Color',get(H(i,j,end),'Color'),'Tag','plo_labeladd');
            end
        end
    end
end

end
