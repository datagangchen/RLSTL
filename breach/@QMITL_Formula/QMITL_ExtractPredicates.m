function mus = QMITL_ExtractPredicates(phi)
%QMITL_EXTRACTPREDICATES extracts all predicates present in phi
% 
% Synopsis: mus = QMITL_ExtractPredicates(phi)
% 
% Input:
%  - phi : the formula from which the predicates are extraced
% 
% Output:
%  - mus : the list of predicates in phi. If phi is a predicate, mus equals
%          phi
%

mus = [];

if strcmp(phi.type, 'predicate')
    mus = phi;
    return;
end

if ~isempty(phi.phi)
    mus = [mus, QMITL_ExtractPredicates(phi.phi)];
end
if ~isempty(phi.phi1)
    mus = [mus, QMITL_ExtractPredicates(phi.phi1)];
end
if ~isempty(phi.phi2)
    mus = [mus, QMITL_ExtractPredicates(phi.phi2)];
end
if ~isempty(phi.phin)
    for ii=1:numel(phi.phin)
        mus = [mus, QMITL_ExtractPredicates(phi.phin(ii))]; %#ok<AGROW>
    end
end

end
