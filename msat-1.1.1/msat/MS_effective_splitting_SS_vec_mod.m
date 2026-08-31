function [fast_eff, tlag_eff] = MS_effective_splitting_SS_vec_mod(f, spol_vec, fast, tlag)
    % spol_vec: row vector of backazimuths (degrees)
    % fast, tlag: row vectors of layer fast directions and delay times
    % Returns row vectors of the same length as spol_vec.
    
    w = 2*pi*f;
    n = length(fast);
    spol_vec = spol_vec(:).';   % ensure row
    fast = fast(:);              % column
    tlag = tlag(:);              % column
    
    % Model-level (constant across backazimuth) quantities
    th = w*tlag/2;               % column, length n
    S = prod(cos(th));           % scalar
    tan_th = tan(th);            % column
    
    % Layer-pair sums for ap and app — independent of spol
    ap_sum = 0; app_sum = 0;
    for i = 1:n-1
        for j = i+1:n
            d = 2*(fast(i) - fast(j))*pi/180;    % al(i)-al(j), constant
            ap_sum  = ap_sum  + tan_th(i)*tan_th(j)*cos(d);
            app_sum = app_sum + tan_th(i)*tan_th(j)*sin(d);
        end
    end
    ap  = S*(1 - ap_sum);        % scalar
    app = S*app_sum;             % scalar
    
    % Backazimuth-dependent: al is a matrix, layers x azimuths
    al = 2*(fast - spol_vec)*pi/180;   % n x length(spol_vec) via broadcasting
    
    % Cc, Cs: row vectors of length length(spol_vec)
    Cc = S * sum(tan_th .* cos(al), 1);
    Cs = S * sum(tan_th .* sin(al), 1);
    
    % Effective splitting: atan on arrays
    ala = atan((app^2 + Cs.^2) ./ (app*ap + Cs.*Cc));
    tha = atan(app ./ (Cs.*cos(ala) - Cc.*sin(ala)));
    
    fast_eff = spol_vec + (ala*180/pi)/2;
    tlag_eff = 2*tha/w;
    
    % Unwind fast to (0, 180]
    fast_eff = mod(fast_eff, 180);
    flip = tlag_eff < 0;
    fast_eff(flip) = mod(fast_eff(flip) + 90, 180);
    tlag_eff = abs(tlag_eff);

end