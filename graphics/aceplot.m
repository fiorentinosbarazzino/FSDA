function aceplot(out,varargin)
%aceplot produces the aceplot to visualize the results of ace
%
%<a href="matlab: docsearchFS('aceplot')">Link to the help page for this function</a>
%
%   This function produces two figures. The first figure contains: the plot
%   of transformed y vs. y (top left panel), the plot of residuals vs. fit
%   (top right panel) and the plot of transformed y vs. fit (bottom left
%   panel). The bottom right panel is left blank. This first figure is tagged pl_ty.
%   The second figure contains a series of p panels (where p is the number
%   of columns of X) for transformed $X_j$ (tXj)  vs. $X_j$ (with a rug
%   plot along the tick marks). The second figure is tagged pl_tX.
%   These two figures can be combined in one figure, putting the plots of
%   tXj vs $X_j$ in the bottom right panel of the first figure using
%   optional input argument oneplot. If just one figure is produced it is
%   tagged pl_tyX.
%
% Required input arguments:
%
%  out :  Structure containing the output coming from ace procedure. Structure.
%               Structure containing the following fields.
%      out.ty  = n x 1 vector containing the transformed y values.
%      out.tX  = n x p matrix containing the transformed X matrix.
%     out.rsq  = the multiple R-squared value for the transformed values in
%               the last iteration of the outer loop.
%      out.y  = n x 1 vector containing the original y values.
%      out.X  = n x p matrix containing the original X matrix.
%      out.outliers= k x 1 vector containing the units declared as outliers
%               when avas has been called with option rob set to trye.
%                 Data Types - struct
%
% Optional input arguments:
%
%    highlight : units to highliight in the plot. Vector. Vector contaning
%               the numbers associate to the units to highlight in the plots.
%               The default is to highlight the units inside out.outliers.
%                 Example - 'highlight',1:10
%                 Data Types - double
%
%      oneplot : combined unique plot. Boolean. If oneplot is true just one
%                 figure is produced. The top left panel contains the plot
%                 of transformed y vs. y, the top right panel contains the
%                 plot of residuals vs. fit, the bottom left panel contains
%                 the plot of transformed y vs. fit. The bottom right panel
%                 contains a set of p subpanels (where p is the number of
%                 columns of X) for transformed $X_j$ (tXj)  vs. $X_j$
%                 (with a rug plot along the tick marks). If oneplot is
%                 false (default), the p panels for transformed $X_j$ (tXj)
%                 vs. $X_j$ are put in a separate figure.
%                 Example - 'oneplot',true
%                 Data Types - logical
%
%        ylimy  : 2D array of size 3-by-2 which specifies the
%                lower and upper limits for the 3 plots of the second
%                figure. The first row refers to the plot of transformed y
%                vs. y, the second row refers to the plot of residuals vs.
%                fit and the third row to the the plot of transformed y vs.
%                fit. The default value of ylimy is [], that is automtic
%                scale is used.
%                   Example - 'plots', [-3 3; -2 2; -2 2]
%                   Data Types - single | double
%
% Output:
%
% See also: ace, smothr
%
% References:
%
%
% Breiman, L. and Friedman, J.H. (1985), Estimating optimal
% transformations for multiple regression and correlation, "Journal of the
% American Statistical Association", Vol. 80, pp. 580-597.
% Wang D.  and Murphy M. (2005), Identifying nonlinear relationships
% regression using the ACE algorithm, "Journal of Applied Statistics",
% Vol. 32, pp. 243-258.
%
% Copyright 2008-2023.
% Written by FSDA team
%
%
%<a href="matlab: docsearchFS('aceplot')">Link to the help page for this function</a>
%
%$LastChangedDate:: 2018-06-08 01:27:40 #$: Date of the last commit

% Examples:

%{
   %% Example of the use of ace based on the Wang and Murphy data.
   % In order to have the possibility of replicating the results in R using
   % library acepack function mtR is used to generate the random data.
    rng('default')
    seed=11;
    negstate=-30;
    n=200;
    X1 = mtR(n,0,seed)*2-1;
    X2 = mtR(n,0,negstate)*2-1;
    X3 = mtR(n,0,negstate)*2-1;
    X4 = mtR(n,0,negstate)*2-1;
    res=mtR(n,1,negstate);
    % Generate y
    y = log(4 + sin(3*X1) + abs(X2) + X3.^2 + X4 + .1*res );
    X = [X1 X2 X3 X4];
    % Apply the ace algorithm
    out= ace(y,X);
    % Show the output graphically using function aceplot
    aceplot(out)
%}

%{
    % Example of use of option highlight.
    load('illnessx07.txt');
    y=illnessx07(:,4);
    X=illnessx07(:,2:3);
    p=size(X,2);
    ycont=y;
    listout=[17 53 30];
    ycont(listout)=1;
    l=[4*ones(p,1); 1];
    outAC= ace(ycont,X,'l',l);
    aceplot(outAC,'highlight',listout)
%}

%{
    % Example of the of option oneplot.
    % Load the Marketing data.
    load('Marketing_Data')
    y=Marketing_Data{:,4};
    X=Marketing_Data{:,1:3};
    % apply traditional avas (with all options set to false). 
    % Monotonicity of the expl. variables imposed.
    out=avas(y,X,'l',3*ones(size(X,2),1))
    % Put the plots of transformed Xj (tXj) agains Xj in the bottom right
    % panel
    aceplot(out,'oneplot',true)
%}

%% Beginning of code

highlight=out.outliers;
ylimy=[];
oneplot=false;
if nargin >1
    UserOptions=varargin(1:2:length(varargin));

    options=struct('highlight',highlight,'ylimy',ylimy,'oneplot',oneplot);

    if ~isempty(UserOptions)
        % Check if number of supplied options is valid
        if length(varargin) ~= 2*length(UserOptions)
            error('FSDA:aceplot:WrongInputOpt','Number of supplied options is invalid. Probably values for some parameters are missing.');
        end
        % Check if user options are valid options
        chkoptions(options,UserOptions)
    end

    % We now overwrite inside structure options the default values with
    % those chosen by the user
    % Notice that in order to do this we use dynamic field names
    for i=1:2:length(varargin)
        options.(varargin{i})=varargin{i+1};
    end
    highlight=options.highlight;
    ylimy=options.ylimy;
    oneplot=options.oneplot;
end

if ~isempty(ylimy)
    [nylim,vylim]=size(ylimy);
    if nylim~=3
        error('FSDA:aceplot:Wronginput','ylimy must be a matrix with 3 rows')
    end
    if vylim~=2
        error('FSDA:aceplot:Wronginput','ylimy must be a matrix with 2 columns')
    end
end


X=out.X;
y=out.y;
tX=out.tX;
ty=out.ty;
p=size(tX,2);

addout=~isempty(highlight);
% Organize the locations of the plots of tXj vs Xj
if oneplot==false
    if p<=2
        nr=2; nc=1;
    elseif p<=4
        nr=2; nc=2;
    elseif p<=6
        nr=3; nc=2;
    elseif p<=8
        nr=4; nc=2;
    elseif p<=9
        nr=3; nc=3;
    elseif p<=12
        nr=4; nc=3;
    else
        error('FSDA:aceplot:TODO','So far not implemented for p>12')
    end
else % oneplot true
    if p==1
        nr=2; nc=2;
        numbers=[4 4];
    elseif p==2
        nr=4; nc=4;
        numbers=[11 12; 15 16];
    elseif p==3
        nr=6; nc=6;
        % numbers=[22.5 24; 28.5 30; 34.5 36];
        numbers=[22 24; 28 30; 34 36];
    elseif p==4
        nr=8; nc=8;
        numbers=[37.5 40; 45.5 48; 53.5 56; 61.5 64];
    elseif p==5
        nr=10; nc=10;
        numbers=[56 60; 66 70; 76 80; 86 90; 96 100];
    else
        error('FSDA:aceplot:Wrongp','Option oneplot is implemented for p<=5')
    end
end


figure
set(gcf,'Tag','pl_ty')
subplot(2,2,1)
plot(y,ty,'o')
ylabel('Transformed y')
xlabel('y')
title('Plot of ty vs. y')
if addout ==true
    hold('on')
    plot(y(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
% Set the ylimits
if ~isempty(ylimy)
    ylim(ylimy(1,:))
end

yhat=sum(tX,2);
res = ty - yhat;
subplot(2,2,2)
plot(yhat,res,'o')
refline(0,0)
title('Plot of residuals vs. fit')
ylabel('Residuals')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),res(highlight),'ro','MarkerFaceColor','r')
end
% Set the ylimits
if ~isempty(ylimy)
    ylim(ylimy(2,:))
end


subplot(2,2,3)
plot(yhat,ty,'o')
title('Plot of ty vs. fit')
ylabel('Transformed y')
xlabel('Fitted values')
if addout ==true
    hold('on')
    plot(yhat(highlight),ty(highlight),'ro','MarkerFaceColor','r')
end
% Set the ylimits
if ~isempty(ylimy)
    ylim(ylimy(3,:))
end

if oneplot==true
else
    figure
end

for j=1:p
    if oneplot==true
        jj=numbers(j,1):numbers(j,2);
    else
        jj=j;
    end
    subplot(nr,nc,jj)
    plot(X(:,j),tX(:,j),'o')
    %if j<p
    a=gca;
    a.XTickLabel='';
    % end
    R=rug(0.03);
    try
        delete(R.yRug)
    catch
    end
    jstr=num2str(j);
    if oneplot==false
        ylabel(['Transformed X' jstr])
        xlabel(['X' jstr])
    else
        ylabel(['tX' jstr])
        text(0.95,0.15,['X' jstr],'Units','normalized')
        if j==p
            xlabel('X')
        end
    end
    if addout ==true
        hold('on')
        plot(X(highlight,j),tX(highlight,j),'ro','MarkerFaceColor','r')
    end

end
if oneplot==false
    set(gcf,'Tag','pl_tX')
else
    set(gcf,'Tag','pl_tyX')
end

% Add an horizontal line at 0
%    abline(h = 0, col = "black", lty = 2)

end
%FScategory:VIS-Reg