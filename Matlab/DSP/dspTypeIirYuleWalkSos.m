classdef dspTypeIirYuleWalkSos < dspType
    properties
        nDim = 3;
        name = 'iirywsos'
    end
    
    methods
        function obj = dspTypeIirYuleWalkSos(n)
            obj = obj@dspType(n);
        end
        
        function dim = dimensionSize(self,n)
            switch n
                case 1
                    dim = self.n/2+1; % Which filter
                case 2
                    dim = 2; % a/b
                case 3
                    dim = 2; % which coefficient
            end
        end
        
        function filt = renderFilter(self, f, mag)
            [b,a] = yulewalk(self.n, f, mag);
            [coeffs,g] = tf2sos(b,a);
            while (size(coeffs,1) < self.n/2)
                coeffs = [coeffs ; coeffs(1,:)];
            end
            
            for i = 1:size(coeffs,1)
                filt.B(i,:) = coeffs(i,1:3);
                filt.A(i,:) = coeffs(i,4:6);
            end
            
            filt.G = g;
        end
    end
end