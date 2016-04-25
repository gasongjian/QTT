function y=norm(c,varargin)
if nargin==1
type='fro';
else
    type=varargin{1};
end

switch type
    case {'fro'}
            y=norm(c.core{1});
end
        
            
            
