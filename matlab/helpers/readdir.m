function [dataset,labels]=readdir(directory)
    D = dir(directory);
    % the first two items are '.' and '..'. Ignore them.
    dataset = readgraph(fullfile(directory,D(3).name));
    for i=4:size(D,1)
        dataset(i-2) = readgraph(fullfile(directory,D(i).name));
    end
    
    labels = [];
    for i=1:size(dataset,2)
        labels(i)=dataset(i).class;
    end
end

function [graph]=readgraph(file)
    disp(file);
	fid = fopen(char(file),'r');
	el = fscanf(fid,'%d\t%d\n',[2,10000]);
	fclose(fid);
	el = el(:,2:size(el,2))';
	i = [el(:,1);el(:,2)];
	j = [el(:,2);el(:,1)];
	am = sparse(i+1,j+1,1);
	al=cellfun(@(x) find(x),num2cell(am,2),'un',0);
    [path,name,ext] = fileparts(file);
    C = strsplit(name,'-');
	graph = struct('am',am,'al',{al},'name',C(1),'class',C(2));
end

function terms = strsplit(s, delimiter)

assert(ischar(s) && ndims(s) == 2 && size(s,1) <= 1, ...
    'strsplit:invalidarg', ...
    'The first input argument should be a char string.');

if nargin < 2
    by_space = true;
else
    d = delimiter;
    assert(ischar(d) && ndims(d) == 2 && size(d,1) == 1 && ~isempty(d), ...
        'strsplit:invalidarg', ...
        'The delimiter should be a non-empty char string.');
    
    d = strtrim(d);
    by_space = isempty(d);
end

s = strtrim(s);

if by_space
    w = isspace(s);            
    if any(w)
        % decide the positions of terms        
        dw = diff(w);
        sp = [1, find(dw == -1) + 1];     % start positions of terms
        ep = [find(dw == 1), length(s)];  % end positions of terms
        
        % extract the terms        
        nt = numel(sp);
        terms = cell(1, nt);
        for i = 1 : nt
            terms{i} = s(sp(i):ep(i));
        end                
    else
        terms = {s};
    end
    
else    
    p = strfind(s, d);
    if ~isempty(p)        
        % extract the terms        
        nt = numel(p) + 1;
        terms = cell(1, nt);
        sp = 1;
        dl = length(delimiter);
        for i = 1 : nt-1
            terms{i} = strtrim(s(sp:p(i)-1));
            sp = p(i) + dl;
        end         
        terms{nt} = strtrim(s(sp:end));
    else
        terms = {s};
    end        
end

end
